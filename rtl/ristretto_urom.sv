`include "pkg/ristretto_dec_stage_pkg.sv"
`include "pkg/ristretto_exe_stage_pkg.sv"

/*
	Micro-ROM v0.9 26/08/2022

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines 
	-AddrWidth :		Width of addresses
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	
	-urom_address_i :		This 9 bits are used to address the urom from the instruction decoder
	-urom_subaddress_i :		5 more bits are used to address specifici SYSTEM instructions
	-urom_invalid_instr_i :		This bit notifies that an invalid instruction has been injected into the core.  
	-urom_control_word_o :		The selected control word will bore all the control signals for the entire core execution for the entire instruction life

	******|| REMARKABLE 	||******
	
	the process into this unit is used to address and produce the control word. For further information check the package describing the control word type.

	******|| NOTES		||******

*/

import ristretto_dec_stage_pkg::*; 
import ristretto_exe_stage_pkg::*; 

module ristretto_urom #(

	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32
)(

	input logic 			clk_i,
	input logic 			rstn_i,
	input logic[8:0] 		urom_address_i,
	input logic[4:0] 		urom_subaddress_i,
	input logic 			urom_invalid_instr_i, 

	output dec_control_word_t 	urom_control_word_o
	
);

	dec_control_word_t cw_int;
	
	assign urom_control_word_o = (urom_invalid_instr_i) ? '0 : cw_int;

	always_comb begin : urom_addressing
	
		cw_int = '0;
		
		case(urom_address_i)

			/*0x000*/ {Major_LOAD,Minor_LB,1'b0} : begin
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_alu_add_en = 1'b1;
									cw_int.exe_reg_wr_en = 1'b1;

									cw_int.exe_mem_op_size = MEM_SIZE_BYTE; 
									cw_int.exe_mem_op = MEM_LOAD_OP;
									cw_int.exe_mem_op_en = 1'b1;
								end
			/*0x002*/ {Major_LOAD,Minor_LH,1'b0} : begin
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_alu_add_en = 1'b1;
									cw_int.exe_reg_wr_en = 1'b1;

									cw_int.exe_mem_op_size = MEM_SIZE_HALF; 
									cw_int.exe_mem_op = MEM_LOAD_OP;
									cw_int.exe_mem_op_en = 1'b1;
								end
			/*0x004*/ {Major_LOAD,Minor_LW,1'b0} : begin
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_alu_add_en = 1'b1;
									cw_int.exe_reg_wr_en = 1'b1;

									cw_int.exe_mem_op_size = MEM_SIZE_WORD; 
									cw_int.exe_mem_op = MEM_LOAD_OP;
									cw_int.exe_mem_op_en = 1'b1;
								end
			/*0x008*/ {Major_LOAD,Minor_LBU,1'b0} : begin
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_alu_add_en = 1'b1;
									cw_int.exe_reg_wr_en = 1'b1;
									cw_int.dec_not_sign_ext = 1'b1;

									cw_int.exe_mem_op_size = MEM_SIZE_BYTE; 
									cw_int.exe_mem_op = MEM_LOAD_OP;
									cw_int.exe_mem_op_en = 1'b1;
								end
			/*0x00a*/ {Major_LOAD,Minor_LHU,1'b0} : begin
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_alu_add_en = 1'b1;
									cw_int.exe_reg_wr_en = 1'b1;
									cw_int.dec_not_sign_ext = 1'b1;

									cw_int.exe_mem_op_size = MEM_SIZE_HALF; 
									cw_int.exe_mem_op = MEM_LOAD_OP;
									cw_int.exe_mem_op_en = 1'b1;
								end

			/*0x040*/ {Major_IMM,Minor_ADDI,1'b0} : begin 
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_alu_add_en = 1'b1;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x042*/ {Major_IMM,Minor_SLLI,1'b0} : begin
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_shu_shift_en = 2'b01;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x044*/ {Major_IMM,Minor_SLTI,1'b0} : begin
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_condition_sel = 2'b01;
									cw_int.exe_condition_neg = 1'b0;
									cw_int.exe_alu_unsigned_n_en = 1'b0;
									cw_int.exe_slt_en = 1'b1;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x046*/ {Major_IMM,Minor_SLTIU,1'b0} : begin
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_condition_sel = 2'b01;
									cw_int.exe_condition_neg = 1'b0;
									cw_int.exe_alu_unsigned_n_en = 1'b1;
									cw_int.exe_slt_en = 1'b1;
									cw_int.exe_reg_wr_en = 1'b1;
									cw_int.dec_not_sign_ext = 1'b1;
								end
			/*0x048*/ {Major_IMM,Minor_XORI,1'b0} : begin
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_alu_logic_en = 2'b11;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x04a*/ {Major_IMM,Minor_SRLI,1'b0} : begin 
									cw_int.src_reg_used = 2'b00;	
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_shu_shift_en = 2'b10;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x04b*/ {Major_IMM,Minor_SRAI,1'b1} : begin 
									cw_int.src_reg_used = 2'b00;	
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_shu_shift_en = 2'b11;
									cw_int.exe_reg_wr_en = 1'b1;
								end
								
			/*0x04c*/ {Major_IMM,Minor_ORI,1'b0} : begin
									cw_int.src_reg_used = 2'b00;	
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_alu_logic_en = 2'b10;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x04e*/ {Major_IMM,Minor_ANDI,1'b0} : begin
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_alu_logic_en = 2'b01;
									cw_int.exe_reg_wr_en = 1'b1;
								end

			/*0x050*/ {Major_AUIPC,3'b000,1'b0} : begin
									cw_int.src_reg_used = 2'b00; 	
									cw_int.dec_src1_select = 2'b01;
									cw_int.dec_src2_select = 2'b11;
									cw_int.exe_shu_shift_en = 2'b00;
									cw_int.exe_add_pc_to_res_en = 1'b1;
									cw_int.exe_reg_wr_en = 1'b1;
								end

			/*0x080*/ {Major_STORE,Minor_SB,1'b0} : begin
									cw_int.src_reg_used = 2'b01; 
									cw_int.dec_src1_select = 2'b00; 
									cw_int.dec_src2_select = 2'b00;
									cw_int.exe_mem_op_size = MEM_SIZE_BYTE; 
									cw_int.exe_mem_op = MEM_STORE_OP;
									cw_int.exe_mem_op_en = 1'b1;
								end
			/*0x082*/ {Major_STORE,Minor_SH,1'b0} : begin
									cw_int.src_reg_used = 2'b01; 
									cw_int.dec_src1_select = 2'b00; 
									cw_int.dec_src2_select = 2'b00;
									cw_int.exe_mem_op_size = MEM_SIZE_HALF; 
									cw_int.exe_mem_op = MEM_STORE_OP;
									cw_int.exe_mem_op_en = 1'b1;
								end
			/*0x084*/ {Major_STORE,Minor_SW,1'b0} : begin
									cw_int.src_reg_used = 2'b01; 
									cw_int.dec_src1_select = 2'b00; 
									cw_int.dec_src2_select = 2'b00;
									cw_int.exe_mem_op_size = MEM_SIZE_WORD; 
									cw_int.exe_mem_op = MEM_STORE_OP;
									cw_int.exe_mem_op_en = 1'b1;
								end

			/*0x0c0*/ {Major_REG,Minor_ADD,1'b0} : begin
									cw_int.src_reg_used = 2'b01;  
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b00;
									cw_int.exe_alu_add_en = 1'b1;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x0c1*/ {Major_REG,Minor_SUB,1'b1} : begin
									cw_int.src_reg_used = 2'b01; 
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b00;
									cw_int.exe_alu_sub_en = 1'b1;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x0c2*/ {Major_REG,Minor_SLL,1'b0} : begin
									cw_int.src_reg_used = 2'b01;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b00;
									cw_int.exe_shu_shift_en = 2'b01;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x0c4*/ {Major_REG,Minor_SLT,1'b0} : begin
									cw_int.src_reg_used = 2'b01;	
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b00;
									cw_int.exe_condition_sel = 2'b01;
									cw_int.exe_condition_neg = 1'b0;
									cw_int.exe_alu_unsigned_n_en = 1'b0;
									cw_int.exe_slt_en = 1'b1;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x0c6*/ {Major_REG,Minor_SLTU,1'b0} : begin
									cw_int.src_reg_used = 2'b01;	
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b00;
									cw_int.exe_condition_sel = 2'b01;
									cw_int.exe_condition_neg = 1'b0;
									cw_int.exe_alu_unsigned_n_en = 1'b1;
									cw_int.exe_slt_en = 1'b1;
									cw_int.exe_reg_wr_en = 1'b1;
									cw_int.dec_not_sign_ext = 1'b1;
								end
			/*0x0c8*/ {Major_REG,Minor_XOR,1'b0} : begin
									cw_int.src_reg_used = 2'b01;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b00;
									cw_int.exe_alu_logic_en = 2'b11;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x0ca*/ {Major_REG,Minor_SRL,1'b0} : begin
									cw_int.src_reg_used = 2'b01;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b00;
									cw_int.exe_shu_shift_en = 2'b10;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x0cb*/ {Major_REG,Minor_SRA,1'b1} : begin
									cw_int.src_reg_used = 2'b01;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b00;
									cw_int.exe_shu_shift_en = 2'b11;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x0cc*/ {Major_REG,Minor_OR,1'b0} : begin
									cw_int.src_reg_used = 2'b01;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b00;
									cw_int.exe_alu_logic_en = 2'b10;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x0ce*/ {Major_REG,Minor_AND,1'b0} : begin
									cw_int.src_reg_used = 2'b01;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b00;
									cw_int.exe_alu_logic_en = 2'b01;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x0d0*/ {Major_LUI,3'b000,1'b0} : begin
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b01;
									cw_int.dec_src2_select = 2'b11;
									cw_int.exe_shu_shift_en = 2'b00;
									cw_int.exe_add_pc_to_res_en = 1'b0;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x180*/ {Major_BRANCH,Minor_BEQ,1'b0} : begin
									cw_int.src_reg_used = 2'b01; 
									cw_int.dec_src1_select = 2'b00; 
									cw_int.dec_src2_select = 2'b00; 
									cw_int.exe_bju_en = 2'b01;
									cw_int.exe_condition_sel = 2'b10; 	//Select Zero Bit
									cw_int.exe_condition_neg = 1'b0; 	//Not complemented
									cw_int.exe_alu_unsigned_n_en = 1'b0; 	//Signed comparison
								  end
			/*0x182*/ {Major_BRANCH,Minor_BNE,1'b0} : begin
									cw_int.src_reg_used = 2'b01; 
									cw_int.dec_src1_select = 2'b00; 
									cw_int.dec_src2_select = 2'b00; 
									cw_int.exe_bju_en = 2'b01;
									cw_int.exe_condition_sel = 2'b10; 	//Select Zero Bit 
									cw_int.exe_condition_neg = 1'b1; 	//Complement Zero bit
									cw_int.exe_alu_unsigned_n_en = 1'b0; 	//Signed comparison
								  end
			/*0x188*/ {Major_BRANCH,Minor_BLT,1'b0} : begin
									cw_int.src_reg_used = 2'b01;
									cw_int.dec_src1_select = 2'b00; 
									cw_int.dec_src2_select = 2'b00; 
									cw_int.exe_bju_en = 2'b01;
									cw_int.exe_condition_sel = 2'b01; 	//Select Negative Bit 
									cw_int.exe_condition_neg = 1'b0; 	//DO not complement Negative bit
									cw_int.exe_alu_unsigned_n_en = 1'b0; 	//Signed comparison
								  end
			/*0x18a*/ {Major_BRANCH,Minor_BGE,1'b0} : begin
									cw_int.dec_src1_select = 2'b00; 
									cw_int.dec_src2_select = 2'b00; 
									cw_int.exe_bju_en = 2'b01;
									cw_int.exe_condition_sel = 2'b01; 	//Select Negative Bit 
									cw_int.exe_condition_neg = 1'b1; 	//complement Negative bit
									cw_int.exe_alu_unsigned_n_en = 1'b0; 	//Signed comparison
								  end
			/*0x18c*/ {Major_BRANCH,Minor_BLTU,1'b0} : begin
									cw_int.src_reg_used = 2'b01;
									cw_int.dec_src1_select = 2'b00; 
									cw_int.dec_src2_select = 2'b00; 
									cw_int.exe_bju_en = 2'b01;
									cw_int.exe_condition_sel = 2'b01; 	//Select Negative Bit 
									cw_int.exe_condition_neg = 1'b0; 	//DO not complement Negative bit
									cw_int.exe_alu_unsigned_n_en = 1'b1; 	//Unsigned comparison
									//Dec not sign is not raised because it works onty for immediates and not registers
								   end
			/*0x18e*/ {Major_BRANCH,Minor_BGEU,1'b0} : begin
									cw_int.src_reg_used = 2'b01;
									cw_int.dec_src1_select = 2'b00; 
									cw_int.dec_src2_select = 2'b00; 
									cw_int.exe_bju_en = 2'b01;
									cw_int.exe_condition_sel = 2'b01; 	//Select Negative Bit 
									cw_int.exe_condition_neg = 1'b1; 	//complement Negative bit
									cw_int.exe_alu_unsigned_n_en = 1'b1; 	//Unsigned comparison
									//Dec not sign is not raised because it works onty for immediates and not registers
								   end

			/*0x190*/ {Major_JALR,3'b000,1'b0} : begin
									cw_int.src_reg_used = 2'b01;
									cw_int.dec_src1_select = 2'b00; 	//Reg selection on src 1. It will be unused
									cw_int.dec_src2_select = 2'b01; 	//Select immediate 12 bits
									cw_int.exe_bju_en = 2'b11;		//enable Jumps + register source
									cw_int.exe_reg_wr_en = 1'b1;
								end

			/*0x1b0*/ {Major_JAL,3'b000,1'b0} : 	begin
									cw_int.src_reg_used = 2'b10;
									cw_int.dec_src1_select = 2'b00; 	//Reg selection on src 1. It will be unused
									cw_int.dec_src2_select = 2'b10; 	//Select immediate 20 bits
									cw_int.exe_bju_en = 2'b10; 		//enable Jump
									cw_int.exe_reg_wr_en = 1'b1;
								end
								
			/*0x1c0*/ {Major_SYSTEM,Minor_PRIV,1'b0} : 	begin
									case( urom_subaddress_i )
									/*0x00*/	Minor_PRIV_ECALL : begin
												cw_int.exe_sys_priv_en = 2'b01;
											end
									/*0x1A*/	Minor_PRIV_MRET : begin
												cw_int.exe_sys_priv_en = 2'b10;
											end
											default: cw_int.exe_sys_priv_en = 2'b00;
									endcase
								  	end
			/*0x1c2*/ {Major_SYSTEM,Minor_CSRRW,1'b0} : begin
									cw_int.exe_csr_en = 1'b1;
									cw_int.exe_csr_op = 3'b111;
									
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x1c4*/ {Major_SYSTEM,Minor_CSRRS,1'b0} : begin
									cw_int.exe_csr_en = 1'b1;
									cw_int.exe_csr_op = 3'b101;
									
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x1c6*/ {Major_SYSTEM,Minor_CSRRC,1'b0} : begin
									cw_int.exe_csr_en = 1'b1;
									cw_int.exe_csr_op = 3'b110;
									
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x1ca*/ {Major_SYSTEM,Minor_CSRRWI,1'b0} : begin
									cw_int.exe_csr_en = 1'b1;
									cw_int.exe_csr_op = 3'b111;
									cw_int.dec_csr_imm = 1'b1;
									
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x1cc*/ {Major_SYSTEM,Minor_CSRRSI,1'b0} : begin
									cw_int.exe_csr_en = 1'b1;
									cw_int.exe_csr_op = 3'b101;
									cw_int.dec_csr_imm = 1'b1;
									
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_reg_wr_en = 1'b1;
								end
			/*0x1ce*/ {Major_SYSTEM,Minor_CSRRCI,1'b0} : begin
									cw_int.exe_csr_en = 1'b1;
									cw_int.exe_csr_op = 3'b110;
									cw_int.dec_csr_imm = 1'b1;
									
									cw_int.src_reg_used = 2'b00;
									cw_int.dec_src1_select = 2'b00;
									cw_int.dec_src2_select = 2'b01;
									cw_int.exe_reg_wr_en = 1'b1;
								end


			default : begin
				cw_int = '0;
			end   
		endcase; 
	end


endmodule;
