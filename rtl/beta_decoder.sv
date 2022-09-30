`include "pkg/beta_dec_stage_pkg.sv"

/*
	Instruction Decoder v0.3 26/08/2022

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines 
	-AddrWidth :		Width of addresses
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	
	-idec_instr_i:			Instruction coming from the instruction fetch stage
	-idec_rs1_o:			Source register 1 decoded from the input instruction
	-idec_rs2_o:			Source register 2 decoded from the input instruction
	-idec_rd_o:			Destination register decoded from the input instruction
	-idec_imm12_o:			12 bits immediate decoded from the input instruction
	-idec_imm20_o:			20 bits immediate decoded from the input instruction
	-idec_addr_o:			Micro-rom address signal
	-idec_subaddr_o:		Micro-rom sub-addressing signal. It is used for SYS opcodes.
	-idec_invalid_instr_o:		If a legal instruction is fetched, an invalid instruction signal will be raised (Exception)

	******|| REMARKABLE 	||******

	standard_signal_building:
	
		This process builds the source registers and destination register signals. They might not be used always, however they are computed anyways.
		Such a choice implies a major power consumption, but a faster solution. Is it even worth it? In future I could gate to zero such signals if they are not required. 
		
	urom_signals_building:
	
		This proces builds the urom address using function 7 and function 3 fields, along with the opcode field.
		
	immediate_building:
	
		This proces builds the immediate whenever they are required.

	******|| NOTES		||******

	The instruction decoder is meant to take the instruction from the if_stage and extract several crucial information. (Registers, Immediates, Offsets and Illegal Instructions flags).
	Control signals are then produced by means of a urom, addressed thanks to the idec_addr and idec_subaddr signals.

*/

module beta_decoder import beta_dec_stage_pkg::*; #(

	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32

) 
(
	input logic 			clk_i,
	input logic 			rstn_i,
	input logic[DataWidth-1:0] 	idec_instr_i,

	output logic[4:0] 		idec_rs1_o,
	output logic[4:0] 		idec_rs2_o,
	output logic[4:0] 		idec_rd_o,

	output logic[11:0]		idec_imm12_o,
	output logic[19:0] 		idec_imm20_o,

	output logic[8:0] 		idec_addr_o,
	output logic[4:0]		idec_subaddr_o,

	output logic 			idec_invalid_instr_o
	
);
	logic [6:0] 	opcode_int;
	logic [2:0] 	funct3_int;
	logic [6:0] 	funct7_int;

	logic[4:0] 	rs1_int;
	logic[4:0] 	rs2_int;
	logic[4:0] 	rd_int;

	logic[11:0] 	imm12_int;
	logic[19:0] 	imm20_int;

	logic[8:0] 	urom_addr_int;
	logic 		invalid_instr_int;


	logic 		funct7_mask_bit_int;
	logic 		funct3_mask_bit_int;
	logic 		invalid_opcode_int;


	assign opcode_int = idec_instr_i[6:0];
	assign funct3_int = idec_instr_i[14:12];
	assign funct7_int = idec_instr_i[31:25];

	assign idec_rs1_o = rs1_int;
	assign idec_rs2_o = rs2_int;
	assign idec_rd_o = rd_int;

	assign idec_imm12_o = imm12_int;
	assign idec_imm20_o = imm20_int;

	assign idec_addr_o = (invalid_instr_int) ? '1 : urom_addr_int; 
	assign idec_subaddr_o = {imm12_int[9:8],imm12_int[2:0]};
	assign idec_invalid_instr_o = invalid_instr_int;

	initial assign funct7_mask_bit_int = 0;

	always_comb begin : standard_signal_building
		rs1_int = idec_instr_i[19:15];
		rs2_int = idec_instr_i[24:20];
		rd_int = idec_instr_i[11:7];
	end

	always_comb begin : urom_signals_building

		/*
			Each ISA instruction can be split into 32 categories (OP-codes). 5 bits are used for such a purpose, while the lower 2 bits are set to 11 (If compressed
			instructions are not supported). The funct3 is a 3 bit field encoding 8 possible micro-functionalities, for a total of 256 possible instructions.
			Finally we have 7 more bits in the funct7 fields used to extend such micro-functinoalities.
			RV32I does not usually use such a field a part from a couple of instructions using just one of those 7 bits.
			https://five-embeddev.com/riscv-isa-manual/latest/opcode-map.html#opcodemap
		*/
		
		funct3_mask_bit_int = 1'b0;
		invalid_opcode_int = 0;
		funct7_mask_bit_int = 0;
		
		case(opcode_int[6:2]) 
			OPCODE_IMM[6:2]			: begin funct7_mask_bit_int = (funct7_int == 7'h20 & funct3_int == 3'h5) ? 1'b1 : 1'b0; end
			OPCODE_LUI[6:2]			: begin funct3_mask_bit_int = 1'b1; end
			OPCODE_AUIPC[6:2]		: begin funct3_mask_bit_int = 1'b1; end
			OPCODE_REG[6:2]			: begin funct3_mask_bit_int = 1'b0; funct7_mask_bit_int = 1; end
			OPCODE_JAL[6:2]			: begin funct3_mask_bit_int = 1'b1; end
			OPCODE_JALR[6:2]		: begin funct3_mask_bit_int = 1'b1; end
			OPCODE_BRANCH[6:2]		: begin funct3_mask_bit_int = 1'b0; end
			OPCODE_LOAD[6:2]		: begin funct3_mask_bit_int = 1'b0; end
			OPCODE_STORE[6:2]		: begin funct3_mask_bit_int = 1'b0; end
			OPCODE_MISC_MEM[6:2]		: begin funct3_mask_bit_int = 1'b0; end					//Nothing supported from this category
			OPCODE_SYSTEM[6:2]		: begin	funct3_mask_bit_int = 1'b0;  end

			default				: begin funct3_mask_bit_int = 1'b0; invalid_opcode_int = 1; end
		endcase;
		
		/* 
			Some instructions do not require the funct7 or the funct3 field, hence we can mask their decoding.
			The urom address is built accordingly:
				-urom_addr_int[0] 	: odd addresses points to funct7 (single bit) instructions
				-urom_addr_int[3:1] 	: here we have the funct3 field, if used
				-urom_addr_int[8:4] 	: here we have the category.
				
			Finally, ant this stage, an invalid instruction can happen because of not word aligned instructions, or not recognized instructions.
		*/
		
		urom_addr_int[0] = funct7_mask_bit_int & funct7_int[5];
		urom_addr_int[3:1] = (funct3_mask_bit_int) ? '0 : funct3_int;
		urom_addr_int[8:4] = opcode_int[6:2];
		
		invalid_instr_int = ~opcode_int[0] | ~opcode_int[1] | invalid_opcode_int;

	end

	always_comb begin : immediate_building
	
		// Immediates will be changed only if necessary
		
		imm20_int = 20'h0000;
		imm12_int = 12'h000;

		case(opcode_int[6:2])

			OPCODE_IMM[6:2]		: begin imm12_int = idec_instr_i[31:20]; end
			OPCODE_LUI[6:2]		: begin imm20_int = idec_instr_i[31:12]; end
			OPCODE_AUIPC[6:2] 	: begin imm20_int = idec_instr_i[31:12]; end
			OPCODE_REG[6:2]		: begin end
			OPCODE_JAL[6:2]		: begin imm20_int = {idec_instr_i[31],idec_instr_i[19:12],idec_instr_i[20],idec_instr_i[30:21]}; end
			OPCODE_JALR[6:2]	: begin imm12_int = idec_instr_i[31:20]; end
			OPCODE_BRANCH[6:2]	: begin imm12_int = {idec_instr_i[31],idec_instr_i[7],idec_instr_i[30:25],idec_instr_i[11:8]}; end
			OPCODE_LOAD[6:2]	: begin imm12_int = idec_instr_i[31:20]; end
			OPCODE_STORE[6:2]	: begin imm12_int = {idec_instr_i[31:25],idec_instr_i[11:7]}; end
			OPCODE_MISC_MEM[6:2]	: begin end
			OPCODE_SYSTEM[6:2]	: begin imm12_int = idec_instr_i[31:20];end

			default			: begin end
		endcase;

	end

endmodule;
