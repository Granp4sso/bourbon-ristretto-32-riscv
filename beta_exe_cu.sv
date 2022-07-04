//`include "beta_def.sv"

/*
	Version 0.6
	4/07/2022

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

	/*Load & Store Unit Port*/
	input logic 		execu_lsu_busy_i,
	output logic[1:0] 	execu_lsu_op_size_o,
	output logic 		execu_lsu_op_o,
	output logic 		execu_lsu_en_o,

	/*Selection Path Port*/
	output logic[5:0] 	execu_result_sel_o,
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
	logic[5:0] 	execu_result_sel_int;
	logic	 	execu_nextpc_sel_int;
	logic		execu_exe_stage_busy_int;
	
	logic 		execu_lsu_en_int ;
	logic[1:0] 	execu_lsu_op_size_int;
	logic 		execu_lsu_op_int;


	//Arithmetic & Logic Unit Protocol

	always_comb begin: ALU_protocol
		//if(~execu_dec_stage_busy_i) begin
			execu_alu_op_int = {
				execu_control_word_i.exe_alu_unsigned_n_en,
				execu_control_word_i.exe_alu_add_en,
				execu_control_word_i.exe_alu_sub_en,
				execu_control_word_i.exe_alu_logic_en
			};
		//end
		//else begin execu_alu_op_int = '0; end
	end


	//Branch & Jump Unit Protocol

	always_comb begin: BJU_protocol
		//if(~execu_dec_stage_busy_i) begin
			execu_bju_op_int = {
				execu_control_word_i.exe_condition_sel,
				execu_control_word_i.exe_condition_neg,
				execu_control_word_i.exe_bju_en
			};
		//end
		//else begin execu_bju_op_int = '0; end
	end
	
	//Selection Path Protocol
	
	always_comb begin : sel_protocol
		//if(~execu_dec_stage_busy_i) begin
			execu_result_sel_int = {
				execu_control_word_i.exe_mem_op_en & ~execu_control_word_i.exe_mem_op, //Memory op enabled AND Load
				execu_control_word_i.exe_add_pc_to_res_en, 	//AUIPC result
				execu_control_word_i.exe_slt_en,		//SLT result
				execu_shu_size_i,				//Shift Size fast-result
				execu_bju_op_int[1]				//Jumps save address
			};
		
			execu_nextpc_sel_int = execu_bju_op_int[1] | execu_bju_op_int[0];
		//end
		/*else begin
			execu_result_sel_int = '0;
			execu_nextpc_sel_int O '0;
		end*/

	end
	

	//Shift Unit Protocol
	
	logic [1:0] shift_fsm;
	assign execu_shu_mode_int = execu_control_word_i.exe_shu_shift_en;

	always_ff @(posedge clk_i) begin : shu_protocol

		if( rstn_i == 1'b0 ) begin
			execu_shu_en_int <= 1'b0;
			shift_fsm <= '0;
		end
		else if( execu_shu_mode_int != SHIFT_NONE & execu_shu_size_i >= 2'b10 & shift_latch != 2'b11 ) begin
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
		else if( execu_control_word_i.exe_mem_op_en == 1'b1 & lsu_latch != 2'b11 ) begin
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
	logic	   	mc_write_latch;		//Multicycle write latch
	logic 		sc_write_latch;		//Singlecycle write latch
	logic 		new_instr_latch;	
	logic 		new_instr_pend_latch;
	
	assign multi_cycle_op = ( execu_shu_mode_int != SHIFT_NONE ) | execu_control_word_i.exe_mem_op_en;	//This signal will depend on the triggering event signals
	assign execu_reg_wr_en_int = mc_write_latch | sc_write_latch ;

	always_ff@(posedge clk_i) begin: latch_events
		if(rstn_i == 1'b0) begin
			event_latch <= 2'b00;
			shift_latch <= 2'b00;
			lsu_latch <= 2'b00;
			
			mc_write_latch <= 1'b0;
			sc_write_latch <= 1'b0;
			
			new_instr_latch <= '0;
			new_instr_pend_latch <= '0;
		end
		else begin
			// Shift Unit Event Handler
			if( execu_shu_busy_i == 1'b1 ) begin event_latch <= 2'b01; shift_latch <= 2'b01;  end 					//Record start op
			else if( shift_latch == 2'b01 & execu_shu_busy_i == 1'b0) begin shift_latch <= 2'b10; event_latch <= 2'b10; end 	//Record end op
			else if( shift_latch == 2'b10 ) begin shift_latch <= 2'b11; event_latch <= 2'b11; end					//Write back
			else if( shift_latch == 2'b11 ) begin shift_latch <= 2'b00; event_latch <= 2'b00; end			 		//Reset

			// Load & Store unit Event Handler (OLD)
			if( execu_lsu_busy_i == 1'b1 ) begin event_latch <= 2'b01; lsu_latch <= 2'b01;  end 					//Record start op
			else if( lsu_latch == 2'b01 & execu_lsu_busy_i == 1'b0) begin lsu_latch <= 2'b10; event_latch <= 2'b10; end		//Record end op
			else if( lsu_latch == 2'b10 ) begin lsu_latch <= 2'b11; event_latch <= 2'b11; end					//Write back
			else if( lsu_latch == 2'b11 ) begin lsu_latch <= 2'b00; event_latch <= 2'b00; end 					//Reset
			
			// Write signal Event Handler
			if( multi_cycle_op ) begin 
				if( event_latch == 2'b10 & execu_control_word_i.exe_reg_wr_en ) begin mc_write_latch <= 1'b1; end
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
		(~(execu_shu_mode_int == SHIFT_NONE | execu_shu_size_i <= 2'b01 | shift_latch == 2'b11 )) | 	//Shift unit condition
		(~(execu_control_word_i.exe_mem_op_en == 1'b0 | lsu_latch == 2'b11));				//LSU unit condition;	

	assign execu_alu_op_o = execu_alu_op_int;
	assign execu_bju_op_o = execu_bju_op_int;

	assign execu_shu_mode_o = execu_shu_mode_int;
	assign execu_shu_en_o = execu_shu_en_int;

	assign execu_lsu_op_size_o = execu_lsu_op_size_int;
	assign execu_lsu_op_o = execu_lsu_op_int;
	assign execu_lsu_en_o = execu_lsu_en_int;

	assign execu_result_sel_o = execu_result_sel_int;
	assign execu_nextpc_sel_o = execu_nextpc_sel_int;
	assign execu_exe_stage_busy_o = execu_exe_stage_busy_int;

endmodule
