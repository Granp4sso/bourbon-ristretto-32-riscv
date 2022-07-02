//`include "beta_def.sv"

/*
13/05/2022
Version 0.3

	- The invalid instruction is apllied here to stop the microrom from selecting the word 0000000 (Load Byte)
	- Takes instruction as an input and extracts:
		--Source register 1
		--Source register 2
		--Destination register
		--Immediate (12 or 20)
		--Invalid instruction exception
		--Control Unit micro-ROM 9-bit address made by
			---instruction opcode (Major opcode)
			---instruction funct3 (Minor opcode)
			---instruction funct7 (Further specifies minor opcode)
*/

module beta_decoder #() 
(
	input logic clk_i,
	input logic rstn_i,
	input logic[XLEN-1:0] instr_i,

	output logic[4:0] rs1_o,
	output logic[4:0] rs2_o,
	output logic[4:0] rd_o,

	output logic[11:0] imm12_o,
	output logic[19:0] imm20_o,

	output logic[8:0] cu_addr_o,

	output logic invalid_instr_o
	
);
	import beta_pkg::*;

	logic [6:0] opcode_int;
	logic [2:0] funct3_int;
	logic [6:0] funct7_int;

	logic[4:0] rs1_int;
	logic[4:0] rs2_int;
	logic[4:0] rd_int;

	logic[11:0] imm12_int;
	logic[19:0] imm20_int;

	logic[8:0] cu_addr_int;
	logic invalid_instr_int;

	/*Segnali ausiliari*/

	logic funct7_mask_bit_int;
	logic funct3_mask_bit_int;
	logic invalid_opcode_int;

	/*	
		Contro unit signals are still to be defined. At least we require a signal specifiying if the decoded instruction
		is U, UJ, B, S, L, I, Reg. Then the CU internal micro-ROM is supposed to jump to the correct micro-program.

		The UC will use instructions to address the MicroRom. We'll Need
		Sign extension or not
		Select Immediate or Registers
		Enable left shift
		Enable Right Shift
		Addition
		Subtraction

		We want the Alu to be responsible for making only calculations.
	*/

	/**/

	assign opcode_int = instr_i[6:0];
	assign funct3_int = instr_i[14:12];
	assign funct7_int = instr_i[31:25];

	assign rs1_o = rs1_int;
	assign rs2_o = rs2_int;
	assign rd_o = rd_int;

	assign imm12_o = imm12_int;
	assign imm20_o = imm20_int;

	assign cu_addr_o = (invalid_instr_int) ? '1 : cu_addr_int; //Temporary fix, it will be handled by exception paths (outside)
	assign invalid_instr_o = invalid_instr_int;

	initial assign funct7_mask_bit_int = 0;

	always_comb begin : standard_signal_building
		rs1_int = instr_i[19:15];
		rs2_int = instr_i[24:20];
		rd_int = instr_i[11:7];
	end

	always_comb begin : CU_signals_building

		/*
		Ogni istruzione dell'ISA possiede 32 distinte categorie (OP-Code) poichè 5 bit sono liberi 2 sono fissati a 11. (fa eccezione la versione compressa).
		https://five-embeddev.com/riscv-isa-manual/latest/opcode-map.html#opcodemap
		Per ogni categoria vi sono 8 possibili microfunzionalità (funct3), per un totale di 256 istruzioni. Infine ci sono teoricamente altri 7 bit dati da 
		funct 7 per estendere eventualmente tali microfunzionalità, anche se non mi è ancora chiaro come sfruttarlo. Al momento posso considerarlo puramente binario
		per un totale di 512 istruzioni, o in alternativa un massimo di 256*2^7 = 32768 istruzioni.
		*/
		funct3_mask_bit_int = 1'b0;
		case({2'b00,opcode_int[6:2]}) //i primi 2 bit sono sempre pari a 1. Ciò implic una possibile identificazione più rapida di istruzioni non valide
			OPCODE_IMM/4	: 
				begin
					/*Il funct7 diventa d'interesse unicamente per le operazioni di shift nel caso di immediati*/

					if(funct7_int == 7'h20 & funct3_int == 3'h5)
						funct7_mask_bit_int = 1;
					else funct7_mask_bit_int = 0;

					invalid_opcode_int = 0;
				
				end
			OPCODE_LUI/4	: 
				begin
					funct3_mask_bit_int = 1'b1;
					funct7_mask_bit_int = 0;
					invalid_opcode_int = 0;
				end
			OPCODE_AUIPC/4	:
				begin
					funct3_mask_bit_int = 1'b1;
					funct7_mask_bit_int = 0;
					invalid_opcode_int = 0;
				end
			OPCODE_REG/4	:
				begin
					funct3_mask_bit_int = 1'b0;
					funct7_mask_bit_int = 1;
					invalid_opcode_int = 0;
				end
			OPCODE_JAL/4	:
				begin
					funct3_mask_bit_int = 1'b1;
					funct7_mask_bit_int = 0;
					invalid_opcode_int = 0;
				end
			OPCODE_JALR/4	:
				begin
					funct3_mask_bit_int = 1'b1;
					funct7_mask_bit_int = 0;
					invalid_opcode_int = 0;
				end
			OPCODE_BRANCH/4	:
				begin
					funct3_mask_bit_int = 1'b0;
					funct7_mask_bit_int = 0;
					invalid_opcode_int = 0;
				end
			OPCODE_LOAD/4	:
				begin;
					funct3_mask_bit_int = 1'b0;
					funct7_mask_bit_int = 0;
					invalid_opcode_int = 0;
				end
			OPCODE_STORE/4	:
				begin
					funct3_mask_bit_int = 1'b0;
					funct7_mask_bit_int = 0;
					invalid_opcode_int = 0;
				end

			OPCODE_MISC_MEM/4	:
				begin
					funct3_mask_bit_int = 1'b0;
					funct7_mask_bit_int = 0;
					invalid_opcode_int = 0;
				end
			OPCODE_SYSTEM/4	:
				begin
					funct3_mask_bit_int = 1'b0;
					funct7_mask_bit_int = 0;
					invalid_opcode_int = 0;
				end

			default		:
				begin
					funct3_mask_bit_int = 1'b0;
					funct7_mask_bit_int = 0;
					invalid_opcode_int = 1;
				end
		endcase;
		
		cu_addr_int[0] = funct7_mask_bit_int & funct7_int[5];
		cu_addr_int[3:1] = (funct3_mask_bit_int) ? '0 : funct3_int;
		cu_addr_int[8:4] = opcode_int[6:2];

		invalid_instr_int = ( opcode_int[1:0] == 2'b11 ) ? invalid_opcode_int : 1'b1;

	end

	always_comb begin : immediate_building

		case({2'b00,opcode_int[6:2]})

			OPCODE_IMM/4	: //OK
				begin
					
					imm12_int = instr_i[31:20];	
					imm20_int = 20'h0000;
					/*Shift instructions SLLI,SRLI,SRAI only uses 5 bits of the immediate, so the 7 most significant bits of imm12_int should be discarded.
					  That doesn't matter because Shift operation will be taken into account by the ALU itself, and so will be sign extension etc..					
					*/
				
				end
			OPCODE_LUI/4	: /*LUI Instruction shall be specified to CU*/
				begin
					imm12_int = 12'h00;
					imm20_int = instr_i[31:12];

				end
			OPCODE_AUIPC/4	: /*AUIPC Instruction shall be specified to CU*/
				begin
					imm12_int = 12'h00;
					imm20_int = instr_i[31:12];
				end
			OPCODE_REG/4	: /*SUB/ADD and SRL/SRA share the same funct3 but they do have different funct7. Such info will be passed to the CU to build the micro-ROM address*/
				begin
					imm12_int = 12'h00;
					imm20_int = 20'h00;
				end
			OPCODE_JAL/4	:
				begin
					imm12_int = 12'h00;
					imm20_int = {instr_i[31],instr_i[19:12],instr_i[20],instr_i[30:21]};
				end
			OPCODE_JALR/4	:
				begin
					imm12_int = instr_i[31:20];
					imm20_int = 20'h00;
				end
			OPCODE_BRANCH/4	:
				begin
					imm12_int = {instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8]};
					imm20_int = 20'h00;
				end
			OPCODE_LOAD/4	:
				begin
					imm12_int = instr_i[31:20];
					imm20_int = 20'h00;
				end
			OPCODE_STORE/4	:
				begin
					imm12_int = {instr_i[31:25],instr_i[11:7]};
					imm20_int = 20'h00;
				end

			OPCODE_MISC_MEM/4	:
				begin
					imm12_int = 12'h00;
					imm20_int = 20'h00;
				end
			OPCODE_SYSTEM/4	:
				begin
					imm12_int = 12'h00;
					imm20_int = 20'h00;
				end

			default		:
				begin
					imm12_int = 12'h00;
					imm20_int = 20'h00;
				end
		endcase;

	end


	/*
		L'unità di decodifica può estrarre sempre e comunque rs2,rs1,funct3 che sono sempre nelle stesse posizioni. Tramite opcode può
		indirizzare una batteria di multiplexer che decide se:
		- l'istruzione è valida
		- costruisce l'immediato
		- invia in uscita i bit di funct7 per pilotare la CU
		- invia verso la CU informazioni relative alla categoria di operazione

		L'indirizzo della micro-ROM sarà probabilmente costruito a partire da funct3,dai bit ci controllo sulla ategoria di opcode ed eventuali bit extra estratti da funct7.		
	*/

endmodule;
