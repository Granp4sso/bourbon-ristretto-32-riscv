`ifndef EXE_TRAP_PKG
`define EXE_TRAP_PKG

package beta_trap_pkg;

parameter logic[1:0] TCU_NOTRAP 	= 2'b00;
parameter logic[1:0] TCU_INTERRUPT 	= 2'b01;
parameter logic[1:0] TCU_EXCEPTION 	= 2'b10;

parameter logic[1:0] INSTR_NOTRAP		= 2'b00;
parameter logic[1:0] INSTR_MISALIG_FETCH	= 2'b01;
parameter logic[1:0] INSTR_ILLEGAL_FETCH	= 2'b10;

parameter logic[1:0] LSU_NOTRAP			= 2'b00;
parameter logic[1:0] LSU_MISALIG_LOAD 		= 2'b01;
parameter logic[1:0] LSU_MISALIG_STORE		= 2'b10;


typedef enum logic[4:0] {
	MSW_INT 	= 5'h13,
	MTIM_INT	= 5'h17,
	MEXT_INT	= 5'h1b
	  
} interrupt_cause_e;

typedef enum logic[4:0] {
	INSTR_ADDR_MISALIGNED 	= 5'h00,		//Supported
	INSTR_ACCESS_FAULT	= 5'h01,		//Not Supported (PMP missing)
	INSTR_ILLEGAL		= 5'h02,		//Supported
	LOAD_ADDR_MISALIGNED 	= 5'h04,		//Supported
	LOAD_ACCESS_FAULT 	= 5'h05,		//Not Supported (PMP missing)
	STORE_ADDR_MISALIGNED 	= 5'h06,		//Supported
	STORE_ACCESS_FAULT 	= 5'h07,		//Not Supported (PMP missing)
	ENV_CALL_UMODE		= 5'h08,		//Not Supported (xCALL missing)
	ENV_CALL_MMODE		= 5'h0b			//Not Supported (xCALL missing)
	  
} exception_cause_e;


endpackage;

`endif
