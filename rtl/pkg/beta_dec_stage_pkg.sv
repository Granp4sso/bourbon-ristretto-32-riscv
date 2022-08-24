`ifndef DEC_STAGE_PKG
`define DEC_STAGE_PKG

package beta_dec_stage_pkg;

/*

	DECODE STAGE PACKAGE

	This package is the Decode stage top package. If you want to edit, add or simply read names and structures you should refer
	to the following hierarchy.:

	-


*/

typedef struct packed {

	//Global signals
	
	logic[1:0] 	src_reg_used;			//10 - no registers, 00 - only reg1, 01 - reg1 and reg2. It is used by the pipeline control unit
	

	//Dec Stage control signals
	
	logic		dec_csr_imm;
	logic[1:0] 	dec_src1_select; 			//00 -> reg, 01 -> imm20
	logic[1:0] 	dec_src2_select; 			//00 -> reg, 01 -> imm12, 10 -> imm20, 11-> 0x0c for LUI/AUIPC
	logic		dec_not_sign_ext;			//determines if a sign extension is not required (default it is)

	//Ex Stage control signals
	
	logic[1:0]	exe_sys_priv_en;			//Enables priv opcodes: 00 -> none, 01 -> ECALL trap, 10 -> return from trap (MRET)
	logic 		exe_reg_wr_en;				//Enables reg write
	
	//CSR related signals
	
	logic 		exe_csr_en;
	logic[2:0] 	exe_csr_op;

	//ALU related signals
	
	logic		exe_alu_unsigned_n_en;
	logic 		exe_slt_en;				//determines if an slt instruction has been called
	logic 		exe_alu_add_en;
	logic 		exe_alu_sub_en;
	logic[1:0]	exe_alu_logic_en; 			//And, Or, Xor

	//Sequential Exe Signals

	logic[1:0] 	exe_mem_op_size;			//Memory operation size (Word, Halfword, Byte)
	logic 		exe_mem_op;				//Memory operation (Store or Load)
	logic 		exe_mem_op_en;				//Memory operation requested
	logic[1:0] 	exe_shu_shift_en; 			//Shift left, right and arit.
	
	//Jumps and PC related signals
	
	logic[1:0] 	exe_condition_sel; 			//Select None/Negative/Zero/Overflow bit in the exec stage
	logic 		exe_condition_neg; 			//Select whether the condition value shall be complemented or not
	logic 		exe_add_pc_to_res_en; 			//Add program counter to the ALU result in the execution stage
	logic[1:0] 	exe_bju_en; 				//01: enable branches, 10: enable jump, 11: enable jump and link register


} dec_control_word_t;

/*Enumeration for Opcode decoding. Opcodes partiallu specifies operation*/

typedef enum logic[6:0] {
	OPCODE_IMM =		7'h13,
	OPCODE_LUI =		7'h37, 
	OPCODE_AUIPC =		7'h17, 
	OPCODE_REG =		7'h33,
	OPCODE_JAL =		7'h6f, 
	OPCODE_JALR =		7'h67, 
	OPCODE_BRANCH =		7'h63,
	OPCODE_LOAD =		7'h03,
	OPCODE_STORE =		7'h23,
	OPCODE_MISC_MEM =	7'hf4, //Not complete
	OPCODE_SYSTEM = 	7'h73  //EBREAK,ECALL, CSR
	  
} opcode_e;


/*For certain type of Instructions, funct3 and funct3 are combined along with opcode in order to
  specify the complete operation.
*/

//Major OPCodes

parameter logic[4:0] Major_IMM = 	5'h04;
parameter logic[4:0] Major_LUI = 	5'h0d;
parameter logic[4:0] Major_AUIPC = 	5'h05; 
parameter logic[4:0] Major_REG = 	5'h0c; 
parameter logic[4:0] Major_JAL = 	5'h1b; 
parameter logic[4:0] Major_JALR = 	5'h19; 
parameter logic[4:0] Major_BRANCH = 	5'h18; 
parameter logic[4:0] Major_LOAD = 	5'h00; 
parameter logic[4:0] Major_STORE = 	5'h08; 
parameter logic[4:0] Major_SYSTEM =	5'h1c; 


/*R type funct (3)*/

parameter logic[2:0] Minor_ADD = 	3'b000;
parameter logic[2:0] Minor_SUB = 	3'b000;
parameter logic[2:0] Minor_SLL = 	3'b001;
parameter logic[2:0] Minor_SLT = 	3'b010;
parameter logic[2:0] Minor_SLTU = 	3'b011;
parameter logic[2:0] Minor_XOR = 	3'b100;
parameter logic[2:0] Minor_SRL = 	3'b101;
parameter logic[2:0] Minor_SRA = 	3'b101;
parameter logic[2:0] Minor_OR = 	3'b110;
parameter logic[2:0] Minor_AND = 	3'b111;

/*I type funct (3)*/

parameter logic[2:0] Minor_ADDI = 	3'b000;
parameter logic[2:0] Minor_SLTI =	3'b010;
parameter logic[2:0] Minor_SLTIU =	3'b011;
parameter logic[2:0] Minor_XORI =	3'b100;
parameter logic[2:0] Minor_ORI =	3'b110;
parameter logic[2:0] Minor_ANDI =	3'b111;
parameter logic[2:0] Minor_SLLI =	3'b001;
parameter logic[2:0] Minor_SRLI =	3'b101;
parameter logic[2:0] Minor_SRAI =	3'b101;

/*Load type funct (3)*/

parameter logic[2:0] Minor_LB =		3'b000;
parameter logic[2:0] Minor_LH =		3'b001;
parameter logic[2:0] Minor_LW =		3'b010;
parameter logic[2:0] Minor_LBU =	3'b100;
parameter logic[2:0] Minor_LHU =	3'b101;

/*Store type funct (3)*/

parameter logic[2:0] Minor_SB =		3'b000;
parameter logic[2:0] Minor_SH =		3'b001;
parameter logic[2:0] Minor_SW =		3'b010;

/*Branch type funct (3)*/

parameter logic[2:0] Minor_BEQ =	3'b000;
parameter logic[2:0] Minor_BNE =	3'b001;
parameter logic[2:0] Minor_BLT =	3'b100;
parameter logic[2:0] Minor_BGE =	3'b101;
parameter logic[2:0] Minor_BLTU =	3'b110;
parameter logic[2:0] Minor_BGEU =	3'b111;

/*System type funct (3)*/

parameter logic[2:0] Minor_PRIV =	3'b000;
parameter logic[2:0] Minor_CSRRW =	3'b001;
parameter logic[2:0] Minor_CSRRS =	3'b010;
parameter logic[2:0] Minor_CSRRC =	3'b011;
parameter logic[2:0] Minor_CSRRWI =	3'b101;
parameter logic[2:0] Minor_CSRRSI =	3'b110;
parameter logic[2:0] Minor_CSRRCI =	3'b111;

/*PRIV Subcodes: Immediate[29:28],Immediate[22:20]*/

parameter logic[4:0] Minor_PRIV_ECALL =		5'b00000;	//0x00
parameter logic[4:0] Minor_PRIV_EBREAK =	5'b00001;	//0x01
parameter logic[4:0] Minor_PRIV_URET =		5'b00010;	//0x02
parameter logic[4:0] Minor_PRIV_SRET =		5'b01010;	//0x0A
parameter logic[4:0] Minor_PRIV_MRET =		5'b11010;	//0x1A
parameter logic[4:0] Minor_PRIV_WFI =		5'b01101;	//0x0D

endpackage;

`endif



