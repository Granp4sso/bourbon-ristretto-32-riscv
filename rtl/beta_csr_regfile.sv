`include "pkg/beta_csr_pkg.sv"

/*
	8/08/2022
	
	For the moment I define a logic[DataWidth-1:0] for each CSR.
	Read-only fixed registers are hardcoded into the core.
	U-mode and M-mode support is a must, still in progress..
	Little-endianess only will be supported for now
	
	MISA is not writeable, at the moment, and it is a RO fixed value
	MTVEC is not writeable, at the moment, and it is a RO fixed value
	
	THe menvcfg reg is not supported because the extensions it refers to (Fence, Zicboz, Zicbom) are not supported in Bourbon atm
	
	Machine Configuration Registers 	: Done			( mvendor, misa, mhartid, mconfigptr, etc..	)
	Machine Trap Handling Registers 	: Partially Done	( mstatus, mie, mip, mtvec, mcause etc.. 	)
	Machine Memory Protection Registers 	: Not Done		( pmpcfg, pmpaddr, mseccfg 			)
	Machine Performance Registers   	: Not Done		( mcounten, mcycle, hpmcounter etc..		)
	Machine Debug Specification Registers	: Not Done		( dcsr, dpc, trace etc..			)

*/


module beta_csr_regfile import beta_csr_pkg::*; #(
		
		parameter unsigned DataWidth = 32
	
	)(

		input logic 			clk_i,
		input logic			rstn_i,
		
		/* CSRs opcode interface */
		
		input logic[11:0] 		csr_addr_i,
		input logic[DataWidth-1:0]	csr_wdata_i,
		input logic[2:0]		csr_op_i,
		input logic	 		csr_en_i, 
		
		output logic[DataWidth-1:0]	csr_rdata_o,
		
		/* Input signals for Trap Handling */
		
		
		input logic[1:0]		csr_priv_lvl_i,
		input logic [DataWidth-1:0] 	csr_mtval_i,
		input logic [DataWidth-1:0] 	csr_mcause_i,
		input logic [DataWidth-1:0] 	csr_mepc_i,
		input logic			csr_sw_int_pend_i,
		input logic  			csr_tim_int_pend_i,			
		input logic   			csr_ext_int_pend_i,
		input logic [2:0]		csr_trap_state_i,	//MIE,MPIE,MPP

		input logic			tcu_csr_we_i,
		output logic [DataWidth-1:0] 	csr_mepc_o,
		
		/* List of CSRs output signals */
		
		output csr_ctrl_t		csr_control_o
	);
	
	
	logic [DataWidth-1:0]		csr_rdata_int;

	logic [DataWidth-1:0]		csr_mconfigptr_int;
	logic [MSTATUS_WIDTH-1:0]	csr_mstatus_int;
	logic 				csr_mstatush_int;
	logic [MIP_WIDTH-1:0]		csr_mip_int;
	logic [MIE_WIDTH-1:0]		csr_mie_int;
	logic [DataWidth-1:0]		csr_mepc_int;
	logic [DataWidth-1:0]		csr_mcause_int;
	logic [DataWidth-1:0]		csr_mtval_int;
	logic [DataWidth-1:0]		csr_mtvec_int;
	
	/* CSR Processes */
	
	// Modify CSRs process
	
	always_ff @(posedge clk_i) begin : csr_edit_proc
		if( rstn_i == 1'b0 ) begin
			csr_mstatus_int		<= '0;
			csr_mstatush_int	<= '0;
			csr_mip_int		<= '0;
			csr_mie_int		<= '0;
			csr_mepc_int		<= '0;
			csr_mcause_int		<= '0;
			csr_mtvec_int		<= MTVEC_BASE | MTVEC_MODE_V;
			csr_mtval_int		<= '0;
			csr_mconfigptr_int	<= '0;
		end
		else if( tcu_csr_we_i ) begin
			csr_mtval_int <= csr_mtval_i;
			csr_mcause_int <= csr_mcause_i;
			csr_mepc_int <= csr_mepc_i;
			csr_mip_int[MIE_MSI_BIT] <= csr_sw_int_pend_i;
			csr_mip_int[MIE_MTI_BIT] <= csr_tim_int_pend_i;		
			csr_mip_int[MIE_MEI_BIT] <= csr_ext_int_pend_i;
			csr_mstatus_int[MSTATUS_MIE_BIT] <= csr_trap_state_i[2];
			csr_mstatus_int[MSTATUS_MPIE_BIT] <= csr_trap_state_i[1];
			csr_mstatus_int[MSTATUS_MPP_BIT] <= csr_trap_state_i[0];
		end
		else if( csr_en_i & ( csr_op_i[0] | csr_op_i[1] ) ) begin
			case ( csr_addr_i )
			
				/*0x300*/ MSTATUS 	: begin 
								if( csr_op_i[0] & csr_op_i[1] ) begin 	//WRITE
									csr_mstatus_int[MSTATUS_MIE_BIT] <= csr_wdata_i[1];  
									csr_mstatus_int[MSTATUS_UBE_BIT] <= 1'b0; //csr_wdata_i[6];  
									csr_mstatus_int[MSTATUS_MPIE_BIT] <= csr_wdata_i[7];  
									csr_mstatus_int[MSTATUS_MPP_BIT] <= csr_wdata_i[11];
									csr_mstatus_int[MSTATUS_MPRV_BIT] <= csr_wdata_i[17];   
									csr_mstatus_int[MSTATUS_TW_BIT] <= csr_wdata_i[21]; 
								end
								else if( csr_op_i[0] ) begin		//SET
									csr_mstatus_int <= csr_mstatus_int | {csr_wdata_i[21],csr_wdata_i[17],csr_wdata_i[11],csr_wdata_i[7],1'b0,csr_wdata_i[1]};  
								end
								else if( csr_op_i[1] ) begin		//RESET
									csr_mstatus_int <= csr_mstatus_int & ~({csr_wdata_i[21],csr_wdata_i[17],csr_wdata_i[11],csr_wdata_i[7],1'b0,csr_wdata_i[1]});  
								end
						
							  end
					
				/*0x301*/ //MISA	: //MISA is not writeable at all in this implementation atm
				
				/*0x304*/ MIE		: begin 
								if( csr_op_i[0] & csr_op_i[1] ) begin 	//WRITE
									csr_mie_int[MIE_MEI_BIT] <= csr_wdata_i[11]; 
									csr_mie_int[MIE_MTI_BIT] <= csr_wdata_i[7]; 
									csr_mie_int[MIE_MSI_BIT] <= csr_wdata_i[3]; 
								end
								else if( csr_op_i[0] ) begin		//SET
									csr_mie_int <= csr_mie_int | {csr_wdata_i[11],csr_wdata_i[7],csr_wdata_i[3]};  
								end
								else if( csr_op_i[1] ) begin		//RESET
									csr_mie_int <= csr_mie_int & ~({csr_wdata_i[11],csr_wdata_i[7],csr_wdata_i[3]});  
								end
								
							  end
							  
				/*0x305*/ //MTVEC	: //MTVEC is not writeable in this implementation atm
				
				/*0x310*/ MSTATUSH 	: begin 
								csr_mstatush_int <= 1'b0; //csr_wdata_i[5];   
								
							  end
				
				/*0x341*/ MEPC		: begin 
								if( csr_op_i[0] & csr_op_i[1] ) begin 	//WRITE
									csr_mepc_int <= csr_wdata_i; 
								end
								else if( csr_op_i[0] ) begin		//SET
									csr_mepc_int <= csr_mepc_int | csr_wdata_i;  
								end
								else if( csr_op_i[1] ) begin		//RESET
									csr_mepc_int <= csr_mepc_int & ~csr_wdata_i;  
								end
							  end
				
				/*0x342*/ //MCAUSE	: //MCAUSE is not writeable in this implementation by software
				
				/*0x343*/ MTVAL		: begin 
								if( csr_op_i[0] & csr_op_i[1] ) begin 	//WRITE
									csr_mtval_int <= csr_wdata_i; 
								end
								else if( csr_op_i[0] ) begin		//SET
									csr_mtval_int <= csr_mtval_int | csr_wdata_i;  
								end
								else if( csr_op_i[1] ) begin		//RESET
									csr_mtval_int <= csr_mtval_int & ~csr_wdata_i;  
								end
							  end
							  
				/*0x344*/ MIP		: begin 
								if( csr_op_i[0] & csr_op_i[1] ) begin 	//WRITE
									csr_mip_int[MIE_MEI_BIT] <= csr_wdata_i[11]; 
									csr_mip_int[MIE_MTI_BIT] <= csr_wdata_i[7]; 
									csr_mip_int[MIE_MSI_BIT] <= csr_wdata_i[3]; 
								end
								else if( csr_op_i[0] ) begin		//SET
									csr_mip_int <= csr_mip_int | {csr_wdata_i[11],csr_wdata_i[7],csr_wdata_i[3]};  
								end
								else if( csr_op_i[1] ) begin		//RESET
									csr_mip_int <= csr_mip_int & ~({csr_wdata_i[11],csr_wdata_i[7],csr_wdata_i[3]});  
								end
								
							  end
							  
					
				/*0xF15*/ MCONFIGPTR 	: begin 
								if( csr_op_i[0] & csr_op_i[1] ) begin 	//WRITE
									csr_mconfigptr_int <= csr_wdata_i; 
								end
								else if( csr_op_i[0] ) begin		//SET
									csr_mconfigptr_int <= csr_mconfigptr_int | csr_wdata_i;  
								end
								else if( csr_op_i[1] ) begin		//RESET
									csr_mconfigptr_int <= csr_mconfigptr_int & ~csr_wdata_i;  
								end
							  end
							  
					  default	: begin end 
				
			endcase
		end
	end;
	
	// Read CSRs process
		
	always_comb begin : read_proc 
		if( csr_en_i & csr_op_i[CSR_OP_R_BIT] ) begin
		
			case ( csr_addr_i )
			
				/*0xF11*/ MVENDORID 	: begin csr_rdata_int = '0;			end	//Read-Only fixed value
				/*0xF12*/ MARCHID  	: begin csr_rdata_int = 32'h7fffffff; 		end	//Read-Only, No global ID associated. MSB is zero because this is not a commercial version
				/*0xF13*/ MIMPID 	: begin csr_rdata_int = 32'h00000001; 		end	//Read-Only fixed value (implementation dependant)
				/*0xF14*/ MHARTID 	: begin csr_rdata_int = 32'h00000000;		end	//Read-Only fixed value (main core hart ID is 0)
				/*0xF15*/ MCONFIGPTR 	: begin csr_rdata_int = csr_mconfigptr_int; 	end
				
				/*0x300*/ MSTATUS 	: begin 
								csr_rdata_int = {
											10'h000,
											csr_mstatus_int[MSTATUS_TW_BIT], 3'b000, csr_mstatus_int[MSTATUS_MPRV_BIT], 5'h00,
											csr_mstatus_int[MSTATUS_MPP_BIT], 3'b000, csr_mstatus_int[MSTATUS_MPIE_BIT:MSTATUS_UBE_BIT],
											2'b00, csr_mstatus_int[MSTATUS_MIE_BIT], 3'b000
										  }; 	
							  end
							  
				/*0x301*/ MISA		: begin csr_rdata_int = 32'h40000000 | ARCH_EXT_I | ARCH_EXT_U;	end	//Read-only, fixed value atm
				/*0x304*/ MIE		: begin csr_rdata_int = {
											16'h0000,4'h0,csr_mie_int[MIE_MEI_BIT],
											3'h0,csr_mie_int[MIE_MTI_BIT],3'h0,
											csr_mie_int[MIE_MSI_BIT],3'h0 
										 };	
							  end
				
				/*0x305*/ MTVEC		: begin csr_rdata_int = csr_mtvec_int;			end	//Read-only, fixed value atm
				
				/*0x310*/ MSTATUSH 	: begin 
								csr_rdata_int = {
											26'h0000000,
											csr_mstatush_int,
											5'h00
										  }; 	
							  end
				/*0x341*/ MEPC		: begin csr_rdata_int = csr_mepc_int; end
				/*0x342*/ MCAUSE	: begin csr_rdata_int = csr_mcause_int; end
				/*0x343*/ MTVAL		: begin csr_rdata_int = csr_mtval_int; end
				/*0x344*/ MIP		: begin csr_rdata_int = {
											16'h0000,4'h0,csr_mip_int[MIE_MEI_BIT],
											3'h0,csr_mip_int[MIE_MTI_BIT],3'h0,
											csr_mip_int[MIE_MSI_BIT],3'h0 
										 };	
							  end
					  default	: begin csr_rdata_int = '0; end
			
			endcase
			
		end
	end
	
	/* Trap Handling interface process */

	/* Assigning outputs */
	
	assign csr_rdata_o = csr_rdata_int;
	
	assign csr_control_o.mie = csr_mstatus_int[MSTATUS_MIE_BIT];
	assign csr_control_o.mpie = csr_mstatus_int[MSTATUS_MPIE_BIT];
	assign csr_control_o.modify_privilege = csr_mstatus_int[MSTATUS_MPRV_BIT];
	assign csr_control_o.mpp = csr_mstatus_int[MSTATUS_MPP_BIT];
	assign csr_control_o.machine_endianess = csr_mstatush_int;
	assign csr_control_o.user_endianess = csr_mstatus_int[MSTATUS_UBE_BIT];
	assign csr_control_o.mtvec = csr_mtvec_int;
	assign csr_control_o.ext_int = {csr_mip_int[MIE_MEI_BIT], csr_mie_int[MIE_MEI_BIT]};
	assign csr_control_o.tim_int = {csr_mip_int[MIE_MTI_BIT], csr_mie_int[MIE_MTI_BIT]};
	assign csr_control_o.soft_int = {csr_mip_int[MIE_MSI_BIT], csr_mie_int[MIE_MSI_BIT]};
	assign csr_control_o.mcause = csr_mcause_int;
	assign csr_control_o.mtval = csr_mtval_int;
	assign csr_mepc_o = csr_mepc_int;
	

endmodule;
