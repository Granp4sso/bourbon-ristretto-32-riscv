`include "pkg/ristretto_exe_stage_pkg.sv"

/*
	Barrel Shifter v0.1 03/01/2023

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	-AddrWidth :		Width of addresses
	
	******|| INTERFACES 	||******

	-bshft_data_i :		Shift Unit Data to be shifted 
	-bshft_amt_i :		Shift Unit shift ammount
	-bshft_mode_i :		Shift unit operation mode (left, right or arithmetic right)
	-bshft_en_i :			Shift Unit Enable, coming from the execution control unit
	-bshft_result_o :		Shift unit shifted data. NB: 0 and 1 bits shifts are combinatorially performed outside the Shift Unit

	******|| REMARKABLE 	||******

	******|| NOTES		||******


	A special thanks goes to PhD.Vincenzo Maisto who provided me with the baseline for this unit ;)


*/

import ristretto_exe_stage_pkg::*;

module ristretto_barrel_shifter #(

	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32
)
(

	input logic[DataWidth-1:0] 			bshft_data_i,
	input logic[$clog2(DataWidth)-1:0] 	bshft_amt_i,
	input logic[1:0] 					bshft_mode_i,
	input logic	 						bshft_en_i,
	
	output logic[DataWidth-1:0] 		bshft_result_o

);

	/* verilator lint_off UNOPTFLAT */ 
   	localparam NumStages = $clog2(DataWidth);
	localparam MuxPerStage = DataWidth;

    logic [MuxPerStage-1:0] data_mux_r           [NumStages:0];
	logic [MuxPerStage-1:0] data_mux_l           [NumStages:0];

	logic					rshift_val;

    assign data_mux_l[0][DataWidth-1:0] = bshft_data_i;
	assign data_mux_r[0][DataWidth-1:0] = bshft_data_i;
	assign rshift_val = ( bshft_mode_i == SHIFT_ARIGHT ) ? bshft_data_i[DataWidth-1] : 1'b0; 

    for ( genvar i = 1; i <= NumStages; i++ ) begin

        for ( genvar j = 0; j < MuxPerStage; j++ ) begin

			// Left Shift
			
			if( j < 2**(i-1) ) begin
				assign 	data_mux_l[i][j] = ( bshft_amt_i[i-1] & bshft_en_i ) ? 1'b0 : data_mux_l[i-1][j];
			end
			else begin
				assign 	data_mux_l[i][j] = ( bshft_amt_i[i-1] & bshft_en_i ) ? data_mux_l[i-1][j - 2**(i-1)] : data_mux_l[i-1][j];
			end

			// Right Shift

			if( j < 2**(NumStages-i) ) begin
				assign 	data_mux_r[i][MuxPerStage-j-1] = ( bshft_amt_i[NumStages-i] & bshft_en_i ) ? rshift_val : data_mux_r[i-1][MuxPerStage-j-1];
			end
			else begin
				assign 	data_mux_r[i][MuxPerStage-j-1] = ( bshft_amt_i[NumStages-i] & bshft_en_i ) ? data_mux_r[i-1][MuxPerStage-j-1+2**(NumStages-i)] : data_mux_r[i-1][MuxPerStage-j-1];
			end

		end
    end

	assign bshft_result_o = ( bshft_mode_i[1] ) ? data_mux_r[NumStages] : data_mux_l[NumStages];
	/* verilator lint_on UNOPTFLAT */ 

endmodule;
