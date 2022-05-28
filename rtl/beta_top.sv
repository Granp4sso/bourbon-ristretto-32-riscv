`include "pkg/beta_pkg.sv"

/*
03/05/2022
Version 0.5

	-Instruction fetch stage does support a very simple protocol similiar to the ibex one. No caches or prefetch buffer are supported yet
	-Supporting dec_stage and exe_stage. No register wr-enable and no LSU support at the moment.
	-No pipe support at the moment and no sequential logic. Almost everything is still combinatorial
*/


module beta_top import beta_pkg::*; #(

	parameter unsigned DataWidth = 32,
	parameter unsigned AddressWidth = 32

	)(

	input logic 			clk_i,
	input logic 			rstn_i,

	/*Instruction Memory Port*/
	input logic			instr_ready_i,
	input logic			instr_valid_i,
	input logic[DataWidth-1:0] 	instr_rdata_i,
	output logic 			instr_req_o,
	output logic[DataWidth-1:0]	instr_addr_o,
	
	/*Data Memory Port*/

	input  logic			rdata_ready_i,
	input  logic			rdata_valid_i,
	input  logic[DataWidth-1:0] 	rdata_data_i,
	output logic[AddressWidth-1:0] 	rdata_addr_o,
	output logic[DataWidth/8-1:0]	rdata_strb_o,
	output logic 			rdata_req_o,

	input  logic			wdata_ready_i,
	input  logic			wdata_valid_i,
	output logic[DataWidth-1:0] 	wdata_data_o,
	output logic[AddressWidth-1:0] 	wdata_addr_o,
	output logic[DataWidth/8-1:0]	wdata_strb_o,
	output logic 			wdata_req_o,

	//Generic & not classified atm

	output logic[DataWidth-1:0] 	result_o,
	output logic 			alu_op_end_o

	//Interrupt and exception signals
	
);

	logic[DataWidth-1:0] 	result_int;
	logic[11:0] 		dec_offset12_int;
	logic[19:0] 		dec_offset20_int;
	logic[XLEN-1:0] 	dec_operand_a_int;
	logic[XLEN-1:0] 	dec_operand_b_int;
	logic[4:0] 		dec_rd_addr_int;
	logic[4:0] 		exe_rd_addr_int;
	dec_control_word_t 	dec_control_word_int;

	
	logic[DataWidth-1:0]	next_pc_int;
	logic			alu_op_end_int;
	logic			reg_wr_en_int;
	logic			new_instr_int;

	//IF internal signal
	logic			pc_en_int;
	logic			fetch_en_int;

	logic[DataWidth-1:0]	instr_addr_int;
	logic[DataWidth-1:0]	instr_int;
	logic 			instr_req_int;
	
	//Inter stages sync signals

	logic			if_stage_busy_int;
	logic			dec_stage_busy_int;
	logic			exe_stage_busy_int;

	//System Reset Area

	logic first_reset;

	always_ff@(posedge clk_i) begin: first_reset_proc
		if(rstn_i == 1'b0) begin
			first_reset <= 1'b1;
		end
		else begin
			first_reset <= 1'b0;
		end
	end

	//Instantiating Instruction Fetch Stage

	assign pc_en_int = reg_wr_en_int | fetch_en_int;	//The pc is written once everyody ended their task
	assign fetch_en_int = ~if_stage_busy_int & ~dec_stage_busy_int & ~exe_stage_busy_int;

	beta_if_stage #(
		.DataWidth	(DataWidth),
		.PrefetchBuffer	(0),
		.iTCM		(0),
		.iCache		(0)
	) if_stage (
		.clk_i(clk_i),
		.rstn_i(rstn_i),

		/*Instruction Memory Port*/
		.if_fetch_en_i(fetch_en_int),
		.if_instr_ready_i(instr_ready_i),
		.if_instr_valid_i(instr_valid_i),
		.if_instr_rdata_i(instr_rdata_i),
		.if_instr_req_o(instr_req_int),


		.if_pc_en_i(pc_en_int), 
		.if_next_pc_i(next_pc_int),
		.if_curr_pc_o(instr_addr_int),
		.if_instr_o(instr_int),
		.if_new_instr_o(new_instr_int),
		
		.if_stage_busy_o(if_stage_busy_int)
	);

	beta_dec_stage #() dec_stage (

		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.dec_instr_i(instr_int),
		.dec_new_instr_i(new_instr_int),
		.dec_rd_wdata_i(result_int),
		.dec_rd_addr_i(exe_rd_addr_int),
		.dec_reg_wr_en_i(reg_wr_en_int),
		.dec_offset12_o(dec_offset12_int),
		.dec_offset20_o(dec_offset20_int),
		.dec_operand_a_o(dec_operand_a_int),
		.dec_operand_b_o(dec_operand_b_int),
		.dec_rd_addr_o(dec_rd_addr_int),
		.dec_control_word_o(dec_control_word_int),

		.if_stage_busy_i(if_stage_busy_int),
		.dec_stage_busy_o(dec_stage_busy_int)
	);

	beta_exe_stage #(
		.DataWidth(DataWidth)
	) exe_stage (
		.clk_i(clk_i),
		.rstn_i(rstn_i),
	
		.exe_operand_a_i(dec_operand_a_int),
		.exe_operand_b_i(dec_operand_b_int),

		.exe_rd_addr_i(dec_rd_addr_int),

		.exe_pc_i(instr_addr_int),
		.exe_offset12_i(dec_offset12_int),
		.exe_offset20_i(dec_offset20_int),
		.exe_control_word_i(dec_control_word_int[18:0]),

		.exe_alu_op_end_o(alu_op_end_int),
		.exe_next_pc_o(next_pc_int),
		.exe_result_o(result_int),

		.exe_rd_addr_o(exe_rd_addr_int),
		.exe_reg_wr_en_o(reg_wr_en_int),

		.dec_stage_busy_i(dec_stage_busy_int),
		.exe_stage_busy_o(exe_stage_busy_int),

		.rdata_ready_i(rdata_ready_i),
		.rdata_valid_i(rdata_valid_i),
		.rdata_data_i(rdata_data_i),
		.rdata_addr_o(rdata_addr_o),
		.rdata_strb_o(rdata_strb_o),
		.rdata_req_o(rdata_req_o),
		.wdata_ready_i(wdata_ready_i),
		.wdata_valid_i(wdata_valid_i),
		.wdata_data_o(wdata_data_o),
		.wdata_addr_o(wdata_addr_o),
		.wdata_strb_o(wdata_strb_o),
		.wdata_req_o(wdata_req_o)
	);

	assign result_o = result_int;
	assign alu_op_end_o = alu_op_end_int;
	assign instr_addr_o = instr_addr_int;
	assign instr_req_o = instr_req_int;


endmodule
