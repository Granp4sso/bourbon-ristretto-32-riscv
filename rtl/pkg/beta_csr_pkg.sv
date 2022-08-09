`ifndef DEC_CSR_PKG
`define DEC_CSR_PKG

package beta_csr_pkg;

parameter logic[1:0] CSR_RW_00 = 2'b00;
parameter logic[1:0] CSR_RW_01 = 2'b01;
parameter logic[1:0] CSR_RW_10 = 2'b10;
parameter logic[1:0] CSR_RO = 2'b11;

parameter logic[1:0] CSR_U = 2'b00;
parameter logic[1:0] CSR_S = 2'b01;
parameter logic[1:0] CSR_H = 2'b10;
parameter logic[1:0] CSR_M = 2'b11;

/* CSR operations */

parameter logic[1:0] CSR_OP_W = 2'b11;	
parameter logic[1:0] CSR_OP_R = 2'b10; 
parameter logic[1:0] CSR_OP_S = 2'b01; 

parameter integer unsigned CSR_OP_R_BIT = 2;

/* CSRs Width */

parameter integer unsigned MSTATUS_WIDTH = 6;
parameter integer unsigned MSTATUSH_WIDTH = 1;
parameter integer unsigned MIE_WIDTH = 3;
parameter integer unsigned MIP_WIDTH = 3;

/* misa extensions bits */

parameter logic[31:0] ARCH_EXT_A = 32'b00000000000000000000000000000001;
parameter logic[31:0] ARCH_EXT_B = 32'b00000000000000000000000000000010;
parameter logic[31:0] ARCH_EXT_C = 32'b00000000000000000000000000000100;
parameter logic[31:0] ARCH_EXT_D = 32'b00000000000000000000000000001000;
parameter logic[31:0] ARCH_EXT_E = 32'b00000000000000000000000000010000;
parameter logic[31:0] ARCH_EXT_F = 32'b00000000000000000000000000100000;
parameter logic[31:0] ARCH_EXT_G = 32'b00000000000000000000000001000000;
parameter logic[31:0] ARCH_EXT_H = 32'b00000000000000000000000010000000;
parameter logic[31:0] ARCH_EXT_I = 32'b00000000000000000000000100000000;
parameter logic[31:0] ARCH_EXT_J = 32'b00000000000000000000001000000000;
parameter logic[31:0] ARCH_EXT_K = 32'b00000000000000000000010000000000;
parameter logic[31:0] ARCH_EXT_L = 32'b00000000000000000000100000000000;
parameter logic[31:0] ARCH_EXT_M = 32'b00000000000000000001000000000000;
parameter logic[31:0] ARCH_EXT_N = 32'b00000000000000000010000000000000;
parameter logic[31:0] ARCH_EXT_O = 32'b00000000000000000100000000000000;
parameter logic[31:0] ARCH_EXT_P = 32'b00000000000000001000000000000000;
parameter logic[31:0] ARCH_EXT_Q = 32'b00000000000000010000000000000000;
parameter logic[31:0] ARCH_EXT_R = 32'b00000000000000100000000000000000;
parameter logic[31:0] ARCH_EXT_S = 32'b00000000000001000000000000000000;
parameter logic[31:0] ARCH_EXT_T = 32'b00000000000010000000000000000000;
parameter logic[31:0] ARCH_EXT_U = 32'b00000000000100000000000000000000;
parameter logic[31:0] ARCH_EXT_V = 32'b00000000001000000000000000000000;
parameter logic[31:0] ARCH_EXT_W = 32'b00000000010000000000000000000000;
parameter logic[31:0] ARCH_EXT_X = 32'b00000000100000000000000000000000;
parameter logic[31:0] ARCH_EXT_Y = 32'b00000001000000000000000000000000;
parameter logic[31:0] ARCH_EXT_Z = 32'b00000010000000000000000000000000;

/* mstatus register bits */

parameter integer unsigned MSTATUS_MIE_BIT = 	 0;		//Required
parameter integer unsigned MSTATUS_UBE_BIT = 	 1;
parameter integer unsigned MSTATUS_MPIE_BIT = 	 2;		//Required
parameter integer unsigned MSTATUS_MPP_BIT = 	 3;		//Required
parameter integer unsigned MSTATUS_MPRV_BIT = 	 4;		//Required
parameter integer unsigned MSTATUS_TW_BIT = 	 5;		//Maybe Required

parameter integer unsigned MSTATUSH_MBE_BIT = 	 1;		//Required

/* mie/mip register bits */

parameter integer unsigned MIE_MSI_BIT = 	 0;
parameter integer unsigned MIE_MTI_BIT = 	 1;
parameter integer unsigned MIE_MEI_BIT = 	 2;

/* mtvec mode and base address */

parameter logic[31:0] MTVEC_MODE_D = 32'h00000000;
parameter logic[31:0] MTVEC_MODE_V = 32'h00000001;
parameter logic[31:0] MTVEC_BASE =   32'h00000000;		//Still to be decided


typedef struct packed {

	logic [31:0] mtval;		//MTVAL register must be carried outside
	logic [31:0] mcause;		//MCAUSE register must be carried outside
	logic [31:0] mepc;		//MEPC register must be carried outside
	logic [1:0]  soft_int;		//Bit 0 is for mie.MSIE, bit 1 is for mie.MSIP
	logic [1:0]  tim_int;		//Bit 0 is for mie.MTIE, bit 1 is for mie.MTIP
	logic [1:0]  ext_int;		//Bit 0 is for mie.MEIE, bit 1 is for mie.MEIP
	logic [31:0] mtvec;		//Signal driving the trap base address and addressing mode (vectored or direct)
	logic user_endianess;		//It encodes the mstatus UBE bit. (0 little-endian and 1 Big-endian) for the LSU. 
	logic machine_endianess;	//It encodes the mstatus MBE bit. (0 little-endian and 1 Big-endian) for the LSU.
	logic previous_privilege;	//It encodes the mstatus MPP bit.
	logic modify_privilege;		//It encodes the mstatus MPRV bit. If it is 0 Load/Stores are executed as normal, otherwise as MPP
	logic global_interrupt_enable;	//It encodes the MIE and SIE bits. SIE is not supported, so the signal is 1 bit wide.

} csr_ctrl_t;


/* User defined CSRs */
	
parameter logic[11:0] FFLAGS = 		12'h001;										//Not Supported
parameter logic[11:0] FRM = 		12'h002;										//Not Supported
parameter logic[11:0] FCSR = 		12'h003;										//Not Supported
parameter logic[11:0] CYCLE =		12'hc00;										//Not Supported
parameter logic[11:0] TIME =		12'hc01;										//Not Supported
parameter logic[11:0] INSTRET =		12'hc02;										//Not Supported

parameter logic[11:0] HPMCOUNTER3  = 	12'hc03; parameter logic[11:0] HPMCOUNTER4  = 12'hc04; parameter logic[11:0] HPMCOUNTER5  = 12'hc05; parameter logic[11:0] HPMCOUNTER6  = 12'hc06;	//Not Supported
parameter logic[11:0] HPMCOUNTER7  = 	12'hc07; parameter logic[11:0] HPMCOUNTER8  = 12'hc08; parameter logic[11:0] HPMCOUNTER9  = 12'hc09; parameter logic[11:0] HPMCOUNTER10 = 12'hc0a;	//Not Supported
parameter logic[11:0] HPMCOUNTER11 = 	12'hc0b; parameter logic[11:0] HPMCOUNTER12 = 12'hc0c; parameter logic[11:0] HPMCOUNTER13 = 12'hc0d; parameter logic[11:0] HPMCOUNTER14 = 12'hc0e;	//Not Supported
parameter logic[11:0] HPMCOUNTER15 = 	12'hc0f; parameter logic[11:0] HPMCOUNTER16 = 12'hc10; parameter logic[11:0] HPMCOUNTER17 = 12'hc11; parameter logic[11:0] HPMCOUNTER18 = 12'hc12;	//Not Supported
parameter logic[11:0] HPMCOUNTER19 = 	12'hc13; parameter logic[11:0] HPMCOUNTER20 = 12'hc14; parameter logic[11:0] HPMCOUNTER21 = 12'hc15; parameter logic[11:0] HPMCOUNTER22 = 12'hc16;	//Not Supported
parameter logic[11:0] HPMCOUNTER23 = 	12'hc17; parameter logic[11:0] HPMCOUNTER24 = 12'hc18; parameter logic[11:0] HPMCOUNTER25 = 12'hc19; parameter logic[11:0] HPMCOUNTER26 = 12'hc1a;	//Not Supported
parameter logic[11:0] HPMCOUNTER27 = 	12'hc1b; parameter logic[11:0] HPMCOUNTER28 = 12'hc1c; parameter logic[11:0] HPMCOUNTER29 = 12'hc1d; parameter logic[11:0] HPMCOUNTER30 = 12'hc1e;	//Not Supported
parameter logic[11:0] HPMCOUNTER31 = 	12'hc1f;																		//Not Supported
parameter logic[11:0] CYCLEH =		12'hc80;										//Not Supported
parameter logic[11:0] TIMEH =		12'hc81;										//Not Supported
parameter logic[11:0] INSTRETH =	12'hc82;										//Not Supported

parameter logic[11:0] HPMCOUNTER3H  =	12'hc83; parameter logic[11:0] HPMCOUNTER4H  = 12'hc84; parameter logic[11:0] HPMCOUNTER5H  = 12'hc85; parameter logic[11:0] HPMCOUNTER6H  = 12'hc86;	//Not Supported
parameter logic[11:0] HPMCOUNTER7H  =	12'hc87; parameter logic[11:0] HPMCOUNTER8H  = 12'hc88; parameter logic[11:0] HPMCOUNTER9H  = 12'hc89; parameter logic[11:0] HPMCOUNTER10H = 12'hc8a;	//Not Supported
parameter logic[11:0] HPMCOUNTER11H =	12'hc8b; parameter logic[11:0] HPMCOUNTER12H = 12'hc8c; parameter logic[11:0] HPMCOUNTER13H = 12'hc8d; parameter logic[11:0] HPMCOUNTER14H = 12'hc8e;	//Not Supported
parameter logic[11:0] HPMCOUNTER15H =	12'hc8f; parameter logic[11:0] HPMCOUNTER16H = 12'hc90; parameter logic[11:0] HPMCOUNTER17H = 12'hc91; parameter logic[11:0] HPMCOUNTER18H = 12'hc92;	//Not Supported
parameter logic[11:0] HPMCOUNTER19H =	12'hc93; parameter logic[11:0] HPMCOUNTER20H = 12'hc94; parameter logic[11:0] HPMCOUNTER21H = 12'hc95; parameter logic[11:0] HPMCOUNTER22H = 12'hc96;	//Not Supported
parameter logic[11:0] HPMCOUNTER23H =	12'hc97; parameter logic[11:0] HPMCOUNTER24H = 12'hc98; parameter logic[11:0] HPMCOUNTER25H = 12'hc99; parameter logic[11:0] HPMCOUNTER26H = 12'hc9a;	//Not Supported
parameter logic[11:0] HPMCOUNTER27H =	12'hc9b; parameter logic[11:0] HPMCOUNTER28H = 12'hc9c; parameter logic[11:0] HPMCOUNTER29H = 12'hc9d; parameter logic[11:0] HPMCOUNTER30H = 12'hc9e;	//Not Supported
parameter logic[11:0] HPMCOUNTER31H =	12'hc9f;																		//Not Supported
	
/* Machine Defined CSRs */
	
/* Machine Information Registers */
	
parameter logic[11:0] MVENDORID =	12'hf11;										//Supported
parameter logic[11:0] MARCHID =		12'hf12;										//Supported
parameter logic[11:0] MIMPID =		12'hf13;										//Supported
parameter logic[11:0] MHARTID =		12'hf14;										//Supported
parameter logic[11:0] MCONFIGPTR =	12'hf15;										//Supported
	
/* Machine Trap Setup */
	
parameter logic[11:0] MSTATUS =		12'h300;										//Partially Supported
parameter logic[11:0] MISA =		12'h301;										//Partially Supported
parameter logic[11:0] MEDELEG =		12'h302;										//Not Required
parameter logic[11:0] MIDELEG =		12'h303;										//Not Required
parameter logic[11:0] MIE	 =	12'h304;										//Partially Supported
parameter logic[11:0] MTVEC	 =	12'h305;										//Partially Supported
parameter logic[11:0] MCOUNTEREN =	12'h306;										//Not Supported
parameter logic[11:0] MSTATUSH =	12'h310;										//Partially Supported
	
/* Machine Trap Handling */
	
parameter logic[11:0] MSCRATCH =	12'h340;										//Not Supported
parameter logic[11:0] MEPC	 =	12'h341;										//Partially Supported
parameter logic[11:0] MCAUSE	 =	12'h342;										//Partially Supported
parameter logic[11:0] MTVAL	 =	12'h343;										//Partially Supported
parameter logic[11:0] MIP	 =	12'h344;										//Partially Supported
parameter logic[11:0] MTINST	 =	12'h34a;										//Not Supported
parameter logic[11:0] MTVAL2 	 =	12'h34b;										//Not Supported
	
/* Machine Configuration */
	
parameter logic[11:0] MENVCFG  =	12'h30a;										//Not Supported
parameter logic[11:0] MENVCFGH =	12'h31a;										//Not Supported
parameter logic[11:0] MSECCFG	 =	12'h747;										//Not Supported
parameter logic[11:0] MSECCFGH =	12'h757;										//Not Supported
	
/* Machine Memory Protection */
	
parameter logic[11:0] PMPCFG0   = 12'h3a0; parameter logic[11:0] PMPCFG1   = 12'h3a1; parameter logic[11:0] PMPCFG2   = 12'h3a2; parameter logic[11:0] PMPCFG3   = 12'h3a3;	//Not Supported
parameter logic[11:0] PMPCFG4   = 12'h3a4; parameter logic[11:0] PMPCFG5   = 12'h3a5; parameter logic[11:0] PMPCFG6   = 12'h3a6; parameter logic[11:0] PMPCFG7   = 12'h3a7;	//Not Supported
parameter logic[11:0] PMPCFG8   = 12'h3a8; parameter logic[11:0] PMPCFG9   = 12'h3a9; parameter logic[11:0] PMPCFG10  = 12'h3aa; parameter logic[11:0] PMPCFG11  = 12'h3ab;	//Not Supported
parameter logic[11:0] PMPCFG12  = 12'h3ac; parameter logic[11:0] PMPCFG13  = 12'h3ad; parameter logic[11:0] PMPCFG14  = 12'h3ae; parameter logic[11:0] PMPCFG15  = 12'h3af;	//Not Supported
	
parameter logic[11:0] PMPADDR0  = 12'h3b0; parameter logic[11:0] PMPADDR1  = 12'h3b1; parameter logic[11:0] PMPADDR2  = 12'h3b2; parameter logic[11:0] PMPADDR3  = 12'h3b3;	//Not Supported
parameter logic[11:0] PMPADDR4  = 12'h3b4; parameter logic[11:0] PMPADDR5  = 12'h3b5; parameter logic[11:0] PMPADDR6  = 12'h3b6; parameter logic[11:0] PMPADDR7  = 12'h3b7;	//Not Supported
parameter logic[11:0] PMPADDR8  = 12'h3b8; parameter logic[11:0] PMPADDR9  = 12'h3b9; parameter logic[11:0] PMPADDR10 = 12'h3ba; parameter logic[11:0] PMPADDR11 = 12'h3bb;	//Not Supported
parameter logic[11:0] PMPADDR12 = 12'h3bc; parameter logic[11:0] PMPADDR13 = 12'h3bd; parameter logic[11:0] PMPADDR14 = 12'h3be; parameter logic[11:0] PMPADDR15 = 12'h3bf;	//Not Supported
parameter logic[11:0] PMPADDR16 = 12'h3c0; parameter logic[11:0] PMPADDR17 = 12'h3c1; parameter logic[11:0] PMPADDR18 = 12'h3c2; parameter logic[11:0] PMPADDR19 = 12'h3c3;	//Not Supported
parameter logic[11:0] PMPADDR20 = 12'h3c4; parameter logic[11:0] PMPADDR21 = 12'h3c5; parameter logic[11:0] PMPADDR22 = 12'h3c6; parameter logic[11:0] PMPADDR23 = 12'h3c7;	//Not Supported
parameter logic[11:0] PMPADDR24 = 12'h3c8; parameter logic[11:0] PMPADDR25 = 12'h3c9; parameter logic[11:0] PMPADDR26 = 12'h3ca; parameter logic[11:0] PMPADDR27 = 12'h3cb;	//Not Supported
parameter logic[11:0] PMPADDR28 = 12'h3cc; parameter logic[11:0] PMPADDR29 = 12'h3cd; parameter logic[11:0] PMPADDR30 = 12'h3ce; parameter logic[11:0] PMPADDR31 = 12'h3cf;	//Not Supported
parameter logic[11:0] PMPADDR32 = 12'h3d0; parameter logic[11:0] PMPADDR33 = 12'h3d1; parameter logic[11:0] PMPADDR34 = 12'h3d2; parameter logic[11:0] PMPADDR35 = 12'h3d3;	//Not Supported
parameter logic[11:0] PMPADDR36 = 12'h3d4; parameter logic[11:0] PMPADDR37 = 12'h3d5; parameter logic[11:0] PMPADDR38 = 12'h3d6; parameter logic[11:0] PMPADDR39 = 12'h3d7;	//Not Supported
parameter logic[11:0] PMPADDR40 = 12'h3d8; parameter logic[11:0] PMPADDR41 = 12'h3d9; parameter logic[11:0] PMPADDR42 = 12'h3da; parameter logic[11:0] PMPADDR43 = 12'h3db;	//Not Supported
parameter logic[11:0] PMPADDR44 = 12'h3dc; parameter logic[11:0] PMPADDR45 = 12'h3dd; parameter logic[11:0] PMPADDR46 = 12'h3de; parameter logic[11:0] PMPADDR47 = 12'h3df;	//Not Supported
parameter logic[11:0] PMPADDR48 = 12'h3e0; parameter logic[11:0] PMPADDR49 = 12'h3e1; parameter logic[11:0] PMPADDR50 = 12'h3e2; parameter logic[11:0] PMPADDR51 = 12'h3e3;	//Not Supported
parameter logic[11:0] PMPADDR52 = 12'h3e4; parameter logic[11:0] PMPADDR53 = 12'h3e5; parameter logic[11:0] PMPADDR54 = 12'h3e6; parameter logic[11:0] PMPADDR55 = 12'h3e7;	//Not Supported
parameter logic[11:0] PMPADDR56 = 12'h3e8; parameter logic[11:0] PMPADDR57 = 12'h3e9; parameter logic[11:0] PMPADDR58 = 12'h3ea; parameter logic[11:0] PMPADDR59 = 12'h3eb;	//Not Supported
parameter logic[11:0] PMPADDR60 = 12'h3ec; parameter logic[11:0] PMPADDR61 = 12'h3ed; parameter logic[11:0] PMPADDR62 = 12'h3ee; parameter logic[11:0] PMPADDR63 = 12'h3ef;	//Not Supported
	
/* Machine Counter/Timers */
	
parameter logic[11:0] MCYCLE =	 12'hb00;											//Not Supported
parameter logic[11:0] MINSTRET = 12'hb02;											//Not Supported
parameter logic[11:0] MHPMCOUNTER3  =  12'hb03; parameter logic[11:0] MHPMCOUNTER4  = 12'hb04; parameter logic[11:0] MHPMCOUNTER5  = 12'hb05; parameter logic[11:0] MHPMCOUNTER6  = 12'hb06;	//Not Supported
parameter logic[11:0] MHPMCOUNTER7  =  12'hb07; parameter logic[11:0] MHPMCOUNTER8  = 12'hb08; parameter logic[11:0] MHPMCOUNTER9  = 12'hb09; parameter logic[11:0] MHPMCOUNTER10 = 12'hb0a;	//Not Supported
parameter logic[11:0] MHPMCOUNTER11 =  12'hb0b; parameter logic[11:0] MHPMCOUNTER12 = 12'hb0c; parameter logic[11:0] MHPMCOUNTER13 = 12'hb0d; parameter logic[11:0] MHPMCOUNTER14 = 12'hb0e;	//Not Supported
parameter logic[11:0] MHPMCOUNTER15 =  12'hb0f; parameter logic[11:0] MHPMCOUNTER16 = 12'hb10; parameter logic[11:0] MHPMCOUNTER17 = 12'hb11; parameter logic[11:0] MHPMCOUNTER18 = 12'hb12;	//Not Supported
parameter logic[11:0] MHPMCOUNTER19 =  12'hb13; parameter logic[11:0] MHPMCOUNTER20 = 12'hb14; parameter logic[11:0] MHPMCOUNTER21 = 12'hb15; parameter logic[11:0] MHPMCOUNTER22 = 12'hb16;	//Not Supported
parameter logic[11:0] MHPMCOUNTER23 =  12'hb17; parameter logic[11:0] MHPMCOUNTER24 = 12'hb18; parameter logic[11:0] MHPMCOUNTER25 = 12'hb19; parameter logic[11:0] MHPMCOUNTER26 = 12'hb1a;	//Not Supported
parameter logic[11:0] MHPMCOUNTER27 =  12'hb1b; parameter logic[11:0] MHPMCOUNTER28 = 12'hb1c; parameter logic[11:0] MHPMCOUNTER29 = 12'hb1d; parameter logic[11:0] MHPMCOUNTER30 = 12'hb1e;	//Not Supported
parameter logic[11:0] MHPMCOUNTER31 =  12'hb1f;																			//Not Supported
parameter logic[11:0] MCYCLEH =	  12'hb80;											//Not Supported
parameter logic[11:0] MINSTRETH = 12'hb82;											//Not Supported
parameter logic[11:0] MHPMCOUNTER3H  = 12'hb83; parameter logic[11:0] MHPMCOUNTER4H  = 12'hb84; parameter logic[11:0] MHPMCOUNTER5H  = 12'hb85; parameter logic[11:0] MHPMCOUNTER6H  = 12'hb86;	//Not Supported
parameter logic[11:0] MHPMCOUNTER7H  = 12'hb87; parameter logic[11:0] MHPMCOUNTER8H  = 12'hb88; parameter logic[11:0] MHPMCOUNTER9H  = 12'hb89; parameter logic[11:0] MHPMCOUNTER10H = 12'hb8a;	//Not Supported
parameter logic[11:0] MHPMCOUNTER11H = 12'hb8b; parameter logic[11:0] MHPMCOUNTER12H = 12'hb8c; parameter logic[11:0] MHPMCOUNTER13H = 12'hb8d; parameter logic[11:0] MHPMCOUNTER14H = 12'hb8e;	//Not Supported
parameter logic[11:0] MHPMCOUNTER15H = 12'hb8f; parameter logic[11:0] MHPMCOUNTER16H = 12'hb90; parameter logic[11:0] MHPMCOUNTER17H = 12'hb91; parameter logic[11:0] MHPMCOUNTER18H = 12'hb92;	//Not Supported
parameter logic[11:0] MHPMCOUNTER19H = 12'hb93; parameter logic[11:0] MHPMCOUNTER20H = 12'hb94; parameter logic[11:0] MHPMCOUNTER21H = 12'hb95; parameter logic[11:0] MHPMCOUNTER22H = 12'hb96;	//Not Supported
parameter logic[11:0] MHPMCOUNTER23H = 12'hb97; parameter logic[11:0] MHPMCOUNTER24H = 12'hb98; parameter logic[11:0] MHPMCOUNTER25H = 12'hb99; parameter logic[11:0] MHPMCOUNTER26H = 12'hb9a;	//Not Supported
parameter logic[11:0] MHPMCOUNTER27H = 12'hb9b; parameter logic[11:0] MHPMCOUNTER28H = 12'hb9c; parameter logic[11:0] MHPMCOUNTER29H = 12'hb9d; parameter logic[11:0] MHPMCOUNTER30H = 12'hb9e;	//Not Supported
parameter logic[11:0] MHPMCOUNTER31H = 12'hb9f;																			//Not Supported
	
/* Machine Counter Setup */
	
parameter logic[11:0] MCOUNTINHIBIT = 12'h320;
parameter logic[11:0] MHPMEVENT3 = 12'h323;  parameter logic[11:0]  MHPMEVENT4 = 12'h324;  parameter logic[11:0]  MHPMEVENT5 = 12'h325; parameter logic[11:0]  MHPMEVENT6 = 12'h326;	//Not Supported
parameter logic[11:0] MHPMEVENT7 = 12'h327;  parameter logic[11:0]  MHPMEVENT8  = 12'h328; parameter logic[11:0] MHPMEVENT9  = 12'h329; parameter logic[11:0] MHPMEVENT10 = 12'h32a;	//Not Supported
parameter logic[11:0] MHPMEVENT11 = 12'h32b; parameter logic[11:0]  MHPMEVENT12 = 12'h32c; parameter logic[11:0] MHPMEVENT13 = 12'h32d; parameter logic[11:0] MHPMEVENT14 = 12'h32e;  	//Not Supported
parameter logic[11:0] MHPMEVENT15 = 12'h32f; parameter logic[11:0]  MHPMEVENT16 = 12'h330; parameter logic[11:0] MHPMEVENT17 = 12'h331; parameter logic[11:0] MHPMEVENT18 = 12'h332;  	//Not Supported
parameter logic[11:0] MHPMEVENT19 = 12'h333; parameter logic[11:0]  MHPMEVENT20 = 12'h334; parameter logic[11:0] MHPMEVENT21 = 12'h335; parameter logic[11:0] MHPMEVENT22 = 12'h336;  	//Not Supported
parameter logic[11:0] MHPMEVENT23 = 12'h337; parameter logic[11:0]  MHPMEVENT24 = 12'h338; parameter logic[11:0] MHPMEVENT25 = 12'h333; parameter logic[11:0] MHPMEVENT26 = 12'h333;  	//Not Supported
parameter logic[11:0] MHPMEVENT27 = 12'h33b; parameter logic[11:0]  MHPMEVENT28 = 12'h33c; parameter logic[11:0] MHPMEVENT29 = 12'h33d; parameter logic[11:0] MHPMEVENT30 = 12'h33e;  	//Not Supported
parameter logic[11:0] MHPMEVENT31 = 12'h33f;																		//Not Supported
	
/* Debug/Trace Registers (shared with Debug Mode) */
	
parameter logic[11:0] TSELECT 	= 12'h7a0;											//Not Supported
parameter logic[11:0] TDATA1	= 12'h7a1;											//Not Supported
parameter logic[11:0] TDATA2	= 12'h7a2;											//Not Supported
parameter logic[11:0] TDATA3	= 12'h7a3;											//Not Supported
parameter logic[11:0] MCONTEXT	= 12'h7a8;											//Not Supported
	
/* Debug Mode Registers */
	
parameter logic[11:0] DCSR 	= 12'h7b0;											//Not Supported
parameter logic[11:0] DPC	= 12'h7b1;											//Not Supported
parameter logic[11:0] DSCARTCH0	= 12'h7b2;											//Not Supported
parameter logic[11:0] DSCARTCH1	= 12'h7b3;											//Not Supported


endpackage;

`endif
