//`include "pkg/beta_pkg.sv"

/*
	Decode to Execute Pipeline Register v0.1 28/06/2022

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	
	******|| INTERFACES 	||******


	******|| REMARKABLE 	||******

	

	******|| NOTES		||******

	Pipelines registers takes N inputs and outputs them whenever they can be processed by the next stage.
	They are controlled by the global Pipeline Control Unit.


*/

module beta_dec_exe_pipe import beta_pkg::*; #(

	parameter unsigned DataWidth = 32
)(

	input logic 			clk_i,
	input logic 			rstn_i,

	/* Input Decode Stage signals */

	input logic[11:0] 		pip_offset12_i,
	input logic[19:0]		pip_offset20_i,
	input logic[DataWidth-1:0] 	pip_operand_a_i,
	input logic[DataWidth-1:0] 	pip_operand_b_i,
	input logic[4:0] 		pip_rd_addr_i,
	input dec_control_word_t 	pip_control_word_i,
	input logic[DataWidth-1:0]	pip_next_pc_i,
	input logic			pip_new_instr_i,
	input logic[1:0]		pip_penality_i,
	
	/* Illegal Instruction Exception Signals */
	
	input logic			pip_invalid_instr_i,
	input logic[DataWidth-1:0] 	pip_invalid_instrval_i,

	/* Output Execution Stage signals */

	output logic[11:0] 		pip_offset12_o,
	output logic[19:0]		pip_offset20_o,
	output logic[DataWidth-1:0] 	pip_operand_a_o,
	output logic[DataWidth-1:0] 	pip_operand_b_o,
	output logic[4:0] 		pip_rd_addr_o,
	output dec_control_word_t 	pip_control_word_o,
	output logic[DataWidth-1:0]	pip_next_pc_o,
	output logic			pip_new_instr_o,	
	output logic[1:0]		pip_penality_o,
	
	/* Illegal Instruction Exception Signals */
	
	output logic			pip_invalid_instr_o,
	output logic[DataWidth-1:0] 	pip_invalid_instrval_o,

	/* Pipeline Control Unit signals*/

	input logic 			pip_stall_i,
	input logic			pip_flush_i
	
);

	logic[11:0] 		pip_offset12_int;
	logic[19:0]		pip_offset20_int;
	logic[DataWidth-1:0] 	pip_operand_a_int;
	logic[DataWidth-1:0] 	pip_operand_b_int;
	logic[4:0] 		pip_rd_addr_int;
	dec_control_word_t 	pip_control_word_int;	
	logic[DataWidth-1:0]	pip_next_pc_int;
	logic			pip_new_instr_int;
	logic			pip_invalid_instr_int;
	logic[DataWidth-1:0] 	pip_invalid_instrval_int;
	logic[1:0]		pip_penality_int;

	/* The new instruction signal lasts for 1 clock cycles and it cannot be stalled */

	always_ff@(posedge clk_i) begin : reg_process		
		if( rstn_i == 1'b0 | pip_flush_i == 1'b1 ) begin
			pip_offset12_int <= '0;
			pip_offset20_int <= '0;
			pip_operand_a_int <= '0;
			pip_operand_b_int <= '0;
			pip_rd_addr_int <= '0;
			pip_control_word_int <= '0;
			pip_next_pc_int <= '0;	
			pip_new_instr_int <= '0;
			pip_invalid_instr_int <= '0;
			pip_invalid_instrval_int <= '0;
			pip_penality_int <= '0;
		end
		else if( pip_stall_i == 1'b0 ) begin			//if an interrupt occurs, wait untill it has been correctly handled before overwriting the next
			pip_offset12_int <= pip_offset12_i;
			pip_offset20_int <= pip_offset20_i;
			pip_operand_a_int <= pip_operand_a_i;
			pip_operand_b_int <= pip_operand_b_i;
			pip_rd_addr_int <= pip_rd_addr_i;
			pip_control_word_int <= pip_control_word_i;
			pip_next_pc_int <= pip_next_pc_i;
			pip_invalid_instr_int <= pip_invalid_instr_i;
			pip_invalid_instrval_int <= pip_invalid_instrval_i;
			pip_penality_int <= pip_penality_i;
		end
		
		pip_new_instr_int <= pip_new_instr_i;
	end
	
	assign pip_offset12_o = pip_offset12_int;
	assign pip_offset20_o = pip_offset20_int;
	assign pip_operand_a_o = pip_operand_a_int;
	assign pip_operand_b_o = pip_operand_b_int;
	assign pip_rd_addr_o = pip_rd_addr_int;
	assign pip_control_word_o = pip_control_word_int;
	assign pip_next_pc_o = pip_next_pc_int;
	assign pip_new_instr_o = pip_new_instr_int;
	assign pip_invalid_instrval_o = pip_invalid_instrval_int;
	assign pip_invalid_instr_o = pip_invalid_instr_int;
	assign pip_penality_o = pip_penality_int;

endmodule

