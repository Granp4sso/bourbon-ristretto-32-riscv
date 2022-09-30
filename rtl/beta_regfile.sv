
/*
	Register File 0.2 26/08/2022

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines 
	-AddrWidth :		Width of addresses
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	
	-rf_rs1_addr_i :	Register source 1 address 
	-rf_rs2_addr_i :	Register source 2 address 
	-rf_rd_addr_i :		Rergister destination address
	-rf_wr_en_i :		Write enable signal
	-rf_rd_wdata_i :	Register destination data (write)
	-rf_rs1_data_o :	Register source 1 data (read)
	-rf_rs2_data_o :	Register source 2 data (read)

	******|| REMARKABLE 	||******
	
	Read process is combinatorial, while Write process is sequential. This implies that a write operation will take 1 clock cycles to be completed.
	Register Zero cannot be written.

	******|| NOTES		||******

*/


module beta_regfile import beta_pkg::*; #(

	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32
	
	)(

	input logic 			clk_i,
	input logic 			rstn_i,

	input logic[4:0] 		rf_rs1_addr_i,
	input logic[4:0] 		rf_rs2_addr_i,
	input logic[4:0] 		rf_rd_addr_i,

	input logic 			rf_wr_en_i,
	input logic[DataWidth-1:0] 	rf_rd_wdata_i,

	output logic[DataWidth-1:0] 	rf_rs1_data_o,
	output logic[DataWidth-1:0] 	rf_rs2_data_o
	);
	

	logic[31:0] rs1_data_int;
	logic[31:0] rs2_data_int;
	logic[XLEN-1:0] regfile_data_int [31:0];
	
	assign rf_rs1_data_o = rs1_data_int;
	assign rf_rs2_data_o = rs2_data_int;

	//read process

	always_comb begin : read_proc

		rs1_data_int = regfile_data_int[rf_rs1_addr_i];
		rs2_data_int = regfile_data_int[rf_rs2_addr_i];
	end


	//write proceess

	always_ff @(posedge clk_i) begin : write_proc

		if( rstn_i == 1'b0 ) begin
			for( int i = 0; i < 32; i++ ) 
				regfile_data_int[i] <= '0;
		end
		else if( rf_wr_en_i == 1'b1 ) begin
			if(|rf_rd_addr_i == 1'b1) regfile_data_int[rf_rd_addr_i] <= rf_rd_wdata_i; //Do not write on reg 0
		end
		
	end 
	

endmodule;
