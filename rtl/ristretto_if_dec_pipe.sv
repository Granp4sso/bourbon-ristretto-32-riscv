`include "pkg/ristretto_if_stage_pkg.sv"
`include "pkg/ristretto_dec_stage_pkg.sv"

/*
	Instruction to Decode Pipeline Register v0.1 27/06/2022

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	
	******|| INTERFACES 	||******


	******|| REMARKABLE 	||******

	

	******|| NOTES		||******

	Pipelines registers takes N inputs and outputs them whenever they can be processed by the next stage.
	They are controlled by the global Pipeline Control Unit.


*/

import ristretto_if_stage_pkg::*; 
import ristretto_dec_stage_pkg::*; 
  
module ristretto_if_dec_pipe #(

	parameter unsigned DataWidth = 32
)(

	input logic 			clk_i,
	input logic 			rstn_i,

	/* Input Fetch Stage signals */

	input logic[DataWidth-1:0] 	pip_instr_i,
	input logic			pip_new_instr_i,
	input logic			pip_pb_instr_tag_i,
	input logic[1:0]		pip_penality_i,

	/* Output Decode Stage signals */

	output logic[DataWidth-1:0] 	pip_instr_o,
	output logic			pip_new_instr_o,
	output logic			pip_pb_instr_tag_o,
	output logic[1:0]		pip_penality_o,

	/* Others */

	input logic[DataWidth-1:0]	pip_next_pc_i,
	output logic[DataWidth-1:0]	pip_next_pc_o,

	/* Pipeline Control Unit signals*/

	input logic 			pip_stall_i,
	input logic			pip_flush_i
	
);

	logic[DataWidth-1:0] 	pip_instr_int;
	logic			pip_new_instr_int;
	logic[DataWidth-1:0]	pip_next_pc_int;	
	logic[1:0]		pip_penality_int;
	logic			pip_pb_instr_tag_int;
	
	logic			pip_new_instr_ff_int;
	logic			pip_new_instr_pending_ff_int;

	always_ff@(posedge clk_i) begin : reg_process
		if( rstn_i == 1'b0 ) begin
			pip_instr_int <= 32'h00000013;
			pip_new_instr_int <= '0;
			pip_next_pc_int <= '0;
			pip_penality_int <= '0;
			pip_pb_instr_tag_int <='0;
			
			pip_new_instr_ff_int <= '0;
			pip_new_instr_pending_ff_int <= '0;
		end
		else if( ~pip_stall_i/* & ~pip_flush_i*/ ) begin
		
			if( pip_new_instr_i | pip_new_instr_pending_ff_int ) begin
			
				pip_instr_int <= (  ~pip_flush_i  ) ? pip_instr_i : 32'h00000013;
				pip_next_pc_int <= pip_next_pc_i;
				pip_penality_int <= (  ~pip_flush_i  ) ? pip_penality_i : 2'b01;
				pip_pb_instr_tag_int <= (  ~pip_flush_i  ) ? pip_pb_instr_tag_i : '0;
					
				pip_new_instr_ff_int <= 1'b1;
				pip_new_instr_pending_ff_int <= 1'b0;
			end
			else begin
				pip_new_instr_ff_int <= 1'b0;
			end
			
		end
		else if( pip_stall_i /*& ~pip_flush_i*/ ) begin
		
			if( pip_new_instr_i ) begin
				pip_new_instr_pending_ff_int <= 1'b1;
				pip_new_instr_ff_int <= 1'b0;
			end
			
		end
		/*else if( pip_flush_i ) begin
		
			pip_new_instr_pending_ff_int <= 1'b0;
			pip_new_instr_ff_int <= 1'b0;
			
		end*/
	end
	
	assign pip_instr_o = pip_instr_int;
	assign pip_new_instr_o = pip_new_instr_ff_int;
	assign pip_next_pc_o = pip_next_pc_int;
	assign pip_penality_o = pip_penality_int;
	assign pip_pb_instr_tag_o = pip_pb_instr_tag_int;	


endmodule

