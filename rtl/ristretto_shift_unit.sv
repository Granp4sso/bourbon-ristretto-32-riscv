`include "pkg/ristretto_exe_stage_pkg.sv"

/*
	Shift Unit v0.1 06/01/2023

	******|| INSTANTIABLES 	||******

								- CodeType,	Mandatory,	Supported
		-Sequential Shifter 	- [UNIT		Y			Y	]
		-Barrel Shifter 		- [UNIT		N			Y	]

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	-AddrWidth :		Width of addresses
	-ShiftUnit : 		ShiftUnitSequential or ShiftUnitBarrel
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	
	-shu_operand_a_i :		Shift Unit Data to be shifted 
	-shu_operand_b_i :		Shift Unit shift ammount
	-shu_mode_i :			Shift unit operation mode (left, right or arithmetic right)
	-shu_en_i :				Shift Unit Enable, coming from the execution control unit
	-shu_busy_o :			Shift Unit busy signal. It means it is still performing the operation ( only for seqshftr )
	-shu_result_o :			Shift unit shifted data. NB: 0 and 1 bits shifts are combinatorially performed outside the Shift Unit

	******|| REMARKABLE 	||******

	******|| NOTES		||******

*/

import ristretto_exe_stage_pkg::*;

module ristretto_shift_unit #(

	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32,
	parameter unsigned ShiftUnit = ShiftUnitSequential

)
(
	input  logic 					clk_i,
	input  logic 					rstn_i,

	input  logic[DataWidth-1:0] 	shu_operand_a_i,
	input  logic[4:0] 				shu_operand_b_i,
	input  logic[1:0] 				shu_mode_i,
	input  logic	 				shu_en_i,

	output 							shu_busy_o,
	output logic[DataWidth-1:0] 	shu_result_o

);

	logic 					shu_busy_int;
	logic[DataWidth-1:0] 	shu_result_int;

	if( ShiftUnit == ShiftUnitSequential ) begin

		ristretto_sequential_shifter seqshft(
			.clk_i				(clk_i),
			.rstn_i				(rstn_i),

			.sshft_operand_a_i	(shu_operand_a_i),
			.sshft_operand_b_i	(shu_operand_b_i[4:0]),
			.sshft_mode_i		(shu_mode_i),
			.sshft_en_i			(shu_en_i),

			.sshft_busy_o		(shu_busy_int),
			.sshft_result_o		(shu_result_int)

		);

	end else begin

		ristretto_barrel_shifter barshft(
			.bshft_data_i		(shu_operand_a_i),
			.bshft_amt_i		(shu_operand_b_i[4:0]),
			.bshft_mode_i		(shu_mode_i),
			.bshft_en_i			(shu_en_i),
			.bshft_result_o		(shu_result_int)
		);

		assign shu_busy_int = 1'b0;
	end

	assign shu_busy_o = shu_busy_int;
	assign shu_result_o = shu_result_int;

endmodule;
