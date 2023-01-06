//`include "ristretto_def.sv"

/*
	Trap Control Unit v0.9 02/01/2023

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines
	-AddrWidth :		Width of addresses
	-ShiftUnit : 		ShiftUnitSequential or ShiftUnitBarrel
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	-execu_control_word_i :		Control Word coming from the Decode Stage
	-execu_new_instr_i :		New instruction signal. A new instruction has been injected into the exe stage
	-execu_alu_op_o :		From the control word, enable the ALU
	-execu_shu_size_i :		Encoded shift size ({|operand B[4:1],operand B[0]} -> 00 Zero shift, 01 One Shift, 11/10 Multiple bits shift)
	-execu_shu_busy_i :		Shift Unit busy signal. It is used for the execu multi-cycle units protocol.
	-execu_shu_mode_o :		Shift Unit operational mode. (Left, Right, Right Rotate)
	-execu_shu_en_o :		From the control word, enable the Shift Unit
	-execu_bju_op_o :		From the control word, enable the BJU to operate (Branches, Jals or Jalrs)
	-execu_bju_btaken_i :		The branch was taken from the BJU
	-execu_lsu_busy_i :		Load & Store unit busy signal. It is used for the execu multi-cycle units protocol.
	-execu_lsu_op_size_o :		From the control word, specifty the memory data transaction size (Byte, Halfword, Word)
	-execu_lsu_op_o :		From the control word, specify the memory operation (Load or Store)
	-execu_lsu_en_o :		From the control word, enable the Load & Store unit
	-execu_csr_op_o :		From the control word, specify the csr operation (write,set,reset)
	-execu_csr_en_o :		From the control word, enable the CSR regfile 
	-execu_trap_detected_i :	The TCU detected a trap
	-execu_trap_ret_i :		An enviromental return (MRET) has been detected
	-execu_trap_nextpc_sel_o :	Exe stage next pc multiplexer selection signal in case of a trap
	-execu_trap_taken_o :		Latched version of the trap detected signal. This one is used to actually enforce trap mechanisms into the datapath.
	-execu_result_sel_o :		Exe stage result multiplexer selection signal
	-execu_nextpc_sel_o :		Exe stage next pc multiplexer selection signal before a trap
	-execu_exe_stage_busy_o :	Exe stage is busy (e.g. because of multi-cycle op)
	-execu_reg_wr_en_o :		Write-back request to the main regfile

	******|| REMARKABLE 	||******
	
	The first combinatorial processes are used to drive the control word signals to the outside, enabling and configuring the right modules into the exe stage.
	The selection process is used to select the correct next pc and the correct results from the 2 main muxes into the exe stages.
	
	Event Handling:
	
		An event is a special condition causing a different behaviour than the conventional one (1 clk cycles instructions).
		For each event, we define a FF. We have FFs for the lsu, shu (if no barrrel shifter is supported), one for traps and one for next instructions and pending instructions.
		we also have a FF for multi cycle instructions.
		multi-cycle units will always have a 2-bit FF we'll describe later.
		
		The trap FF is actually made of 2 ffs : interrupt FFs (2-bit) and exception FF(1-bit). basically, until a new instruction is fetched, we must
		preserve the trap_detected_signal (penality NOPs would overwrite their behaviour otherwise), so we memorize the exception or interrupt occurrence.
		Then we have some checks to handle interrupts occurring before or after a new instruction signal.
		
		The write FF is used to set the write signal only once and for 1 clock cycle for instruction. multi-cycle ff is used to allow just one write.
		
		New instruction FF is quite important. Variations are allowed only once for instruction, that's why we must specify when a new instruction is fetched.
		However, even single cycle instructions won't last always 1 clock cycles ( because of the imem delay ).
		Therefore we must ensure the signal to be high for exactly one clock cycle for each instruction. 
		Because it is possible for multi-cycle instructions to last so much that a new instruction can be correctly fetched from memory and reach the execution stage before its
		end, a new instruction FF is provided.
			
	Multi-cycle protocols:
	
	The protocol is very simple.
	if a multi-cycle op on a unit U has been requested and no other operation on U is enclosing the protocol, and no exception has been detected, then
	enable U, wait for U to lower its busy signal, then lower the enable of U.
	U-fsm and U-FF will allow for the state machine to properly work. In the end we got 2 clock cycles latency + the Unit required clk cycles to complete.
	
	The exe stage is busy only when a multi-cycle operation occurs. At the moment we only have 2 types of them:
		-Shift operations ( optional )
		-Load & Store operations	
	
		
	******|| NOTES		||******

	This unit is meant to drive control signals coming from the decode stage to task domains/operative units in the exe_stage
	In the future it could be split into several CUs belongs to a wider control domain
	The state machine protocols could be compacted in one machine receiving a flag as a condion (depending on the requested sequential
	structure to be driven) and a MUX for selecting the correct group of signals.

*/

import ristretto_exe_stage_pkg::*;

module ristretto_exe_cu #(
	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32,
	parameter unsigned ShiftUnit = ShiftUnitSequential
)
(
	input  logic 		clk_i,
	input  logic 		rstn_i,
	
	exe_control_word_t	execu_control_word_i,
	input  logic		execu_new_instr_i,	

	/*Arithmetic & Logic Unit Port */
	output exe_alu_op_t	execu_alu_op_o,

	/*Shift Unit Port*/
	input  logic[1:0]	execu_shu_size_i, 	
	input  logic 		execu_shu_busy_i,
	output logic[1:0] 	execu_shu_mode_o,
	output logic	 	execu_shu_en_o,
	
	/*Branch & Jump Unit Port*/
	output exe_bju_op_t	execu_bju_op_o,
	input  logic		execu_bju_btaken_i,

	/*Load & Store Unit Port*/
	input  logic 		execu_lsu_busy_i,
	output logic[1:0] 	execu_lsu_op_size_o,
	output logic 		execu_lsu_op_o,
	output logic 		execu_lsu_en_o,
	
	/*CSR Unit Port*/
	output logic[2:0]	execu_csr_op_o,
	output logic		execu_csr_en_o,
	
	/*Trap Detection Port*/
	input  logic [1:0]	execu_trap_detected_i,
	input  logic 		execu_trap_ret_i,
	output logic [1:0]	execu_trap_nextpc_sel_o,
	output logic [1:0]	execu_trap_taken_o,

	/*Selection Path Port*/
	output logic[6:0] 	execu_result_sel_o,
	output logic	 	execu_nextpc_sel_o,

	//Inter Stages sync port

	output logic		execu_exe_stage_busy_o,
	output logic		execu_reg_wr_en_o
);

	exe_alu_op_t	execu_alu_op_int;
	exe_bju_op_t	execu_bju_op_int;
	logic[1:0] 	execu_shu_mode_int;
	logic	 	execu_shu_en_int;
	logic[6:0] 	execu_result_sel_int;
	logic	 	execu_nextpc_sel_int;
	logic		execu_exe_stage_busy_int;
	
	logic 		execu_lsu_en_int ;
	logic[1:0] 	execu_lsu_op_size_int;
	logic 		execu_lsu_op_int;
	
	logic[2:0]	execu_csr_op_int;
	logic		execu_csr_en_int;

	logic[1:0]	execu_trap_taken_int;
	logic		execu_reg_wr_en_int;
	

	/* #### Trap Detection Process #### */
	
	logic trap_exception_detected = execu_trap_detected_i[1];
	
	/*
		trap_detected_i is a 1 clk cycle signal. execu_trap_taken_int is its version lasting for the entire instruction
		
		If an exception occurs, 3 things must be taken into account:
			-1 : No GP/CSR Reg Write must be performed
			-2 : No Sequential Unit shall be enabled
			-3 : The execution unit will not be Busy
	*/
	
	always_comb begin: TRAP_Protocol
	
		execu_trap_nextpc_sel_o[0] = execu_trap_taken_int[1] | execu_trap_taken_int[0];
		execu_trap_nextpc_sel_o[1] = execu_trap_ret_i;	
	end
	
	/* #### Arithmetic & Logic Unit Protocol #### */

	always_comb begin: ALU_protocol
			execu_alu_op_int = {
				execu_control_word_i.exe_alu_unsigned_n_en,
				execu_control_word_i.exe_alu_add_en,
				execu_control_word_i.exe_alu_sub_en,
				execu_control_word_i.exe_alu_logic_en
			};
	end


	/* #### Branch & Jump Unit Protocol #### */

	always_comb begin: BJU_protocol
			execu_bju_op_int = {
				execu_control_word_i.exe_condition_sel,
				execu_control_word_i.exe_condition_neg,
				execu_control_word_i.exe_bju_en
			};
	end
	
	/* #### CSR Unit Protocol ####*/

	always_comb begin: CSR_protocol
			execu_csr_op_int = execu_control_word_i.exe_csr_op;
			//every CSR opcode writes into the main regfile once, so we can reuse this signal. It contains Exception Condition 1 as well because of the wr_en_int
			execu_csr_en_int = execu_control_word_i.exe_csr_en & execu_reg_wr_en_int;	
	end
	
	/* #### Selection Path Protocol #### */
	
	always_comb begin : sel_protocol
			execu_result_sel_int = {
				execu_control_word_i.exe_csr_en	& execu_control_word_i.exe_csr_op[2],	//Select CSR result
				execu_control_word_i.exe_mem_op_en & ~execu_control_word_i.exe_mem_op, 	//Memory op enabled AND Load
				execu_control_word_i.exe_add_pc_to_res_en, 				//AUIPC result
				execu_control_word_i.exe_slt_en,					//SLT result
				execu_shu_size_i,							//Shift Size fast-result
				execu_bju_op_int[1]							//Jumps save address
			};		
		
			execu_nextpc_sel_int = execu_bju_op_int[1] | ( ~execu_bju_op_int[1] & execu_bju_op_int[0] & execu_bju_btaken_i ); //Jump or a Taken Branch
	end
	

	/* #### Shift Unit Protocol #### */
	
	assign execu_shu_mode_int = execu_control_word_i.exe_shu_shift_en;

	if( ShiftUnit == ShiftUnitSequential ) begin

		logic [1:0] shift_fsm;

		always_ff @(posedge clk_i) begin : shu_protocol
			if( rstn_i == 1'b0 ) begin
				execu_shu_en_int <= 1'b0;
				shift_fsm <= '0;
			end
			else if( execu_shu_mode_int != SHIFT_NONE & execu_shu_size_i >= 2'b10 & ~event_shift_ff[1] & ~execu_trap_taken_int[1] ) begin	//Shift latch must be < 0b10, (Exception Condition 2)
				case(shift_fsm)
					2'b00: begin
						if((execu_shu_en_int == 1'b0 | execu_shu_busy_i == 1'b0) &  execu_new_instr_i)begin
							execu_shu_en_int <= 1'b1;
							shift_fsm <= 2'b01;
						end
					end
					2'b01: begin 
						if(execu_shu_busy_i == 1'b1) begin
							shift_fsm <= 2'b10;
						end
					end
					2'b10: begin
						if(execu_shu_busy_i == 1'b0) begin
							execu_shu_en_int <= 1'b0;
							shift_fsm <= 2'b00;
						end
					end
					default: begin execu_shu_en_int <= 1'b0; shift_fsm <= 2'b00; end
				endcase
			end
		end

	end
	else begin
			always_comb begin: BarrelShifter_protocol
				execu_shu_en_int = |execu_shu_mode_int;
			end
	end

	/* #### Load & Store Unit Protocol #### */ 
	
	logic [1:0] lsu_fsm;
	
	assign execu_lsu_op_int = execu_control_word_i.exe_mem_op;
	assign execu_lsu_op_size_int = execu_control_word_i.exe_mem_op_size;

	always_ff @(posedge clk_i) begin : lsu_protocol

		if( rstn_i == 1'b0 ) begin
			execu_lsu_en_int <= 1'b0;
			lsu_fsm<= '0;
		end
		else if( execu_control_word_i.exe_mem_op_en == 1'b1 & ~event_lsu_ff[1] & ~execu_trap_taken_int[1] ) begin	//LSU latch must be < 0b10 , (Exception Condition 2)
			case(lsu_fsm)
				2'b00: begin
					if((execu_lsu_en_int == 1'b0 | execu_lsu_busy_i == 1'b0)  &  execu_new_instr_i) begin
						execu_lsu_en_int <= 1'b1;
						lsu_fsm <= 2'b01;
					end
				end
				2'b01: begin 
					if(execu_lsu_busy_i == 1'b1) begin
						execu_lsu_en_int <= 1'b0;
						lsu_fsm <= 2'b10;
					end
				end
				2'b10: begin
					if(execu_lsu_busy_i == 1'b0) begin
						execu_lsu_en_int <= 1'b0;
						lsu_fsm <= 2'b00;
					end
				end
				default: begin execu_lsu_en_int <= 1'b0; lsu_fsm <= 2'b00; end
			endcase
		end
	end

	/* #### Event Handler Section #### */
		
	logic		event_flag_int;
	logic		event_over_int;
	logic		event_busy_int;
	logic 		event_mc_op_int;
	
	logic		event_new_instr_ff;
	logic[1:0]	event_interrupt_ff;
	logic		event_exception_ff;
	logic	   	event_mc_write_ff;
	logic[1:0] 	event_shift_ff;
	logic[1:0] 	event_lsu_ff;
			
	/* Multi Cycle signal depends on the units in the exe stage. In the future I will support a more general and elegant optional instantiation */

	if( ShiftUnit == ShiftUnitSequential ) begin
		assign event_mc_op_int = ( execu_shu_mode_int != SHIFT_NONE & execu_shu_size_i >= 2'b10 ) | execu_control_word_i.exe_mem_op_en;
	end
	else begin
		assign event_mc_op_int = execu_control_word_i.exe_mem_op_en;
	end

	assign event_busy_int = (event_new_instr_ff | (execu_new_instr_i & event_mc_op_int)) & ~event_over_int;
	assign event_flag_int = ( event_shift_ff == 2'b10 ) | ( event_lsu_ff == 2'b10 );
	assign event_over_int = ( event_shift_ff == 2'b11 ) | ( event_lsu_ff == 2'b11 );

	assign execu_reg_wr_en_int = event_mc_write_ff | (~event_mc_op_int & execu_new_instr_i & execu_control_word_i.exe_reg_wr_en ) & ~execu_trap_taken_int[1];

	assign execu_trap_taken_int[1] = execu_trap_detected_i[1] | (event_exception_ff & ~execu_new_instr_i) ; 
	assign execu_trap_taken_int[0] = ( ( event_interrupt_ff == 2'b01 ) & execu_new_instr_i ) | ( ( event_interrupt_ff == 2'b11 ) & ~execu_new_instr_i );
	 
	always_ff@(posedge clk_i) begin: latch_events
		if(rstn_i == 1'b0) begin
		
			event_new_instr_ff	<= '0;	
			event_interrupt_ff	<= '0;
			event_exception_ff	<= '0;
			event_mc_write_ff	<= '0;
			event_shift_ff		<= '0;
			event_lsu_ff		<= '0;
		end
		else begin //If an exception occurs, no sequential unit will be enabled
		
			// Shift Unit Event Handler
			if( execu_shu_busy_i == 1'b1 ) begin event_shift_ff <= 2'b01;  end 				//Record start op
			else if( event_shift_ff == 2'b01 & execu_shu_busy_i == 1'b0) begin event_shift_ff <= 2'b10; end 	//Record end op
			else if( event_shift_ff == 2'b10 ) begin event_shift_ff <= 2'b11; end				//Write back
			else if( event_shift_ff == 2'b11 ) begin event_shift_ff <= 2'b00; end			 	//Reset

			// Load & Store unit Event Handler 
			if( execu_lsu_busy_i == 1'b1 ) begin event_lsu_ff <= 2'b01;  end 				//Record start op
			else if( event_lsu_ff == 2'b01 & execu_lsu_busy_i == 1'b0) begin event_lsu_ff <= 2'b10; end		//Record end op
			else if( event_lsu_ff == 2'b10 ) begin event_lsu_ff <= 2'b11; end					//Write back
			else if( event_lsu_ff == 2'b11 ) begin event_lsu_ff <= 2'b00; end 					//Reset
			
			// Trap occurred event handler: When a new instruction is received upon a trap, reset the trap latch 
			if( (execu_trap_detected_i[1] ) & ~event_exception_ff & execu_new_instr_i ) begin event_exception_ff <= execu_trap_detected_i[1]; end
			else if( (event_exception_ff) & execu_new_instr_i ) begin event_exception_ff <= 1'b0; end	
			
			case( event_interrupt_ff )
				2'b00 : begin
					if( execu_trap_detected_i[0] ) event_interrupt_ff <= ( ~execu_new_instr_i ) ? 2'b01 : 2'b10;
				end
				2'b01 : begin
					if( execu_new_instr_i ) event_interrupt_ff <= 2'b11;
				end
				2'b10 : begin
					event_interrupt_ff <= 2'b01;
				end
				2'b11 : begin
					if( execu_new_instr_i  & ~event_mc_op_int ) event_interrupt_ff <= 2'b00;
					else if( execu_new_instr_i & event_mc_op_int & event_over_int ) event_interrupt_ff <= 2'b00;
				end
			endcase
			
			
			// Write signal Event Handler : An exception will abort any Multicycle/singlecycle operation
			if( event_mc_op_int ) begin 
				if( event_flag_int & execu_control_word_i.exe_reg_wr_en ) begin event_mc_write_ff <= 1'b1; end
				else begin event_mc_write_ff <= 1'b0; end
			end
			
			//New Instruction Event Handler 
			if( ~event_new_instr_ff & execu_new_instr_i & event_mc_op_int ) begin event_new_instr_ff <= 1'b1; end
			else if( event_new_instr_ff & event_over_int ) begin event_new_instr_ff <= 1'b0; end
			 
		end
	end
	
	/* Output Assignments Section */
	
	assign execu_reg_wr_en_o = execu_reg_wr_en_int;				
		
	assign execu_exe_stage_busy_int	= 
		( ~execu_trap_taken_int[1] ) & (								//Exception Condition 3
			event_busy_int
		);				

	assign execu_alu_op_o = execu_alu_op_int;
	assign execu_bju_op_o = execu_bju_op_int;

	assign execu_shu_mode_o = execu_shu_mode_int;
	assign execu_shu_en_o = execu_shu_en_int;

	assign execu_lsu_op_size_o = execu_lsu_op_size_int;
	assign execu_lsu_op_o = execu_lsu_op_int;
	assign execu_lsu_en_o = execu_lsu_en_int;
	
	assign execu_trap_taken_o = execu_trap_taken_int;

	assign execu_result_sel_o = execu_result_sel_int;
	assign execu_nextpc_sel_o = execu_nextpc_sel_int;
	assign execu_exe_stage_busy_o = execu_exe_stage_busy_int;
	
	assign execu_csr_op_o = execu_csr_op_int;
	assign execu_csr_en_o = execu_csr_en_int;

endmodule
