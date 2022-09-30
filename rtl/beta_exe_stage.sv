`include "pkg/beta_exe_stage_pkg.sv"

/*
	Trap Control Unit v0.8 30/09/2022

	******|| INSTANTIABLES 	||******
						- CodeType,	Mandatory,	Supported
		-Execution Control Unit 	- [UNIT		Y		Y	]
		-Trap Control Unit 		- [UNIT		Y		Y	]
		-Control & Status Regfile	- [UNIT		Y		Y	]
		-Branch & Jump Unit		- [UNIT		Y		Y	]
		-Load & Store Unit		- [UNIT		Y		Y	]
		-Multicycle Shift Unit		- [UNIT		Y		Y	]
		-Singlecycle Shift Unit		- [UNIT		N		N	]
		-Multicycle Multiplier		- [UNIT		N		N	]	(M - extension required)
		-Singlecycle Multiplier		- [UNIT		N		N	]	(M - extension required)
		-Next PC Multiplexer		- [PROCESS	Y		Y	]
		-Result Multiplexer		- [PROCESS	Y		Y	]
		
	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines
	-AddrWidth :		Width of addresses
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	-exe_new_instr_i :		New instruction has been fetched	
	-exe_operand_a_i :		Operand produced by the decode stage
	-exe_operand_b_i :		Operand produced by the decode stage
	-exe_rd_addr_i :		Destination Register address (we need it for write operations)
	-exe_pc_i :			Program Counter
	-exe_offset12_i :		12-bit offset used in the BJU and LSU
	-exe_offset20_i :		20-bit offset used in the BJU
	-exe_control_word_i :		Control word coming from the decode stage
	-exe_next_pc_o :		Next program counter for fetching
	-exe_result_o :			Exe stage produced result
	-exe_rd_addr_o :		Destination Register address (it will be sent to the regfile in the decode stage)
	-exe_reg_wr_en_o :		Register file write enable. It must be high for exactly one clock cycle when an operation is completed.
	-exe_invalid_instr_i :		Invalid instruction detected in the decode stage. Here we will raise the exception
	-exe_invalid_instrval_i :	Invalid instruction value. It is used to set the mtval csr in case of an illegal instruction	
	-exe_sw_intr_i :		Software interrupt request from outside the core
	-exe_tim_intr_i :		Timer interrupt request from outside the core
	-exe_ext_intr_i :		External interrupt request from outside the core
	-exe_instr_penality_i :		Notifies if the current instruction is a penality NOP ( Trap NOP or Control NOP )
	-dec_stage_busy_i :		Decode stage busy signal	
	-exe_stage_busy_o :		Execution stage busy signal (only for multi-cycle operations)
	-exe_bju_active_o :		???
	-exe_branch_taken_o :		A branch has been taken. It is used for hazard handling (pipe flush)
	-exe_trap_taken_o :		A trap occurred. It is used for hazard handling (pipe flush)
	-rdata_ready_i :		Check LSU for further info
	-rdata_valid_i :		Check LSU for further info
	-rdata_data_i :			Check LSU for further info
	-rdata_addr_o :			Check LSU for further info
	-rdata_strb_o :			Check LSU for further info
	-rdata_req_o :			Check LSU for further info
	-wdata_ready_i :		Check LSU for further info
	-wdata_valid_i :		Check LSU for further info
	-wdata_data_o :			Check LSU for further info
	-wdata_addr_o :			Check LSU for further info
	-wdata_strb_o :			Check LSU for further info
	-wdata_req_o :			Check LSU for further info

	******|| REMARKABLE 	||******
	

	
		
	******|| NOTES		||******
	
	Strange thing are right here. First of all the PC increment system is not elegant at all. There are address sums here and there that I must fix. It works, but it's meh.
	we have the bju_active signals that I don't recall if it is usefull or not. 
	Moreover I should check this tcu_csr_postcontrol_int. I think using the tcu_csr_precontrol_init would be fine as well, but I have to check
	Results MUX is quite a mess to read, but I'm satisfied enough by it. We have a bit for each possible selection path. However there still is that hideous sum, which will result
	in another adder.
*/

import beta_exe_stage_pkg::*;
import beta_dec_stage_pkg::*;
import beta_csr_pkg::*;
import beta_trap_pkg::*;

module beta_exe_stage #(
	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32
)
(
	input logic 			clk_i,
	input logic 			rstn_i,
	
	input logic			exe_new_instr_i,	
	
	input logic[DataWidth-1:0] 	exe_operand_a_i,
	input logic[DataWidth-1:0]	exe_operand_b_i,

	input logic[4:0] 		exe_rd_addr_i,

	input logic[AddrWidth-1:0] 	exe_pc_i,
	input logic[11:0]		exe_offset12_i,
	input logic[19:0]		exe_offset20_i,
	input exe_control_word_t	exe_control_word_i,

	output logic[AddrWidth-1:0]	exe_next_pc_o,
	output logic[DataWidth-1:0]	exe_result_o,
	output logic[4:0] 		exe_rd_addr_o,
	output logic			exe_reg_wr_en_o,
	
	/* Illegal instruction Exception Signals */
	
	input logic			exe_invalid_instr_i,
	input logic[DataWidth-1:0] 	exe_invalid_instrval_i,
	
	/* Interrupt signals */
	
	input logic 			exe_sw_intr_i,
	input logic			exe_tim_intr_i,
	input logic			exe_ext_intr_i,
	
	//Inter Stages sync port

	input  logic[1:0]		exe_instr_penality_i,
	input  logic			dec_stage_busy_i,
	output logic			exe_stage_busy_o,
	output logic[1:0]		exe_bju_active_o,
	output logic			exe_branch_taken_o,
	output logic [1:0]		exe_trap_taken_o,
	
	//Data memory/LSU port 

	/*Read Data Memory Port*/
	input  logic			rdata_ready_i,
	input  logic			rdata_valid_i,
	input  logic[DataWidth-1:0] 	rdata_data_i,
	output logic[AddrWidth-1:0] 	rdata_addr_o,
	output logic[DataWidth/8-1:0]	rdata_strb_o,
	output logic 			rdata_req_o,

	/*Write Data Memory Port*/
	input  logic			wdata_ready_i,
	input  logic			wdata_valid_i,
	output logic[DataWidth-1:0] 	wdata_data_o,
	output logic[AddrWidth-1:0] 	wdata_addr_o,
	output logic[DataWidth/8-1:0]	wdata_strb_o,
	output logic 			wdata_req_o

);

	logic[AddrWidth-1:0]	exe_next_pc_int;
	logic[DataWidth-1:0]	exe_result_int; 

	exe_alu_status_t 	exe_alu_stat_int;
	logic[DataWidth-1:0]	alu_result_int;

	logic[4:0]		exe_rd_addr_int;

	exe_alu_op_t		alu_op_int;
	exe_bju_op_t		bju_op_int;

	logic			bju_misalig_pc_int;
	logic[AddrWidth-1:0]	bju_next_pc_int;
	logic			bju_branch_taken_int;
	logic[AddrWidth-1:0]	incr_pc_int;

	logic[6:0] 		result_mux_sel_int;
	logic	 		nextpc_mux_sel_int;
	logic[1:0]		trap_nextpc_sel_int;

	logic[1:0] 		shu_mode_int;
	logic	 		shu_en_int;
	logic			shu_busy_int;
	logic[1:0]		shu_size_int;

	logic 			lsu_busy_int;
	logic[1:0] 		lsu_op_size_int;
	logic 			lsu_op_int;
	logic 			lsu_en_int;
	logic[DataWidth-1:0]	lsu_result_int;
	
	logic[2:0]		csr_op_int;
	logic			csr_en_int;
	logic[1:0]		priv_lvl_int = 2'b11;
	
	logic			exe_reg_wr_en_int;
	logic[1:0]		exe_trap_taken_int;
	
	// CSR Regfile Signals
	
	logic [DataWidth-1:0] 	csr_rdata_int;
	csr_ctrl_t		tcu_csr_precontrol_int;
	csr_ctrl_t		tcu_csr_postcontrol_int;
	logic [DataWidth-1:0] 	tcu_mtval_int;
	logic [4:0] 		tcu_mcause_int;
	logic [AddrWidth-1:0] 	tcu_mepc_int;
	logic [AddrWidth-1:0] 	csr_mepc_int;
	logic			tcu_sw_int_pend_int;
	logic  			tcu_tim_int_pend_int;			
	logic   		tcu_ext_int_pend_int;
	logic [2:0]		tcu_trap_state_int;
	logic			tcu_csr_we_int;
	
	logic [AddrWidth-1:0]	trap_address_int;
	logic [1:0]		trap_detected_int;
	logic [AddrWidth-1:0] 	pretrap_next_pc_int;
	
	
	assign incr_pc_int = exe_pc_i + 32'h00000004;
	assign exe_rd_addr_int = exe_rd_addr_i;
	assign shu_size_int = {|exe_operand_b_i[4:1],exe_operand_b_i[0]};

	//Instantiating Exe Control Unit

	logic	exe_stage_busy_int;

	beta_exe_cu exe_cu(
		.clk_i(clk_i),
		.rstn_i(rstn_i),
	
		.execu_control_word_i(exe_control_word_i),
		.execu_new_instr_i(exe_new_instr_i),	
		
		/*Arithmetic & Logic Unit Port */
		.execu_alu_op_o(alu_op_int),

		/*Shift Unit Port*/
		.execu_shu_size_i(shu_size_int), //00 No Shift, 01 One Shift, 10/11 Multiple shifts
		.execu_shu_busy_i(shu_busy_int),
		.execu_shu_mode_o(shu_mode_int),
		.execu_shu_en_o(shu_en_int),
	

		/*Branch & Jump Unit Port*/
		.execu_bju_op_o(bju_op_int),
		.execu_bju_btaken_i(bju_branch_taken_int),

		/*Load & Store Unit Port*/
		.execu_lsu_busy_i(lsu_busy_int),
		.execu_lsu_op_size_o(lsu_op_size_int),
		.execu_lsu_op_o(lsu_op_int),
		.execu_lsu_en_o(lsu_en_int),
		
		/*CSR Unit Port*/
		.execu_csr_op_o(csr_op_int),
		.execu_csr_en_o(csr_en_int),
		
		/*Trap Detection Port*/
		
		.execu_trap_detected_i(trap_detected_int),
		.execu_trap_ret_i(exe_control_word_i[24]),	//xRET Instruction flag
		.execu_trap_nextpc_sel_o(trap_nextpc_sel_int),
		.execu_trap_taken_o(exe_trap_taken_int),
		
		/*Selection Path Port*/
		.execu_result_sel_o(result_mux_sel_int),
		.execu_nextpc_sel_o(nextpc_mux_sel_int),

		/*Busy/Synch signals port*/
			
		.execu_exe_stage_busy_o(exe_stage_busy_int),
		.execu_reg_wr_en_o(exe_reg_wr_en_int)		

	);

	//Instantiating ALU
	beta_alu alu (
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.alu_operand_a_i(exe_operand_a_i),
		.alu_operand_b_i(exe_operand_b_i),
		.alu_op_i(alu_op_int),

		.alu_stat_o(exe_alu_stat_int),
		.alu_op_end_o(),
		.alu_result_o(alu_result_int)
	);

	//Instantiating SHU (Shift Unit)

	logic [DataWidth-1:0] shu_result_int;

	beta_shift_unit shu(
		.clk_i(clk_i),
		.rstn_i(rstn_i),

		.shu_operand_a_i(exe_operand_a_i),
		.shu_operand_b_i(exe_operand_b_i[4:0]),
		.shu_mode_i(shu_mode_int),
		.shu_en_i(shu_en_int),

		.shu_busy_o(shu_busy_int),
		.shu_result_o(shu_result_int)

	);

	//Instantiating BJU
	logic [1:0] exe_jal_after_seq;
	
	always_ff @(posedge clk_i) begin: ffproc
		if( rstn_i == 1'b0  ) begin exe_jal_after_seq <= 2'b00; end
		else if( exe_jal_after_seq == 2'b00 & exe_stage_busy_int ) begin exe_jal_after_seq <= 2'b01; end
		else if( exe_jal_after_seq == 2'b01 & ~exe_stage_busy_int ) begin exe_jal_after_seq <= 2'b10; end
		else if( exe_jal_after_seq == 2'b10 & bju_op_int[1:0] == 2'b00 ) begin exe_jal_after_seq <= 2'b00; end
		else begin exe_jal_after_seq <= 2'b00; end
	end
	
	assign exe_bju_active_o = ( exe_invalid_instrval_i == 32'h00000013 & exe_jal_after_seq != 2'b00 ) ? 2'b11 : exe_control_word_i.exe_bju_en;
	
	beta_bju bju (
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.bju_pc_i(( exe_jal_after_seq != 2'b10 ) ? exe_pc_i : exe_pc_i + 32'h4),
		.bju_offset12_i(exe_offset12_i),
		.bju_offset20_i(exe_offset20_i),
		.bju_basereg_i(exe_operand_a_i),
		.bju_alu_stat_i(exe_alu_stat_int),
		.bju_op_i(bju_op_int),

		.bju_misalig_pc_o(bju_misalig_pc_int),
		.bju_next_pc_o(bju_next_pc_int),
		.bju_branch_taken_o(bju_branch_taken_int)
	);
	
	//Instantiating LSU

	logic[AddrWidth-1:0]	lsu_addr_int = alu_result_int; 
	logic[AddrWidth-1:0]	lsu_invalid_addr_int;
	logic[1:0]		lsu_misalig_op_int;
	
	beta_lsu lsu (
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.lsu_op_data_i(exe_operand_b_i),	//Write data is exactly operand b.
		.lsu_op_addr_i(lsu_addr_int),		//the memory address is bore by the ALU
		.lsu_rdata_ready_i(rdata_ready_i),
		.lsu_rdata_valid_i(rdata_valid_i),
		.lsu_rdata_data_i(rdata_data_i),
		.lsu_rdata_addr_o(rdata_addr_o),
		.lsu_rdata_strb_o(rdata_strb_o),
		.lsu_rdata_req_o(rdata_req_o),
		.lsu_wdata_ready_i(wdata_ready_i),
		.lsu_wdata_valid_i(wdata_valid_i),
		.lsu_wdata_data_o(wdata_data_o),
		.lsu_wdata_addr_o(wdata_addr_o),
		.lsu_wdata_strb_o(wdata_strb_o),
		.lsu_wdata_req_o(wdata_req_o),
		.lsu_misalig_op_o(lsu_misalig_op_int),
		.lsu_invalid_addr_o(lsu_invalid_addr_int),
		.lsu_op_size_i(lsu_op_size_int),
		.lsu_op_i(lsu_op_int),
		.lsu_op_en_i(lsu_en_int),
		.lsu_woffset_i(exe_offset12_i),	//Store offset. (remember that stores are encoded similarly to branches)
		.lsu_busy_o(lsu_busy_int),
		.lsu_result_o(lsu_result_int)	//The result shall be driven into an internal signal and then in the result MUX
	);

	//Instantiating CSR regfile

	
	beta_csr_regfile csr_reg (
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.csr_addr_i(exe_operand_b_i[11:0]),
		.csr_wdata_i(exe_operand_a_i),
		.csr_op_i(csr_op_int),
		.csr_en_i(csr_en_int), 
		.csr_rdata_o(csr_rdata_int),
		/* Trap Signals */
		.csr_mtval_i(tcu_mtval_int),
		.csr_mcause_i({tcu_mcause_int[4],27'h0000000,tcu_mcause_int[3:0]}),
		.csr_mepc_i((nextpc_mux_sel_int) ? {tcu_mepc_int[31:2]+30'h1,tcu_mepc_int[1:0]} : tcu_mepc_int) ,//In case of interrupted branches/jals increase by four the mepc due to csr we timing
		.csr_sw_int_pend_i(tcu_sw_int_pend_int),
		.csr_tim_int_pend_i(tcu_tim_int_pend_int),			
		.csr_ext_int_pend_i(tcu_ext_int_pend_int),
		.csr_trap_state_i(tcu_trap_state_int),								//MIE,MPIE,MPP
		.tcu_csr_we_i(tcu_csr_we_int & exe_new_instr_i ),						//Only 1 TCU write x instr
		.csr_mepc_o(csr_mepc_int),
		/* Trap Signals */
		.csr_priv_lvl_i(priv_lvl_int),		//Fixed Machine Level 
		.csr_control_o(tcu_csr_precontrol_int)	
	);
	
	//Instantiating Trap Control Unit

	//Delete this two lines, they are pointless now
	assign tcu_csr_postcontrol_int = tcu_csr_precontrol_int;
	assign tcu_csr_postcontrol_int.mie = tcu_csr_precontrol_int.mie;

	beta_trap_control_unit tcu (
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.priv_lvl_i(priv_lvl_int[0]),
		.tcu_next_pc_i(pretrap_next_pc_int),
		.tcu_fault_instr_i(exe_invalid_instrval_i),
		.tcu_lsu_fault_addr_i(lsu_invalid_addr_int),
		.tcu_csr_control_i(tcu_csr_postcontrol_int),
		.tcu_mtval_o(tcu_mtval_int),
		.tcu_mcause_o(tcu_mcause_int),
		.tcu_mepc_o(tcu_mepc_int),
		.tcu_sw_int_pend_o(tcu_sw_int_pend_int),
		.tcu_tim_int_pend_o(tcu_tim_int_pend_int),			
		.tcu_ext_int_pend_o(tcu_ext_int_pend_int),
		.tcu_trap_state_o(tcu_trap_state_int),
		.tcu_csr_we_o(tcu_csr_we_int),
		.tcu_sw_intr_i(exe_sw_intr_i),
		.tcu_tim_intr_i(exe_tim_intr_i),
		.tcu_ext_intr_i(exe_ext_intr_i),
		.tcu_instr_exception_i({exe_invalid_instr_i,bju_misalig_pc_int}),
		.tcu_lsu_exception_i(lsu_misalig_op_int),
		.tcu_env_exception_i(exe_control_word_i[24:23]),			//xCALL & xRET
		.tcu_instr_penality_i(exe_instr_penality_i),
		.tcu_trap_address_o(trap_address_int),
		.tcu_trap_detected_o(trap_detected_int),
		.tcu_halt_o()
	);
	
	//Result MUX
	always_comb begin: result_mux
		if(result_mux_sel_int[0] == 1'b1) begin //JALR and JAL result saving PC + 4 (return address)
			exe_result_int = ( exe_trap_taken_int[0] ) ? {exe_pc_i[31:2]+30'h1,exe_pc_i[1:0]} : exe_pc_i;	//In case of interrupted jals increase because of csr we timing (TEMPORARY)
		end
		else if(result_mux_sel_int[6] == 1'b1) begin //CSR read result
			exe_result_int = csr_rdata_int;
		end
		else if(result_mux_sel_int[5] == 1'b1) begin //LOAD MEMORY result
			exe_result_int = lsu_result_int;
		end
		else if(result_mux_sel_int[4] == 1'b1) begin //AUIPC result
			exe_result_int = alu_result_int + exe_pc_i;
		end
		else if(result_mux_sel_int[0] == 1'b0) begin //Other Operational Units result
			if(shu_mode_int != SHIFT_NONE) begin //SHU Result
				case(result_mux_sel_int[2:1])
					2'b00: exe_result_int = alu_result_int; //0 Shift
					2'b01: begin //1 Shift
						if(shu_mode_int == SHIFT_LEFT ) exe_result_int = {alu_result_int[DataWidth-2:0],1'b0};
						else if(shu_mode_int == SHIFT_RIGHT ) exe_result_int = {1'b0,alu_result_int[DataWidth-1:1]};
						else if(shu_mode_int == SHIFT_ARIGHT ) exe_result_int = ( alu_result_int[DataWidth-1] == 1'b1 ) ? {1'b1,alu_result_int[DataWidth-1:1]} : {1'b0,alu_result_int[DataWidth-1:1]};
						else exe_result_int = alu_result_int;		//This shall never be performed, but we need it for synthesis purposes
					end
					default: exe_result_int = shu_result_int; //Multiple Shift
				endcase;
			end
			else if(result_mux_sel_int[3] == 1'b1) begin //SLT result
				exe_result_int = {31'h00000000,exe_alu_stat_int.negative};
			end
			else begin //ALU result
				exe_result_int = alu_result_int;
			end
		end
		else begin exe_result_int = alu_result_int; end		//This shall never be performed, but we need it for synthesis purposes
	end

	//Next PC MUX
	
	
	always_comb begin: next_pc_mux
		case(nextpc_mux_sel_int)
			1'b0: pretrap_next_pc_int = incr_pc_int;
			1'b1: pretrap_next_pc_int = bju_next_pc_int;
		endcase;
		
		case(trap_nextpc_sel_int)
			2'b00: exe_next_pc_int = pretrap_next_pc_int;		//Conventional Execution
			2'b01: exe_next_pc_int = trap_address_int;		//Trapped Execution
			2'b11: exe_next_pc_int = csr_mepc_int;			//xRET Execution
			default: exe_next_pc_int = pretrap_next_pc_int;
		endcase;
	end
	
	assign exe_branch_taken_o = bju_branch_taken_int;
	assign exe_next_pc_o = exe_next_pc_int;
	assign exe_result_o = exe_result_int;
	assign exe_rd_addr_o = exe_rd_addr_int;
	assign exe_trap_taken_o = exe_trap_taken_int;

	assign exe_stage_busy_o = exe_stage_busy_int;
	assign exe_reg_wr_en_o = exe_reg_wr_en_int;


endmodule
