`include "pkg/beta_exe_stage_pkg.sv"

/*
13/05/2022
Version 0.4

	-LSU partially supported (MUX result still not, STORE stiill not, LOAD maybe)
	-Supportin a control unit driving control signals to different units
	-Handling multi-cycles events with latches is now supported for the shift unit
*/


module beta_exe_stage import beta_pkg::*; #(
	parameter unsigned DataWidth = 32,
	parameter unsigned AddressWidth = 32
)
(
	input logic 			clk_i,
	input logic 			rstn_i,
	
	input logic			exe_new_instr_i,	//beta
	
	input logic[DataWidth-1:0] 	exe_operand_a_i,
	input logic[DataWidth-1:0]	exe_operand_b_i,

	input logic[4:0] 		exe_rd_addr_i,

	input logic[DataWidth-1:0] 	exe_pc_i,
	input logic[11:0]		exe_offset12_i,
	input logic[19:0]		exe_offset20_i,
	input exe_control_word_t	exe_control_word_i,

	output logic			exe_alu_op_end_o,
	output logic[DataWidth-1:0]	exe_next_pc_o,
	output logic[DataWidth-1:0]	exe_result_o,
	output logic[4:0] 		exe_rd_addr_o,
	output logic			exe_reg_wr_en_o,
	


	//Inter Stages sync port

	input logic			dec_stage_busy_i,
	output logic			exe_stage_busy_o,
	
	//Data memory/LSU port 

	/*Read Data Memory Port*/
	input  logic			rdata_ready_i,
	input  logic			rdata_valid_i,
	input  logic[DataWidth-1:0] 	rdata_data_i,
	output logic[AddressWidth-1:0] 	rdata_addr_o,
	output logic[DataWidth/8-1:0]	rdata_strb_o,
	output logic 			rdata_req_o,

	/*Write Data Memory Port*/
	input  logic			wdata_ready_i,
	input  logic			wdata_valid_i,
	output logic[DataWidth-1:0] 	wdata_data_o,
	output logic[AddressWidth-1:0] 	wdata_addr_o,
	output logic[DataWidth/8-1:0]	wdata_strb_o,
	output logic 			wdata_req_o

);

	logic 			exe_alu_op_end_int;
	logic[DataWidth-1:0]	exe_next_pc_int;
	logic[DataWidth-1:0]	exe_result_int; 

	exe_alu_status_t 	exe_alu_stat_int;
	logic[DataWidth-1:0]	alu_result_int;

	logic[4:0]		exe_rd_addr_int;

	exe_alu_op_t		alu_op_int;
	exe_bju_op_t		bju_op_int;

	logic[DataWidth-1:0]	bju_next_pc_int;
	logic[DataWidth-1:0]	incr_pc_int;

	logic[5:0] 		result_mux_sel_int;
	logic	 		nextpc_mux_sel_int;

	logic[1:0] 		shu_mode_int;
	logic	 		shu_en_int;
	logic			shu_busy_int;
	logic[1:0]		shu_size_int;

	logic 			lsu_busy_int;
	logic[1:0] 		lsu_op_size_int;
	logic 			lsu_op_int;
	logic 			lsu_en_int;
	logic[DataWidth-1:0]	lsu_result_int;
	
	logic			exe_reg_wr_en_int;
	
	assign incr_pc_int = exe_pc_i + 32'h00000004;
	assign exe_rd_addr_int = exe_rd_addr_i;
	assign shu_size_int = {|exe_operand_b_i[4:1],exe_operand_b_i[0]};

	//Instantiating Exe Control Unit

	logic	exe_stage_busy_int;

	beta_exe_cu exe_cu(
		.clk_i(clk_i),
		.rstn_i(rstn_i),
	
		.execu_control_word_i(exe_control_word_i),

		/*Arithmetic & Logic Unit Port */
		.execu_alu_op_end_i(exe_alu_op_end_int), //Unused atm
		.execu_alu_op_o(alu_op_int),

		/*Shift Unit Port*/
		.execu_shu_size_i(shu_size_int), //00 No Shift, 01 One Shift, 10/11 Multiple shifts
		.execu_shu_busy_i(shu_busy_int),
		.execu_shu_mode_o(shu_mode_int),
		.execu_shu_en_o(shu_en_int),
	

		/*Branch & Jump Unit Port*/
		.execu_bju_op_o(bju_op_int),

		/*Load & Store Unit Port*/
		.execu_lsu_busy_i(lsu_busy_int),
		.execu_lsu_op_size_o(lsu_op_size_int),
		.execu_lsu_op_o(lsu_op_int),
		.execu_lsu_en_o(lsu_en_int),

		/*Selection Path Port*/
		.execu_result_sel_o(result_mux_sel_int),
		.execu_nextpc_sel_o(nextpc_mux_sel_int),

		/*Busy/Synch signals port*/
		.execu_new_instr_i(exe_new_instr_i),		//beta
		.execu_dec_stage_busy_i(dec_stage_busy_i),
		.execu_exe_stage_busy_o(exe_stage_busy_int),
		.execu_reg_wr_en_o(exe_reg_wr_en_int)		//beta

	);

	//Instantiating ALU
	beta_alu alu (
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.operand_a_i(exe_operand_a_i),
		.operand_b_i(exe_operand_b_i),
		.operation_i(alu_op_int),

		.alu_stat_o(exe_alu_stat_int),
		.alu_op_end_o(exe_alu_op_end_int),
		.alu_result_o(alu_result_int)
	);

	//Instantiating SHU (Shift Unit)

	logic [XLEN-1:0] shu_result_int;

	beta_shift_unit shu(
		.clk_i(clk_i),
		.rstn_i(rstn_i),

		.operand_a_i(exe_operand_a_i),
		.operand_b_i(exe_operand_b_i[4:0]),
		.shu_mode_i(shu_mode_int),
		.shu_en_i(shu_en_int),

		.shu_busy_o(shu_busy_int),
		.shu_result_o(shu_result_int)

	);

	//Instantiating BJU
	beta_bju bju (
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.bju_pc_i(exe_pc_i),
		.bju_offset12_i(exe_offset12_i),
		.bju_offset20_i(exe_offset20_i),
		.bju_basereg_i(exe_operand_a_i),
		.bju_alu_stat_i(exe_alu_stat_int),
		.bju_op_i(bju_op_int),

		.bju_next_pc_o(bju_next_pc_int),
		.bju_branch_taken_o()
	);
	
	//Instantiating LSU

	logic [31:0] lsu_addr_int = alu_result_int; 
	beta_lsu lsu (
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.op_data_i(exe_operand_b_i),	//Write data is exactly operand b.
		.op_addr_i(lsu_addr_int),	//the memory address is bore by the ALU
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
		.wdata_req_o(wdata_req_o),
		.lsu_op_size_i(lsu_op_size_int),
		.lsu_op_i(lsu_op_int),
		.lsu_op_en_i(lsu_en_int),
		.lsu_woffset_i(exe_offset12_i),	//Store offset. (remember that stores are encoded similarly to branches)
		.lsu_busy_o(lsu_busy_int),
		.lsu_result_o(lsu_result_int)	//The result shall be driven into an internal signal and then in the result MUX
	);

	//Result MUX
	always_comb begin: result_mux
		if(result_mux_sel_int[0] == 1'b1) begin //JALR and JAL result saving PC + 4 (return address)
			exe_result_int = incr_pc_int;
		end
		else if(result_mux_sel_int[5] == 1'b1) begin //LOAD MEMORY result
			exe_result_int = lsu_result_int;
		end
		else if(result_mux_sel_int[4] == 1'b1) begin //AUIPC result
			exe_result_int = alu_result_int + exe_pc_i;
		end
		else if(result_mux_sel_int[0] == 1'b0) begin //No branch result -> op result
			if(shu_mode_int != SHIFT_NONE) begin //SHU Result
				case(result_mux_sel_int[2:1])
					2'b00: exe_result_int = alu_result_int; //0 Shift
					2'b01: begin //1 Shift
						if(shu_mode_int == SHIFT_LEFT ) exe_result_int = {alu_result_int[DataWidth-2:0],1'b0};
						else if(shu_mode_int == SHIFT_RIGHT ) exe_result_int = {1'b0,alu_result_int[DataWidth-1:1]};
						else if(shu_mode_int == SHIFT_ARIGHT ) exe_result_int = ( alu_result_int[DataWidth-1] == 1'b1 ) ? {1'b1,alu_result_int[DataWidth-1:1]} : {1'b0,alu_result_int[DataWidth-1:1]};
					end
					default: exe_result_int = shu_result_int; //Multiple Shift
				endcase;
			end
			else if(result_mux_sel_int[3] == 1'b1) begin //SLT enabled
				exe_result_int = {31'h00000000,exe_alu_stat_int.negative};
			end
			else begin
				exe_result_int = alu_result_int;
			end
		end
	end

	//Next PC MUX
	always_comb begin: next_pc_mux
		case(nextpc_mux_sel_int)
			1'b0: exe_next_pc_int = incr_pc_int;
			1'b1: exe_next_pc_int = bju_next_pc_int;
		endcase;
	end
	
	assign exe_alu_op_end_o = exe_alu_op_end_int;
	assign exe_next_pc_o = exe_next_pc_int;
	assign exe_result_o = exe_result_int;
	assign exe_rd_addr_o = exe_rd_addr_int;

	assign exe_stage_busy_o = exe_stage_busy_int;
	assign exe_reg_wr_en_o = exe_reg_wr_en_int;


endmodule;
