`ifndef EXE_STAGE_PKG
`define EXE_STAGE_PKG

`include "pkg/ristretto_csr_pkg.sv"
`include "pkg/ristretto_trap_pkg.sv"

package ristretto_exe_stage_pkg;

import ristretto_csr_pkg::*;
import ristretto_trap_pkg::*;

export *::*;

typedef struct packed {
	//Control signals coming from the decode unit and handled by the execution stage control domain
	
	logic[1:0]	exe_sys_priv_en;			//Enables priv opcodes: 00 -> none, 01 -> ECALL trap, 10 -> return from trap (MRET)
	logic 		exe_reg_wr_en;				//Enables reg write
	
	//CSR related signals
	
	logic 		exe_csr_en;
	logic[2:0] 	exe_csr_op;

	//Ex Stage control signals
	logic 		exe_alu_unsigned_n_en;
	logic 		exe_slt_en;				//determines if an slt instruction has been called
	logic 		exe_alu_add_en;
	logic 		exe_alu_sub_en;
	logic[1:0] 	exe_alu_logic_en; 			//And, Or, Xor

	logic[1:0] 	exe_mem_op_size;			//Memory operation size (Word, Halfword, Byte)
	logic 		exe_mem_op;				//Memory operation (Store or Load)
	logic 		exe_mem_op_en;				//Memory operation requested

	logic[1:0] 	exe_shu_shift_en; 			//Shift left, right and arit.
	
	logic[1:0] 	exe_condition_sel; 			//Select None/Negative/Zero/Overflow bit in the exec stage
	logic 		exe_condition_neg; 			//Select whether the condition value shall be complemented or not
	logic 		exe_add_pc_to_res_en; 			//Add program counter to the ALU result in the execution stage
	logic[1:0] 	exe_bju_en; 				//01: enable branches, 10: enable jump, 11: enable jump and link register
	

} exe_control_word_t;

typedef struct packed {

	//ALU operation signals
	logic exe_alu_unsigned_n_en;
	logic exe_alu_add_en;
	logic exe_alu_sub_en;
	logic[1:0] exe_alu_logic_en; //And, Or, Xor

} exe_alu_op_t;

typedef struct packed {

	logic zero;	//Bit 2
	logic negative;	//Bit 1
	logic overflow; //Bit 0
	
	
} exe_alu_status_t;

typedef struct packed {

	//BJU operation signals
	logic[1:0] exe_bju_condition_sel; 		//Select None/Negative/Zero/Overflow bit in the exec stage
	logic exe_bju_condition_neg; 			//Select whether the condition value shall be complemented or not
	logic[1:0] exe_bju_en;			//01: enable branches, 10: enable jump, 11: enable jump and link register

} exe_bju_op_t;

//SHIFT UNIT MACROS

parameter logic[1:0] SHIFT_NONE =	2'b00;
parameter logic[1:0] SHIFT_LEFT =	2'b01;
parameter logic[1:0] SHIFT_RIGHT =	2'b10;
parameter logic[1:0] SHIFT_ARIGHT =	2'b11;

//LOAD AND STORE UNIT MACROS

parameter logic[1:0] 	MEM_SIZE_WORD = 2'b01;
parameter logic[1:0] 	MEM_SIZE_HALF = 2'b10;
parameter logic[1:0] 	MEM_SIZE_BYTE = 2'b11;

parameter logic		MEM_LOAD_OP = 1'b0;
parameter logic		MEM_STORE_OP = 1'b1;

//Data Memory Protocol State Machine MACROS

parameter integer unsigned wdmem_fsm_bsize = 2;
parameter integer unsigned rdmem_fsm_bsize = 2;

parameter logic[1:0] RDMEM_IDLE = 2'b00;
parameter logic[1:0] RDMEM_WRDY = 2'b01; //Wait for ready signal 
parameter logic[1:0] RDMEM_WVLD = 2'b10; //Wait for valid signal

parameter logic[1:0] WDMEM_IDLE = 2'b00;
parameter logic[1:0] WDMEM_WRDY = 2'b01; //Wait for ready signal 
parameter logic[1:0] WDMEM_WVLD = 2'b10; //Wait for valid signal

//Data Memory Protocol State Machine MACROS



endpackage;

`endif
