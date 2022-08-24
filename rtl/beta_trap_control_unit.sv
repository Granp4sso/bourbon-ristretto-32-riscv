`include "pkg/beta_csr_pkg.sv"
`include "pkg/beta_trap_pkg.sv"

/*
	15/08/2022, v 0.1
	
	Thre TCU is designed to catch all interrupts and exceptions coming from the datapath. It must output the interrupt signal to the execution control unit.
	NMI still not handled.
	Who has higher priority, Exceptions or interrupts?
*/


module beta_trap_control_unit import beta_csr_pkg::*;import beta_trap_pkg::*; #(
		
		parameter unsigned DataWidth = 32
	
	)(
	
		input logic 			clk_i,
		input logic			rstn_i,
		
		input logic			priv_lvl_i,
		input [DataWidth-1:0]		tcu_next_pc_i,
		input [DataWidth-1:0]		tcu_fault_instr_i,		//Instruction that generated the exception
		input [DataWidth-1:0]		tcu_fault_addr_i,		//Misaligned Address for Load/Store
		
		/* CSR interface */
		
		input csr_ctrl_t		tcu_csr_control_i,
		
		output logic [DataWidth-1:0] 	tcu_mtval_o,
		output logic [DataWidth-1:0] 	tcu_mcause_o,
		output logic [DataWidth-1:0] 	tcu_mepc_o,
		output logic			tcu_sw_int_pend_o,
		output logic  			tcu_tim_int_pend_o,			
		output logic   			tcu_ext_int_pend_o,
		output logic [2:0]		tcu_trap_state_o,	//MIE,MPIE,MPP

		output logic			tcu_csr_we_o,
		
		/* Interrupt & Exception signals */
		
		input logic 			tcu_sw_intr_i,
		input logic			tcu_tim_intr_i,
		input logic			tcu_ext_intr_i,
		input logic [1:0]		tcu_instr_exception_i,
		input logic [1:0]		tcu_lsu_exception_i,
		input logic [1:0]		tcu_sync_exception_i,
		input logic [1:0]		tcu_instr_penality_i,
		
		// Enviromental call exception signal placeholder
		// PMP exception signals placeholder
		
		output logic [DataWidth-1:0]	tcu_trap_address_o,
		output logic [1:0]		tcu_trap_detected_o,
		output logic			tcu_halt_o

		
	);

	logic [1:0]		tcu_trap_detected_int;	
	logic [DataWidth-1:0]	tcu_trap_address_int;
	logic [DataWidth-1:0] 	tcu_mtval_int;
	logic [4:0] 		tcu_mcause_int;
	logic [DataWidth-1:0] 	tcu_mepc_int;
	logic			tcu_sw_int_pend_int;
	logic  			tcu_tim_int_pend_int;			
	logic   		tcu_ext_int_pend_int;
	logic [2:0]		tcu_trap_state_int;
	logic			tcu_csr_we_int;
	logic			tcu_halt_int = 1'b0;

	
	always_comb begin: trap_detector	//Get the Trap, the Cause and the Val
	
		tcu_mcause_int = '0;
		tcu_mtval_int = '0;
	
		//Exception case: 
			
		if( tcu_instr_exception_i[1] ) begin tcu_mcause_int = INSTR_ILLEGAL; tcu_trap_detected_int[1] = 1'b1; tcu_mtval_int= tcu_fault_instr_i; end
		else if( tcu_instr_exception_i[0] ) begin tcu_mcause_int = INSTR_ADDR_MISALIGNED; tcu_trap_detected_int[1] = 1'b1; tcu_mtval_int= tcu_fault_instr_i; end
		else if( tcu_lsu_exception_i[0] ) begin tcu_mcause_int = LOAD_ADDR_MISALIGNED; tcu_trap_detected_int[1] = 1'b1; tcu_mtval_int= tcu_fault_addr_i; end
		else if( tcu_lsu_exception_i[1] ) begin tcu_mcause_int = STORE_ADDR_MISALIGNED; tcu_trap_detected_int[1] = 1'b1; tcu_mtval_int= tcu_fault_addr_i; end
		else if( tcu_sync_exception_i[0] ) begin tcu_mcause_int = (priv_lvl_i) ? ENV_CALL_MMODE : ENV_CALL_UMODE; tcu_trap_detected_int[1] = 1'b1; tcu_mtval_int= '0; end
		else if( tcu_sync_exception_i[1] ) begin tcu_mcause_int = '0; tcu_trap_detected_int[1] = 1'b1; tcu_mtval_int= '0; end
		else begin tcu_trap_detected_int[1] = 1'b0; end
		
		//Interrupt Case : pending signal is high until the input interrupt signal is drive low by the external agent requiring the interrupt
			
		//Pending signals will be set by hardware only when a trap occurs. They must be cleared by software implementations
		
		if( tcu_csr_control_i.ext_int[1] | tcu_ext_intr_i ) tcu_ext_int_pend_int = ( tcu_csr_control_i.ext_int[0] ) ? 1'b1 : 1'b0;
		else tcu_ext_int_pend_int = 1'b0;
		
		if( tcu_csr_control_i.tim_int[1] | tcu_tim_intr_i ) tcu_tim_int_pend_int = ( tcu_csr_control_i.tim_int[0] ) ? 1'b1 : 1'b0;
		else tcu_tim_int_pend_int = 1'b0;
		
		if( tcu_csr_control_i.soft_int[1] | tcu_sw_intr_i ) tcu_sw_int_pend_int = ( tcu_csr_control_i.soft_int[0] ) ? 1'b1 : 1'b0;
		else tcu_sw_int_pend_int = 1'b0;
		
		/* Pending interrupts bits will be raised even if mie is low. However they will be handled only if mie is high and no exception has occurred */
		
		if( tcu_csr_control_i.mie & ~tcu_trap_detected_int[1] ) begin
			
			if( tcu_ext_int_pend_int ) begin tcu_mcause_int = MEXT_INT; tcu_trap_detected_int[0] = 1'b1; end
			else if( tcu_tim_int_pend_int ) begin tcu_mcause_int = MTIM_INT; tcu_trap_detected_int[0] = 1'b1; end
			else if( tcu_sw_int_pend_int ) begin tcu_mcause_int = MSW_INT; tcu_trap_detected_int[0] = 1'b1; end
			else begin tcu_trap_detected_int[0] = 1'b0; end
		
		end
		else begin
			tcu_trap_detected_int[0] = 1'b0;
		end
	end
	
	always_comb begin: trap_state_handling
	
		if( tcu_trap_detected_int != 2'b00 ) begin
		
			tcu_csr_we_int = 1'b1;
			
			if( ~tcu_sync_exception_i[1] ) begin 	//In case of no Return
			
				//If we are handling an interrupt during the MRET penality, use the old mepc instead of the next address (bcs it would refer to the first instruction following the mret)
				if( tcu_instr_penality_i[1] ) begin
					tcu_mepc_int = ( tcu_trap_detected_int[0] ) ? tcu_csr_control_i.mepc : tcu_next_pc_i;
				end 
				else if( tcu_instr_penality_i[0] ) begin	//Handling the ctrl Penality
					if( tcu_fault_instr_i != 32'h00000013 & tcu_trap_detected_int[0] ) tcu_mepc_int = tcu_next_pc_i;
				end
				else begin tcu_mepc_int = tcu_next_pc_i; end	//No penality during the trap
				
				tcu_trap_address_int = ( tcu_csr_control_i.mtvec[0] ) ? {tcu_csr_control_i.mtvec[31:2],2'b00} + {25'h000000,tcu_mcause_int,2'b00} : {tcu_csr_control_i.mtvec[31:2],2'b00} ;

				tcu_trap_state_int = {1'b0,tcu_csr_control_i.mie,priv_lvl_i};	//MIE becomes 0, mpie becomes the previous MIE, and MPP becomes the priv level (U or M)
			
			end
			else begin				 //In case of MRET
			
				tcu_mepc_int = tcu_csr_control_i.mepc;
				tcu_trap_address_int = '0 ;
			
				tcu_trap_state_int = {tcu_csr_control_i.mpie,1'b1,1'b1};	//MIE becomes 0, mpie becomes the previous MIE, and MPP becomes the priv level (U or M)
				//priv_lvl becomes tcu_csr_control_i.mpp
			end
		
		end
		else begin
			tcu_csr_we_int = 1'b0;
		end
	
	end
	
	assign tcu_trap_address_o = tcu_trap_address_int;
	assign tcu_trap_detected_o = tcu_trap_detected_int;
	assign tcu_mcause_o = {tcu_mcause_int[4],27'h0000000,tcu_mcause_int[3:0]};
	assign tcu_mepc_o = tcu_mepc_int;
	assign tcu_mtval_o = tcu_mtval_int;
	assign tcu_trap_state_o = tcu_trap_state_int;
	assign tcu_sw_int_pend_o = tcu_sw_int_pend_int;
	assign tcu_tim_int_pend_o = tcu_tim_int_pend_int;			
	assign tcu_ext_int_pend_o = tcu_ext_int_pend_int;
	assign tcu_halt_o = tcu_halt_int;
	assign tcu_csr_we_o = tcu_csr_we_int;

endmodule;
