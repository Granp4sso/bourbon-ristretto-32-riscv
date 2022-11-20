//`include "ristretto_def.sv"

/*
	Trap Control Unit v0.8 30/09/2022

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines
	-AddrWidth :		Width of addresses
	
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
		For each event, we define a latch. We have latches for the lsu, shu, one for traps and one for next instructions and pending instructions.
		we lso have a latch for a single cycle instruction and for multi cycle instructions.
		multi-cycle units will always have a 2-bit ff we'll describe later.
		
		The trap latch is actually made of 2 ffs. one for Exceptions and one for interrupts. basically, until a new instruction is fetched, we must
		preserve the trap_detected_signal (penality NOPs would overwrite their behaviour otherwise), so we memorize the exception or interrupt occurrence.
		Then we have some checks to handle interrupts occurring during both a single cycle and a multi cycle operation.
		
		The write latch is a ff used to set the write signal only once and for 1 clock cycle for instruction. multi-cycle ff is used to allow just one write. single-cycle ff
		seems useless, so it can be removed (I have to make a double check though).
		
		New instruction latch is quite important. Variations are allowed only once for instruction, that's why we must specify when a new instruction is fetched.
		However, each stage won't last for just 1 clock cycles, because of the instruction memory protocol always taking at least 3 clock cycles.
		Therefore we must ensure the signal to be high for exactly one clock cycle for each instruction. 
		This mechanism could be actually simplified in the future, but I need to refactor the pipelining system.
		Because it is possible for multi-cycle instructions to last so much that a new instruction can be correctly fetched from memory and reach the execution stage before its
		end, we must provide one new_instruction_pending signal, so that we won't skip such instruction.
		
		The event handling structure is a quite-regular solution, but it has to be simplified a bit for the new instructions and possibly the trap.
		
	
	Multi-cycle protocols:
	
	The protocol is very simple.
	if a multi-cycle op on a unit U has been requested and no other operation on U is enclosing the protocol, and no exception has been detected, then
	enable U, wait for U to lower its busy signal, then lower the enable of U.
	U-fsm and U-latch will allow for the state machine to properly work. In the end we got 2 clock cycles latency + the Unit required clk cycles to complete.
	There is clearly some redundancy, because U-fsm and U-latch have basically the same meaning, so there is room for optimization.
	
	The exe stage is busy only when a multi-cycle operation occurs. At the moment we only have 2 types of them:
		-Shift operations
		-Load & Store operations	
	
		
	******|| NOTES		||******

	This unit is meant to drive control signals coming from the decode stage to task domains/operative units in the exe_stage
	In the future it could be split into several CUs belongs to a wider control domain
	The state machine protocols could be compacted in one machine receiving a flag as a condion (depending on the requested sequential
	structure to be driven) and a MUX for selecting the correct group of signals.
	
	the control word signal exe_sys_priv_en is not yet used. I don't remember exactly why I added it lol.

*/

import ristretto_exe_stage_pkg::*;

module ristretto_exe_cu #(
	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32
)
(
	input logic 		clk_i,
	input logic 		rstn_i,
	
	exe_control_word_t	execu_control_word_i,
	input logic		execu_new_instr_i,	

	/*Arithmetic & Logic Unit Port */
	//input logic 		execu_alu_op_end_i,
	output exe_alu_op_t	execu_alu_op_o,

	/*Shift Unit Port*/
	input logic[1:0]	execu_shu_size_i, 	//Encoded shift size ({|opB[4:1],opB[0]} -> 00 Zero shift, 01 One Shift, 11/10 Multiple bits shift)
	input logic 		execu_shu_busy_i,
	output logic[1:0] 	execu_shu_mode_o,
	output logic	 	execu_shu_en_o,
	
	/*Branch & Jump Unit Port*/
	output exe_bju_op_t	execu_bju_op_o,
	input logic		execu_bju_btaken_i,

	/*Load & Store Unit Port*/
	input logic 		execu_lsu_busy_i,
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

	//input logic		execu_dec_stage_busy_i,
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
	
	//Event Handler FFs
	
	logic 		multi_cycle_op;
	logic		execu_reg_wr_en_int;
	logic[1:0]     	event_latch;
	logic[1:0] 	shift_latch;
	logic[1:0] 	lsu_latch;
	logic[1:0]	trap_latch;		//Record the event of a trap occurred
	logic	   	mc_write_latch;		//Multicycle write latch
	//logic 	sc_write_latch;		//Singlecycle write latch
	logic 		new_instr_latch;	
	logic 		new_instr_pend_latch;
	logic		event_flag;		//This flag notifies that a seq. operation has completed (i.e. an event occurred)

	/* Trap Detection Process */
	
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
	
	//Arithmetic & Logic Unit Protocol

	always_comb begin: ALU_protocol
			execu_alu_op_int = {
				execu_control_word_i.exe_alu_unsigned_n_en,
				execu_control_word_i.exe_alu_add_en,
				execu_control_word_i.exe_alu_sub_en,
				execu_control_word_i.exe_alu_logic_en
			};
	end


	//Branch & Jump Unit Protocol

	always_comb begin: BJU_protocol
			execu_bju_op_int = {
				execu_control_word_i.exe_condition_sel,
				execu_control_word_i.exe_condition_neg,
				execu_control_word_i.exe_bju_en
			};
	end
	
	//CSR Unit Protocol

	always_comb begin: CSR_protocol
			execu_csr_op_int = execu_control_word_i.exe_csr_op;
			//every CSR opcode writes into the main regfile once, so we can reuse this signal. It contains Exception Condition 1 as well because of the wr_en_int
			execu_csr_en_int = execu_control_word_i.exe_csr_en & execu_reg_wr_en_int;	
	end
	
	//Selection Path Protocol
	
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
	

	//Shift Unit Protocol
	
	logic [1:0] shift_fsm;
	assign execu_shu_mode_int = execu_control_word_i.exe_shu_shift_en;

	always_ff @(posedge clk_i) begin : shu_protocol

		if( rstn_i == 1'b0 ) begin
			execu_shu_en_int <= 1'b0;
			shift_fsm <= '0;
		end
		else if( execu_shu_mode_int != SHIFT_NONE & execu_shu_size_i >= 2'b10 & ~shift_latch[1] & ~execu_trap_taken_int[1] ) begin	//Shift latch must be < 0b10, (Exception Condition 2)
			case(shift_fsm)
				2'b00: begin
					if((execu_shu_en_int == 1'b0 | execu_shu_busy_i == 1'b0) &  new_instr_latch)begin
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

	//Load & Store Unit Protocol
	
	logic [1:0] lsu_fsm;
	assign execu_lsu_op_int = execu_control_word_i.exe_mem_op;
	assign execu_lsu_op_size_int = execu_control_word_i.exe_mem_op_size;

	always_ff @(posedge clk_i) begin : lsu_protocol

		if( rstn_i == 1'b0 ) begin
			execu_lsu_en_int <= 1'b0;
			lsu_fsm<= '0;
		end
		else if( execu_control_word_i.exe_mem_op_en == 1'b1 & ~lsu_latch[1] & ~execu_trap_taken_int[1] ) begin	//LSU latch must be < 0b10 , (Exception Condition 2)
			case(lsu_fsm)
				2'b00: begin
					if((execu_lsu_en_int == 1'b0 | execu_lsu_busy_i == 1'b0)  &  new_instr_latch) begin
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

	/* Event Handler Units : it is meant to handle events such as multicycle opcodes and write requests */
	assign execu_reg_wr_en_int = mc_write_latch | (~multi_cycle_op & execu_new_instr_i & execu_control_word_i.exe_reg_wr_en ) & ~execu_trap_taken_int[1];
	
	assign multi_cycle_op = ( execu_shu_mode_int != SHIFT_NONE & execu_shu_size_i >= 2'b10 ) | execu_control_word_i.exe_mem_op_en;	//This signal will depend on the triggering event signals
	//assign execu_reg_wr_en_int = mc_write_latch | (~multi_cycle_op & new_instr_latch & execu_control_word_i.exe_reg_wr_en ) & ~execu_trap_taken_int[1]; //(Exception Condition 1)
	assign event_flag = ( shift_latch == 2'b10 ) | 	( lsu_latch == 2'b10 )	;
	
	//in this way we avoid 1 clk delay for the trap_taken to reset
	assign execu_trap_taken_int[1] = execu_trap_detected_i[1] | (trap_latch[1] & ~execu_new_instr_i) ; 
	assign execu_trap_taken_int[0] = (execu_trap_detected_i[0] & execu_new_instr_i) | (trap_latch[0] & ~execu_new_instr_i ) | (trap_latch[0] & multi_cycle_op); 
	 
	always_ff@(posedge clk_i) begin: latch_events
		if(rstn_i == 1'b0) begin
			shift_latch <= 2'b00;
			lsu_latch <= 2'b00;
			
			mc_write_latch <= 1'b0;
			trap_latch <= 2'b00;
			
			new_instr_latch <= '0;
		end
		else begin //If an exception occurs, no sequential unit will be enabled
			// Shift Unit Event Handler
			if( execu_shu_busy_i == 1'b1 ) begin shift_latch <= 2'b01;  end 				//Record start op
			else if( shift_latch == 2'b01 & execu_shu_busy_i == 1'b0) begin shift_latch <= 2'b10; end 	//Record end op
			else if( shift_latch == 2'b10 ) begin shift_latch <= 2'b11; end					//Write back
			else if( shift_latch == 2'b11 ) begin shift_latch <= 2'b00; end			 		//Reset

			// Load & Store unit Event Handler 
			if( execu_lsu_busy_i == 1'b1 ) begin lsu_latch <= 2'b01;  end 					//Record start op
			else if( lsu_latch == 2'b01 & execu_lsu_busy_i == 1'b0) begin lsu_latch <= 2'b10; end		//Record end op
			else if( lsu_latch == 2'b10 ) begin lsu_latch <= 2'b11; end					//Write back
			else if( lsu_latch == 2'b11 ) begin lsu_latch <= 2'b00; end 					//Reset
			
			// Trap occurred event handler: When a new instruction is received upon a trap, reset the trap latch 
			
			if( (execu_trap_detected_i[1] ) & ~trap_latch[1] & execu_new_instr_i ) begin trap_latch[1] <= execu_trap_detected_i[1]; end
			else if( (trap_latch[1]) & execu_new_instr_i ) begin trap_latch[1] <= 1'b0; end	
			
			if( (execu_trap_detected_i[0] ) & ~trap_latch[0] & execu_new_instr_i ) begin trap_latch[0] <= execu_trap_detected_i[0]; end
			else if( (trap_latch[0]) & execu_new_instr_i & ~multi_cycle_op ) begin //SC instructions
				trap_latch[0] <= 1'b0;			
			end 
			/*else if( (trap_latch[0]) & (execu_new_instr_i & ~new_instr_latch) & multi_cycle_op ) begin //MC instructions
				trap_latch[0] <= 1'b0;			
			end */
			
			// Write signal Event Handler : An exception will abort any Multicycle/singlecycle operation
			if( multi_cycle_op ) begin 
				if( event_flag & execu_control_word_i.exe_reg_wr_en ) begin mc_write_latch <= 1'b1; end
				else begin mc_write_latch <= 1'b0; end
			end
			
			//New Instruction Event Handler 
			 
			if( execu_new_instr_i & ~new_instr_latch ) begin new_instr_latch <= 1'b1; end
			else if( new_instr_latch /*& ~execu_exe_stage_busy_int*/ ) begin new_instr_latch <= 1'b0; end
		end
	end
	
	assign execu_reg_wr_en_o = execu_reg_wr_en_int;				
	

	//Alu and BJU are totally combinatorial at the moment
	assign execu_exe_stage_busy_int	= 
		( ~execu_trap_taken_int[1] ) & (								//Exception Condition 3
		(~(execu_shu_mode_int == SHIFT_NONE | execu_shu_size_i <= 2'b01 | shift_latch == 2'b11 )) | 	//Shift unit condition
		(~(execu_control_word_i.exe_mem_op_en == 1'b0 | lsu_latch == 2'b11))				//LSU unit condition;
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
