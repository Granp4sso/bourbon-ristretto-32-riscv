`include "pkg/ristretto_exe_stage_pkg.sv"

/*
	Shift Unit v0.3 27/08/2022

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	-AddrWidth :		Width of addresses
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	
	-sshft_operand_a_i :		Shift Unit Data to be shifted 
	-sshft_operand_b_i :		Shift Unit shift ammount
	-sshft_mode_i :			Shift unit operation mode (left, right or arithmetic right)
	-sshft_en_i :			Shift Unit Enable, coming from the execution control unit
	-sshft_busy_o :			Shift Unit busy signal. It means it is still performing the operation
	-sshft_result_o :			Shift unit shifted data. NB: 0 and 1 bits shifts are combinatorially performed outside the Shift Unit

	******|| REMARKABLE 	||******
	
	shift_proc:
	
		According to the operation required, the shift unit will perform a sequential left or right shift. It can also perform an arithmetic shift.
		In the future it will probabily support rotations as well.


	******|| NOTES		||******

	It takes opB + 2 clock cycles to complete the entire Shift Instruction cycle.
	It takes 1 clock cyckes to shift 0 and 1


*/

import ristretto_exe_stage_pkg::*;

module ristretto_sequential_shifter #(

	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32
)
(	
	input logic 					clk_i,
	input logic 					rstn_i,

	input logic[DataWidth-1:0] 		sshft_operand_a_i,
	input logic[4:0] 				sshft_operand_b_i,
	input logic[1:0] 				sshft_mode_i,
	input logic	 					sshft_en_i,

	output 							sshft_busy_o,
	output logic[DataWidth-1:0] 	sshft_result_o

);

	logic 					sshft_busy_int;
	logic[DataWidth-1:0] 	sshft_result_int;
	logic[4:0] 				shiftreg_cnt_int;
	logic					sshft_end;

	always_ff@(posedge clk_i) begin: shift_proc
		if( rstn_i == 1'b0 ) begin

			sshft_result_int <= '0;
			sshft_busy_int <= 1'b0;
			shiftreg_cnt_int <= '0;
			sshft_end <= 1'b0;

		end
		else if( sshft_en_i == 1'b1 & sshft_end == 1'b0 ) begin
		
			sshft_busy_int <= 1'b1;
			
			if( sshft_mode_i == SHIFT_LEFT ) begin	//Left Shift
				if(shiftreg_cnt_int == '0) begin
					sshft_result_int <= {sshft_operand_a_i[DataWidth-2:0],1'b0};
				end
				else begin
					sshft_result_int <= {sshft_result_int[DataWidth-2:0],1'b0};
				end
				shiftreg_cnt_int <= shiftreg_cnt_int+5'h01;
			end

			else if( sshft_mode_i == SHIFT_RIGHT ) begin //Right Shift
				if(shiftreg_cnt_int == '0) begin
					sshft_result_int <= {1'b0,sshft_operand_a_i[DataWidth-1:1]};
				end
				else begin
					sshft_result_int <= {1'b0,sshft_result_int[DataWidth-1:1]};
				end
				shiftreg_cnt_int <= shiftreg_cnt_int+5'h01;
			end

			else if( sshft_mode_i == SHIFT_ARIGHT ) begin //Right Arithmetic Shift
				if(shiftreg_cnt_int == 0) begin
					sshft_result_int <= ( sshft_operand_a_i[DataWidth-1] == 1'b1 ) ? {1'b1,sshft_operand_a_i[DataWidth-1:1]} : {1'b0,sshft_operand_a_i[DataWidth-1:1]};
				end
				else begin
					sshft_result_int <= ( sshft_operand_a_i[DataWidth-1] == 1'b1 ) ? {1'b1,sshft_result_int[DataWidth-1:1]} : {1'b0,sshft_result_int[DataWidth-1:1]};
				end
				shiftreg_cnt_int <= shiftreg_cnt_int+5'h01;
			end


			if( shiftreg_cnt_int >= sshft_operand_b_i - 1) begin
				
				sshft_end <= 1'b1;
				sshft_busy_int <= 1'b0; 
				shiftreg_cnt_int <= '0;
				
			end
		end
		else begin
			sshft_busy_int <= 1'b0;
			shiftreg_cnt_int <= '0;
			sshft_end <= 1'b0;
		end
	end


	assign sshft_busy_o = sshft_busy_int;
	assign sshft_result_o = sshft_result_int;


endmodule;
