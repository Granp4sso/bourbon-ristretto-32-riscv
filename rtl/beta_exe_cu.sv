//`include "beta_def.sv"

/*
	Version 0.7
	9/07/2022

	This unit is meant to drive control signals coming from the decode stage to task domains/operative units in the exe_stage
	In the future it could be split into several CUs belongs to a wider control domain

	I have integrated the busy/sync/stall logic. At the moment it is very basic. 
	I added the pipeline, hence the busy signals does not depend anymore on the decode stage busy signal. However, the stage still
	never rises the busy signal in case of combinatorial calculations. (in the future I could change this).

	Cu also support the event handler at the moment.

	The state machine protocols could be compacted in one machine receiving a flag as a condion (depending on the requested sequential
	structure to be driven) and a MUX for selecting the correct group of signals.
	
	The event handler now supports the pipeline Write event.
	


*/

module beta_exe_cu import beta_pkg::*; #(
	parameter unsigned DataWidth = 32
)
(
	input logic 		clk_i,
	input logic 		rstn_i,
	
	exe_control_word_t	execu_control_word_i,
	input logic		execu_new_instr_i,	//beta

	/*Arithmetic & Logic Unit Port */
	input logic 		execu_alu_op_end_i,
	output exe_alu_op_t	execu_alu_op_o,

	/*Shift Unit Port*/
	input logic[1:0]	execu_shu_size_i, //Encoded shift size ({&opB[4:1],opB[0]} -> 00 Zero shift, 01 One Shift, 11/10 Multiple bits shift)
	input logic 		execu_shu_busy_i,
	output logic[1:0] 	execu_shu_mode_o,
	output logic	 	execu_shu_en_o,
	

	/*Branch & Jump Unit Port*/
	output exe_bju_op_t	execu_bju_op_o,
	input logic		execu_branch_taken_i,

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
	output logic [1:0]	execu_trap_nextpc_sel_o,
	output logic		execu_trap_taken_o,

	/*Selection Path Port*/
	output logic[6:0] 	execu_result_sel_o,
	output logic	 	execu_nextpc_sel_o,

	//Inter Stages sync port

	input logic		execu_dec_stage_busy_i,
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

	/* Trap Detection Process */
	
	logic trap_exception_detected = execu_trap_detected_i[1];
	
	/*
		trap_detected_i is a 1 clk cycle signal. execu_trap_taken_int is its version lastin for the entire instruction
		
		If an exception occurs, 3 things must be taken into account:
			-1 : No GP/CSR Reg Write must be performed
			-2 : No Sequential Unit shall be enabled
			-3 : The execution unit will not be Busy
	*/
	
	always_comb begin: TRAP_Protocol
	
		execu_trap_nextpc_sel_o[0] = execu_trap_taken_int[1] | execu_trap_taken_int[0];
		execu_trap_nextpc_sel_o[1] = 1'b0;	//This bit will serve for the xRET instruction
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
		
			execu_nextpc_sel_int = execu_bju_op_int[1] | ( ~execu_bju_op_int[1] & execu_bju_op_int[0] & execu_branch_taken_i ); //Jump or a Taken Branch
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
	logic 		multi_cycle_op;
	logic		execu_reg_wr_en_int;
	logic[1:0]     	event_latch;
	logic[1:0] 	shift_latch;
	logic[1:0] 	lsu_latch;
	logic[1:0]	trap_latch;		//Record the event of a trap occurred
	logic	   	mc_write_latch;		//Multicycle write latch
	logic 		sc_write_latch;		//Singlecycle write latch
	logic 		new_instr_latch;	
	logic 		new_instr_pend_latch;
	logic		event_flag;		//This flag notifies that a seq. operation has completed (i.e. an event occurred)
	
	assign multi_cycle_op = ( execu_shu_mode_int != SHIFT_NONE & execu_shu_size_i >= 2'b10 ) | execu_control_word_i.exe_mem_op_en;	//This signal will depend on the triggering event signals
	assign execu_reg_wr_en_int = mc_write_latch | (~multi_cycle_op & new_instr_latch & execu_control_word_i.exe_reg_wr_en ) & ~execu_trap_taken_int[1]; //(Exception Condition 1)
	assign event_flag = ( shift_latch == 2'b10 ) | 	( lsu_latch == 2'b10 )	;				
	assign execu_trap_taken_int = {execu_trap_detected_i[1] | (trap_latch[1] & ~execu_new_instr_i), execu_trap_detected_i[0] | (trap_latch[0] & ~execu_new_instr_i)}; //in this way we avoid 1 clk delay for the trap_taken to reset

	always_ff@(posedge clk_i) begin: latch_events
		if(rstn_i == 1'b0) begin
			//event_latch <= 2'b00;
			shift_latch <= 2'b00;
			lsu_latch <= 2'b00;
			
			mc_write_latch <= 1'b0;
			sc_write_latch <= 1'b0;
			trap_latch <= 2'b00;
			
			new_instr_latch <= '0;
			new_instr_pend_latch <= '0;
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
			if( (execu_trap_detected_i != TCU_NOTRAP) & trap_latch == TCU_NOTRAP) begin trap_latch <= execu_trap_detected_i; end
			else if( (trap_latch != TCU_NOTRAP) & execu_new_instr_i ) begin trap_latch <= TCU_NOTRAP; end 
			
			// Write signal Event Handler : An exception will abort any Multicycle/singlecycle operation
			if( multi_cycle_op ) begin 
				if( event_flag & execu_control_word_i.exe_reg_wr_en ) begin mc_write_latch <= 1'b1; end
				else begin mc_write_latch <= 1'b0; end
			end
			else begin
				if( new_instr_latch & ~sc_write_latch & execu_control_word_i.exe_reg_wr_en ) sc_write_latch <=  1'b1;
				else if ( sc_write_latch ) sc_write_latch <=  1'b0;
			end
			
			//New Instruction Event Handler : it is meant to latch the new instruction request and a pending one decoded while the exe stage was still busy 
			if( execu_new_instr_i & ~new_instr_latch ) begin new_instr_latch <= 1'b1; end
			else if( new_instr_latch & ~execu_exe_stage_busy_int ) begin new_instr_latch <= 1'b0; end
			
			if( execu_new_instr_i & new_instr_latch ) begin new_instr_pend_latch <= 1'b1; end
			
			if( new_instr_pend_latch & ~new_instr_latch ) begin new_instr_pend_latch <= 1'b0; new_instr_latch <= 1'b1; end
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
	
	assign execu_trap_taken_o = execu_trap_taken_int[1] | execu_trap_taken_int[0];

	assign execu_result_sel_o = execu_result_sel_int;
	assign execu_nextpc_sel_o = execu_nextpc_sel_int;
	assign execu_exe_stage_busy_o = execu_exe_stage_busy_int;
	
	assign execu_csr_op_o = execu_csr_op_int;
	assign execu_csr_en_o = execu_csr_en_int;

endmodule
