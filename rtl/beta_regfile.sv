//`include "beta_def.sv"

/*
Version 0.1

	-Regfile does not support RV32E atm
	-Regfile is combinatorial for read but sequential for write
*/


module beta_regfile import beta_pkg::*; #(

	
	)(

	input logic clk_i,
	input logic rstn_i,

	input logic[4:0] rs1_addr_i,
	input logic[4:0] rs2_addr_i,
	input logic[4:0] rd_addr_i,

	input logic wr_en_i,
	input logic[XLEN-1:0] rd_wdata_i,

	output logic[XLEN-1:0] rs1_data_o,
	output logic[XLEN-1:0] rs2_data_o
	);
	

	logic[31:0] rs1_data_int;
	logic[31:0] rs2_data_int;
	logic[XLEN-1:0] regfile_data_int [31:0];
	
	assign rs1_data_o = rs1_data_int;
	assign rs2_data_o = rs2_data_int;

	//read process

	always_comb begin : read_proc

		rs1_data_int = regfile_data_int[rs1_addr_i];
		rs2_data_int = regfile_data_int[rs2_addr_i];
	end


	//write proceess

	always_ff @(posedge clk_i) begin : write_proc

		if( rstn_i == 1'b0 ) begin
			for( int i = 0; i < 32; i++ ) 
				regfile_data_int[i] <= '0;
		end
		else if( wr_en_i == 1'b1 ) begin
			regfile_data_int[rd_addr_i] <= rd_wdata_i;
		end
		
	end 
	

endmodule;
