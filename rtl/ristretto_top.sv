//`include "pkg/ristretto_pkg.sv"

`include "pkg/ristretto_exe_stage_pkg.sv"
`include "pkg/ristretto_dec_stage_pkg.sv"
`include "pkg/ristretto_if_stage_pkg.sv"
`include "pkg/ristretto_csr_pkg.sv"
`include "pkg/ristretto_trap_pkg.sv"

/*
9/06/2022
Version 0.7

	-Instruction fetch stage does support a very simple protocol similiar to the ibex one. No caches or prefetch buffer are supported yet
	-Supporting dec_stage and exe_stage. No register wr-enable and no LSU support at the moment.
	-No pipe support at the moment and no sequential logic. Almost everything is still combinatorial

	-Integrating the pipeline control unit (still alpha)
*/

import ristretto_exe_stage_pkg::*;
import ristretto_dec_stage_pkg::*;
import ristretto_if_stage_pkg::*;
import ristretto_csr_pkg::*;
import ristretto_trap_pkg::*;

module ristretto_top #(

	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32,
	parameter unsigned PrefetchBuffer = PrefetchBufferMedium,
	parameter unsigned ShiftUnit = ShiftUnitBarrel,
	parameter unsigned PMPenable = PMP_EN_TRUE,
	parameter unsigned PMPentries = 4

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
	output logic[AddrWidth-1:0] 	rdata_addr_o,
	output logic[DataWidth/8-1:0]	rdata_strb_o,
	output logic 			rdata_req_o,

	input  logic			wdata_ready_i,
	input  logic			wdata_valid_i,
	output logic[DataWidth-1:0] 	wdata_data_o,
	output logic[AddrWidth-1:0] 	wdata_addr_o,
	output logic[DataWidth/8-1:0]	wdata_strb_o,
	output logic 			wdata_req_o,

	//Generic & not classified atm

	output logic[DataWidth-1:0] 	result_o,

	//Interrupt and exception signals
	
	input logic 			sw_intr_i,
	input logic			tim_intr_i,
	input logic			ext_intr_i
	
);

	logic[DataWidth-1:0] 	result_int;
	logic[11:0] 		dec_offset12_int;
	logic[19:0] 		dec_offset20_int;
	logic[DataWidth-1:0] 	dec_operand_a_int;
	logic[DataWidth-1:0] 	dec_operand_b_int;
	logic[4:0] 		dec_rd_addr_int;
	logic[4:0] 		exe_rd_addr_int;
	dec_control_word_t 	dec_control_word_int;
	logic[DataWidth-1:0]	dec_next_pc_int;
	logic			dec_new_instr_int;
	logic[4:0]		dec_rsrc1_addr_int;
	logic[4:0]		dec_rsrc2_addr_int;
	logic			exe_branch_taken_int;
	logic			dec_invalid_instr_int;
	logic[DataWidth-1:0] 	dec_invalid_instrval_int;
	logic[1:0]		exe_trap_taken_int;
	
	logic[DataWidth-1:0]	next_pc_int;
	logic			reg_wr_en_int;
	logic			new_instr_int;

	//IF internal signal
	logic			pc_en_int;
	logic			fetch_en_int;

	logic[DataWidth-1:0]	instr_addr_int;
	logic[DataWidth-1:0]	instr_int;
	logic 			instr_req_int;
	logic[1:0]		if_penality_int;
	logic			if_pb_instr_tag_int;

	/* Instruction fetch to Decode Pipe */

	logic			pip0_new_instr_int;
	logic[DataWidth-1:0]	pip0_instr_int;
	logic[DataWidth-1:0]	pip0_next_pc_int;
	logic[1:0]		pip0_penality_int;
	logic			pip0_pb_instr_tag_int;
	

	/* Decode to Execution Pipe */

	logic[11:0] 		pip1_offset12_int;
	logic[19:0] 		pip1_offset20_int;
	logic[DataWidth-1:0] 	pip1_operand_a_int;
	logic[DataWidth-1:0] 	pip1_operand_b_int;
	logic[4:0] 		pip1_rd_addr_int;
	dec_control_word_t 	pip1_control_word_int;
	logic[DataWidth-1:0]	pip1_next_pc_int;
	logic			pip1_new_instr_int;
	logic			pip1_invalid_instr_int;
	logic[DataWidth-1:0] 	pip1_invalid_instrval_int;
	logic[1:0]		pip1_penality_int;
	
	//Inter stages sync signals

	logic			if_stage_busy_int;
	logic			dec_stage_busy_int;
	logic			exe_stage_busy_int;

	logic			pcu_pip0_stall_int;
	logic			pcu_pip0_flush_int;
	logic			pcu_pip1_stall_int;
	logic			pcu_pip1_flush_int;
	
	/* Data Hazard Signals begin*/
	
	logic[1:0] pcu_r_op_int = dec_control_word_int.src_reg_used;
	logic pcu_exe_wreq_int = pip1_control_word_int.exe_reg_wr_en;
	logic[4:0] pcu_exe_rd_int = exe_rd_addr_int;
	logic[4:0] dec_shadow_op_b_int;
	
	logic data_hazard_flag_int;
	logic[1:0] data_hazard_src_int;
	
	/* Data Hazard Signals end*/
	
	/* Control Hazard Signals begin*/
	
	logic [1:0] exe_bju_active_int;
	logic[1:0] pcu_exe_bju_en_int =  exe_bju_active_int;
	logic[1:0] pcu_ctrl_hazard_flag_int;
	logic[1:0] pcu_trap_hazard_flag_int;
	
	/* Control Hazard Signals end*/

	//Instantiating Instruction Fetch Stage

	assign pc_en_int = fetch_en_int;	
	
	logic [AddrWidth-1:0] current_pc_int;
	logic if_ctrl_hazard_int = (pcu_ctrl_hazard_flag_int[0]) ? (pcu_ctrl_hazard_flag_int[1] | (~pcu_ctrl_hazard_flag_int[1] & exe_branch_taken_int)) : 1'b0;
	
	ristretto_if_stage #(
		.DataWidth		(DataWidth),
		.PrefetchBuffer	(PrefetchBuffer),
		.iTCM			(0),
		.iCache			(0)
	) if_stage (
		.clk_i(clk_i),
		.rstn_i(rstn_i),

		/*Instruction Memory Port*/
		.if_fetch_en_i(fetch_en_int),
		.if_instr_ready_i(instr_ready_i),
		.if_instr_valid_i(instr_valid_i),
		.if_instr_rdata_i(instr_rdata_i),
		.if_instr_addr_o(instr_addr_int),
		.if_instr_req_o(instr_req_int),


		.if_pc_en_i(pc_en_int), 
		.if_next_pc_i(next_pc_int),
		.if_curr_pc_o(current_pc_int),
		.if_instr_o(instr_int),
		.if_new_instr_o(new_instr_int),
		.if_pb_instr_tag_o(if_pb_instr_tag_int),
		
		.if_ctrl_hazard_flag_i(pcu_ctrl_hazard_flag_int[0] & (pcu_ctrl_hazard_flag_int[1] | exe_branch_taken_int)),
		.if_trap_hazard_flag_i(pcu_trap_hazard_flag_int[1] | pcu_trap_hazard_flag_int[0]),
		
		.if_stage_busy_o(if_stage_busy_int),
		.if_penality_o(if_penality_int)
	);

	ristretto_if_dec_pipe #(
		.DataWidth	(DataWidth)
	) pipe0 (
		.clk_i(clk_i),
		.rstn_i(rstn_i),

		/* Input Fetch Stage signals */

		.pip_instr_i(instr_int),
		.pip_new_instr_i(new_instr_int),	
		.pip_penality_i(if_penality_int),
		.pip_pb_instr_tag_i(if_pb_instr_tag_int),

		/* Output Decode Stage signals */

		.pip_instr_o(pip0_instr_int),
		.pip_new_instr_o(pip0_new_instr_int),
		.pip_penality_o(pip0_penality_int),
		.pip_pb_instr_tag_o(pip0_pb_instr_tag_int),

		/* Others */

		.pip_next_pc_i(current_pc_int),
		.pip_next_pc_o(pip0_next_pc_int),

		/* Pipeline Control Unit signals*/

		.pip_stall_i(pcu_pip0_stall_int),
		.pip_flush_i(pcu_pip0_flush_int)
	);

	ristretto_dec_stage #() dec_stage (

		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.dec_next_pc_i(pip0_next_pc_int),
		.dec_instr_i(pip0_instr_int),
		.dec_new_instr_i(pip0_new_instr_int),
		.dec_rd_wdata_i(result_int),
		.dec_rd_addr_i(exe_rd_addr_int),
		.dec_reg_wr_en_i(reg_wr_en_int),
		.dec_offset12_o(dec_offset12_int),
		.dec_offset20_o(dec_offset20_int),
		.dec_operand_a_o(dec_operand_a_int),
		.dec_operand_b_o(dec_operand_b_int),
		.dec_rd_addr_o(dec_rd_addr_int),
		.dec_control_word_o(dec_control_word_int),
		.dec_next_pc_o(dec_next_pc_int),
		.dec_new_instr_o(dec_new_instr_int),	
		
		.dec_invalid_instr_o(dec_invalid_instr_int),
		.dec_invalid_instrval_o(dec_invalid_instrval_int),

		.dec_rsrc1_addr_o(dec_rsrc1_addr_int),
		.dec_rsrc2_addr_o(dec_rsrc2_addr_int),
		.if_stage_busy_i(if_stage_busy_int),
		.dec_stage_busy_o(dec_stage_busy_int),
		
		.dec_forward_en_i(data_hazard_flag_int),
		.dec_forward_src_i(data_hazard_src_int),
		.dec_shadow_op_b_o(dec_shadow_op_b_int)
	);

	ristretto_dec_exe_pipe #(
		.DataWidth	(DataWidth)
	) pipe1 (
		.clk_i(clk_i),
		.rstn_i(rstn_i),

		/* Input Decode Stage signals */

		.pip_offset12_i(dec_offset12_int),
		.pip_offset20_i(dec_offset20_int),
		.pip_operand_a_i(dec_operand_a_int),
		.pip_operand_b_i(dec_operand_b_int),
		.pip_rd_addr_i(dec_rd_addr_int),
		.pip_control_word_i(dec_control_word_int),
	
		.pip_next_pc_i(dec_next_pc_int),
		.pip_new_instr_i(dec_new_instr_int),	

		.pip_invalid_instr_i(dec_invalid_instr_int),
		.pip_invalid_instrval_i(dec_invalid_instrval_int),
		.pip_penality_i(pip0_penality_int),

		/* Output Execution Stage signals */

		.pip_offset12_o(pip1_offset12_int),
		.pip_offset20_o(pip1_offset20_int),
		.pip_operand_a_o(pip1_operand_a_int),
		.pip_operand_b_o(pip1_operand_b_int),
		.pip_rd_addr_o(pip1_rd_addr_int),
		.pip_control_word_o(pip1_control_word_int),

		.pip_next_pc_o(pip1_next_pc_int),
		.pip_new_instr_o(pip1_new_instr_int),	
		
		.pip_invalid_instr_o(pip1_invalid_instr_int),
		.pip_invalid_instrval_o(pip1_invalid_instrval_int),
		.pip_penality_o(pip1_penality_int),

		/* Pipeline Control Unit signals*/
	
		.pip_stall_i(pcu_pip1_stall_int /*| (~pcu_pip1_stall_int & pcu_trap_hazard_flag_int[0] & ~reg_wr_en_int)*/),
		.pip_flush_i(pcu_pip1_flush_int)
	);


	
	ristretto_exe_stage #(
		.DataWidth(DataWidth),
		.AddrWidth(AddrWidth),
		.ShiftUnit(ShiftUnit),
		.PMPenable(PMPenable),
		.PMPentries(PMPentries)
	) exe_stage (
		.clk_i(clk_i),
		.rstn_i(rstn_i),
	
		.exe_operand_a_i(pip1_operand_a_int),
		.exe_operand_b_i(pip1_operand_b_int),

		.exe_rd_addr_i(pip1_rd_addr_int),

		.exe_pc_i(pip1_next_pc_int),
		.exe_offset12_i(pip1_offset12_int),
		.exe_offset20_i(pip1_offset20_int),
		.exe_control_word_i(pip1_control_word_int[24:0]),
		
		.exe_new_instr_i(pip1_new_instr_int),	

		.exe_next_pc_o(next_pc_int),
		.exe_result_o(result_int),

		.exe_rd_addr_o(exe_rd_addr_int),
		.exe_reg_wr_en_o(reg_wr_en_int),
		
		.exe_invalid_instr_i(pip1_invalid_instr_int),
		.exe_invalid_instrval_i(pip1_invalid_instrval_int),

		.exe_instr_penality_i(pip1_penality_int),
		.dec_stage_busy_i(dec_stage_busy_int),
		.exe_stage_busy_o(exe_stage_busy_int),
		.exe_bju_active_o(exe_bju_active_int),
		.exe_branch_taken_o(exe_branch_taken_int),
		.exe_trap_taken_o(exe_trap_taken_int),
		
		.exe_sw_intr_i(sw_intr_i),
		.exe_tim_intr_i(tim_intr_i),
		.exe_ext_intr_i(ext_intr_i),

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

	//Pipeline control unit

	ristretto_pipeline_control_unit #(
		.DataWidth(DataWidth),
	   	.AddrWidth(AddrWidth)
	) pcu (
		.clk_i(clk_i),
		.rstn_i(rstn_i),

		/* Fetch Stage Signals */

		.pcu_ifs_busy_i(if_stage_busy_int),
		.pcu_ifs_fetch_en_o(fetch_en_int),

		/* Decode Stage signals */

		.pcu_decs_busy_i(dec_stage_busy_int),
		.pcu_decs_new_instr_i(pip0_new_instr_int),
		.pcu_decs_pb_instr_tag_i(pip0_pb_instr_tag_int),

		/* Execution Stage signals */

		.pcu_exes_busy_i(exe_stage_busy_int),

		/* Pipe if-to-dec signals */

		.pcu_pip0_stall_o(pcu_pip0_stall_int), 
		.pcu_pip0_flush_o(pcu_pip0_flush_int),

		/* Pipe dec-to-exe signals */

		.pcu_pip1_stall_o(pcu_pip1_stall_int),
		.pcu_pip1_flush_o(pcu_pip1_flush_int),
	
		/* Data Hazard Control Signals */
	
		.pcu_dec_rsrc1_i(dec_rsrc1_addr_int),
		.pcu_dec_rsrc2_i(dec_rsrc2_addr_int),
		.pcu_r_op_i(pcu_r_op_int),		
		.pcu_exe_rd_i(pcu_exe_rd_int),
		.pcu_exe_wreq_i(pcu_exe_wreq_int),		
		.pcu_exe_multi_cycle_i(0),//pcu_exe_multi_cycle_int),
		.pcu_dec_multi_cycle_i(0),//pcu_dec_multi_cycle_int),
		.pcu_exe_branch_taken_i(exe_branch_taken_int),
		
		.data_hazard_flag_o(data_hazard_flag_int),
		.data_hazard_src_o(data_hazard_src_int),
		
		/* Control Hazard Signals */
	
		.pcu_exe_trap_flag_i(exe_trap_taken_int),
		.pcu_exe_bju_en_i(pcu_exe_bju_en_int),
		.pcu_trap_hazard_flag_o(pcu_trap_hazard_flag_int),
		.pcu_ctrl_hazard_flag_o(pcu_ctrl_hazard_flag_int)
	);

	assign result_o = result_int;
	assign instr_addr_o = instr_addr_int;
	assign instr_req_o = instr_req_int;


endmodule
