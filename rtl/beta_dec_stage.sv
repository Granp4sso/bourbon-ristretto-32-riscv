`include "pkg/beta_dec_stage_pkg.sv"

/*
	Instruction Decode Stage v0.3 22/05/2022

	******|| INSTANTIABLES 	||******

	The instruction fetch stage is the first stage in the pipe. It can support the following units:

						- CodeType,	Mandatory,	Supported
		-Instruction Decoder	 	- [UNIT		Y		Y	]
		-Compressed Decoder	 	- [UNIT		N		N	]
		-Control Signal uROM 		- [UNIT		Y		Y	]
		-Regfile			- [UNIT		Y		Y	]
		-Operand A MUX			- [PROCESS	Y		Y	]
		-Operand B MUX			- [PROCESS	Y		Y	]

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	-Compressed :		Presence of compressed instruction extension
	-Embedded :		Presence of RV32E profile (16 registers instead of 32)
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	-dec_instr_i :		Instruction fetched from the if stage 		
	-dec_new_instr_i : 	Is a new instruction data provided?
	-dec_rd_wdata_i : 	Register Destination data to be written. Forwarded from the exe stage
	-dec_rd_addr_i : 	Register Destination address to be written. Forwarded from the exe stage	
	-dec_reg_wr_en_i : 	Register Write Enable. It is forwarded from the exe stage	
	-dec_offset12_o : 	12-bit Offset decoded from the instruction. It is used for mem and branches operations.
	-dec_offset20_o : 	20-bit Offset decoded from the instruction. It is used for jumps operations.	
	-dec_operand_a_o : 	Operand selected from the MUXes and extracted from the instruction. It is forwarded to the exe stage	
	-dec_operand_b_o : 	Operand selected from the MUXes and extracted from the instruction. It is forwarded to the exe stage	
	-dec_rd_addr_o : 	Register Destination address sent to the exe stage. It must be forwarded to allow the pipe to work	
	-dec_control_word_o : 	Control Word computed by the uROM. It holds all the signals to drive this and the following stages.	
	-if_stage_busy_i : 	Is the Instruction Fetch performing a sequential operation? (e.g. the imem protocol)
	-dec_stage_busy_o : 	Is the Decode Stage performing sequential operations? (none at the moment)

	******|| REMARKABLE 	||******

	New Instruction Latch event process: 
		This process indicates a possible pending write request. As soon as data are ready from the exe
		stage, rd_wr_en_int becomes high and in the next clock cycle the new_instruction_latch is reset untill a
		new instruction is provided. In this way the regfile is written only once per instruction.
		This implies that no instruction can write more than once in the regfile.

	Mux_exe_stage_opA_selection:
		This multiplexer is used to select a register data OR a 12-bit immediate shifted in the upper word.
		That's necessary for LUI and AUIPC instructions.

	Mux_exe_stage_opB_selection:
		This multiplexer choices between the register as a second source, or an immediate. 12-bit immediates are sign-extended
		and used for I-type instructions, while 20-bit immediates are usually used for JAL and JALR. They are not extended.
		NB: AT THE MOMENT ONLY 32-BITS CONFIGURATION ARE ACTUALLY SUPPORTED
	

	******|| NOTES		||******

	Only the operand B is sign extended, directly into the MUX.
	The wr_en signal must be high for exactly 1 clock cycle, so that an exe requested write will occur one time.
	That's why we need the new instruction signal and latch that event. in this way when we receive a high wr_en signal,
	the latch is lowered and the write executed. Untill a new instruction is fetched, no new write will be performed.

*/


module beta_dec_stage import beta_pkg::*; #(

	parameter unsigned DataWidth = 32,

	parameter unsigned Compressed = 0,
	parameter unsigned Embedded = 0
)(

	input logic 			clk_i,
	input logic 			rstn_i,
	input logic[DataWidth-1:0] 	dec_instr_i,
	input logic			dec_new_instr_i,

	//Regfile input signals
	input logic[DataWidth-1:0] 	dec_rd_wdata_i,
	input logic[4:0] 		dec_rd_addr_i,
	input logic			dec_reg_wr_en_i,

	output logic[11:0] 		dec_offset12_o,
	output logic[19:0]		dec_offset20_o,
	output logic[DataWidth-1:0] 	dec_operand_a_o,
	output logic[DataWidth-1:0] 	dec_operand_b_o,
	output logic[4:0] 		dec_rd_addr_o,
	output dec_control_word_t 	dec_control_word_o,

	/*Intra stage sync*/
	input logic			if_stage_busy_i,
	output logic			dec_stage_busy_o
	
);

	logic [4:0] 		rs1_addr_int;
	logic [4:0] 		rs2_addr_int;
	logic [11:0] 		imm12_int; 
	logic [19:0] 		imm20_int;
	logic [XLEN-1:0] 	rs1_data_int;
	logic [XLEN-1:0] 	rs2_data_int;
	logic [8:0] 		cu_address_int;
	logic 			invalid_instr_int;
	logic [4:0] 		rd_addr_int;

	logic [XLEN-1:0] 	operand_a_int;
	logic [XLEN-1:0] 	operand_b_int;

	logic			rd_wr_en_int;
	logic 			new_instruction_latch;
	
	dec_control_word_t 	control_word_int;

	assign dec_offset12_o = imm12_int;
	assign dec_offset20_o = imm20_int;
	assign dec_rd_addr_o = rd_addr_int;
	assign dec_control_word_o = control_word_int;
	assign dec_operand_a_o = operand_a_int;
	assign dec_operand_b_o = operand_b_int;

	/*For the moment the decode stage is purely combinatorial, hence no specific check on busy signals is required*/

	assign dec_stage_busy_o = if_stage_busy_i;
	assign rd_wr_en_int = new_instruction_latch & dec_reg_wr_en_i;

	/*New instruction latch process*/
	
	always_ff@(posedge clk_i) begin: new_instruction_latch_proc
		if(rstn_i == 1'b0) begin
			new_instruction_latch <= 1'b0;
		end
		else if(dec_new_instr_i) begin
			new_instruction_latch <= 1'b1;
		end
		else if(dec_reg_wr_en_i & new_instruction_latch) begin
			new_instruction_latch <= 1'b0;
		end
	end
	
	/*Instantiation*/

	beta_decoder decoder (
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.instr_i(dec_instr_i),

		.rs1_o(rs1_addr_int),
		.rs2_o(rs2_addr_int),
		.rd_o(rd_addr_int),

		.imm12_o(imm12_int),
		.imm20_o(imm20_int),

		.cu_addr_o(cu_address_int),

		.invalid_instr_o(invalid_instr_int)
	);

	beta_regfile regfile (
		.clk_i(clk_i),
		.rstn_i(rstn_i),

		.rs1_addr_i(rs1_addr_int),
		.rs2_addr_i(rs2_addr_int),
		.rd_addr_i(dec_rd_addr_i),

		.wr_en_i(rd_wr_en_int),
		.rd_wdata_i(dec_rd_wdata_i),

		.rs1_data_o(rs1_data_int),
		.rs2_data_o(rs2_data_int)

	);

	beta_cu control_unit (
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.cu_address_i(cu_address_int),
		.invalid_instr_i(invalid_instr_int),

		.control_word_o(control_word_int)
	);

	//Multiplexer for operand A selection

	always_comb begin : Mux_exe_stage_opA_selection

		case( control_word_int.dec_src1_select )
			2'b00 : operand_a_int = rs1_data_int;
			2'b01 : operand_a_int = {imm20_int,12'h000};
			default : operand_a_int = '0;
		endcase;
	end	

	//Multiplexer for operand B selection & Extension

	always_comb begin : Mux_exe_stage_opB_selection

		case( control_word_int.dec_src2_select )
			2'b00 : operand_b_int = rs2_data_int;
			2'b01 : begin
				if(control_word_int.dec_not_sign_ext) operand_b_int = {20'h00000,imm12_int};
				else operand_b_int = (imm12_int[11] == 1'b0) ? {20'h00000,imm12_int} : {20'hfffff,imm12_int};
			end
			2'b10 : operand_b_int = {12'h000,imm20_int};
			2'b11 : operand_b_int = 32'h000000000;
			default : operand_b_int = '0;
		endcase;
	end


endmodule;
