//`include "pkg/beta_pkg.sv"

/*
	Global Pipeline Control Unit v0.2 9/07/2022

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	-StageNum :		Number of pipeline stages (3 in Bourbon)
	
	******|| INTERFACES 	||******


	******|| REMARKABLE 	||******

	

	******|| NOTES		||******

	The Pipeline control unit is responsible for the Pipeline syncronization and Hazard detection.
	It will host N ports, where N is the number of pipeline stages. Eache stage will at least support the flush and stall signals.
	The pipeline is quite inefficient at the moment, because the pip0_stall toggles quite too often uselessly. Moreover, many fetches are performed
	from the imem, while they are not require. The pipeline still works because the instruction address does not change.
	Data Hazard Detection V


*/

module beta_pipeline_control_unit import beta_pkg::*; #(

	parameter unsigned DataWidth = 32,
	parameter unsigned StageNum = 3		//Atm it is not that useful
)(

	input  logic 			clk_i,
	input  logic 			rstn_i,

	/* Fetch Stage Signals */

	input  logic			pcu_ifs_busy_i,
	output logic			pcu_ifs_fetch_en_o,

	/* Decode Stage signals */

	input  logic			pcu_decs_busy_i,

	/* Execution Stage signals */

	input  logic			pcu_exes_busy_i,

	/* Pipe if-to-dec signals */

	output logic			pcu_pip0_stall_o,
	output logic			pcu_pip0_flush_o,

	/* Pipe dec-to-exe signals */

	output logic			pcu_pip1_stall_o,
	output logic			pcu_pip1_flush_o,
	
	/* Data Hazard Control Signals */
	
	input logic[4:0]		pcu_dec_rsrc1_i,
	input logic[4:0]		pcu_dec_rsrc2_i,
	input logic[1:0]		pcu_r_op_i,		//The operation is a reg type ?
	input logic[4:0]		pcu_exe_rd_i,
	input logic			pcu_exe_wreq_i,		//write req
	input logic			pcu_exe_multi_cycle_i,
	input logic			pcu_dec_multi_cycle_i,
	
	output logic			data_hazard_flag_o,
	output logic[1:0] 		data_hazard_src_o,
	
	/* Control Hazard Signals */
	
	input logic[1:0]		pcu_exe_trap_flag_i,
	input logic[1:0]		pcu_exe_bju_en_i,
	output logic[1:0]		pcu_trap_hazard_flag_o,
	output logic[1:0]		pcu_ctrl_hazard_flag_o
	
);

	logic			pcu_ifs_fetch_en_int;
	logic			pcu_pip0_stall_int;
	logic			pcu_pip0_flush_int;
	logic			pcu_pip1_stall_int;
	logic			pcu_pip1_flush_int;

	logic			ifs_triggered_int;
	logic fetch_sync_latch;
	
	always_ff@(posedge clk_i) begin : pipeline_controller
	
		
		if( rstn_i == 1'b0 ) begin
			pcu_pip0_flush_int <= 1'b0;
			pcu_pip1_flush_int <= 1'b0;
			fetch_sync_latch <= 1'b0;
		end
		else begin	
			if( pcu_pip1_stall_int & ~fetch_sync_latch ) begin fetch_sync_latch <= 1'b1; end 
			else if( ~pcu_pip1_stall_int & fetch_sync_latch ) begin fetch_sync_latch <= 1'b0; end 
		end
		
	end
	
	assign pcu_ifs_fetch_en_int = ~fetch_sync_latch & ~pcu_ifs_busy_i & ~pcu_pip0_stall_int;		 //& ~pcu_pip1_stall_int;
	assign pcu_pip0_stall_int = (pcu_ifs_busy_i & pcu_decs_busy_i);
	assign pcu_pip1_stall_int = pcu_exes_busy_i ;
	

	/*
		the trigger notices us when the if stage succesfully fetched a new instruction 
		Because the dec stage only takes 1 clk cycles, the trigger will become high exactly when the dec_busy will fall down. So, we will stall the pipe only if a new instruction
		has been charged into the ifs stage, but the decode stage has not passed its decoded instruction yet to the execution stage.
		When the decode stage will take more than 1 clk cycles, things will get more complicated: i.e. the pipe will have some "shadow-stalls" which won't affect the 
		correct behaviour, but will periodically and uselessly commutate-> consume power
	*/
	
	/*
		DATA HAZARD:
		for the moment, we have combinatorial instructions which requires 4 IF cycles, 1 DEC cycles and 3 EXE cycles. After 8 clock cycles, the data will be written.
		Two Comb.Instructions will overlap in a way that when the second instruction enters the DEC stages, it will already dispose the data written by the previous instruction.
		
		1 : F F F F D E E E 
		2 : - - - - F F F F D E E E
		
		Further optimizations meant to balance the pipe and maximize the throughput will make data hazards occur even in this case.
		(e.g. reducing F thanks to buffers, caches etc.. or increasing the number of D cycles)
		So Data hazards are avoided as long as D(i) is reached after the end of E(i-1).
		
		If we take a Shift instead, it will require 5 cs (which I hope to reduce, because they are) + N (shift required) as long as N > 2 (otherwise the shift is a comb.op).
		
		1 : F F F F D E E E E E E E E E
		2 : - - - - F F F F D - - - - - E E E 
		
		In this case what happens is that D_start(i) < E_end(i-1). However the the pip1 doesn't stall when comb.op are executed, hence 2 will be capable of passing the new data during the 
		second clock cycle of E and instantaneously complete the computation.
		The expense in terms of cs in exe stage is given by Sync signals, so data hazards won't happen for the combo:
			1 - comb -> comb	because  D_start(i) = E_end(i-1)
			2 - comb -> seq		because  D_start(i) = E_end(i-1)
			3 - seq -> comb		because despite D_start(i) < E_end(i-1), comb.op will receive new data every E cycles cause pip1 won't stall
		It will happen for the combo
			3 - seq -> seq		because despite D_start(i) < E_end(i-1), and a seq.op will stall the pip1.
			
		So at the moment, the following conditions verifies a Data hazard:
		
		DataHazard = ( Register_dest(i-1) == Register_source(i) ) & Write_en(i-1) & multi_cycle(i-1) & multi_cycle(i)  
	*/
	
	/* DATA HAZARD FLAG */
	
	/* The hazard signal is not working. Actyuually every flag is active, but the signal is still 0. It looks like the SystemVerilog AND operator is broken. WTF?!? */
	
	logic 		data_hazard_flag_int;
	logic[1:0] 	data_hazard_src_int;
	
	//always_comb begin: data_hazard_proc
		
	assign data_hazard_src_int = { ( pcu_exe_rd_i == pcu_dec_rsrc2_i ),( pcu_exe_rd_i == pcu_dec_rsrc1_i ) };
	assign data_hazard_flag_int = ~pcu_r_op_i[1] & ( ~pcu_r_op_i[0] & data_hazard_src_int[0] | pcu_r_op_i[0] & ( data_hazard_src_int[0] | data_hazard_src_int[1] ) ) & pcu_exe_wreq_i & pcu_exe_multi_cycle_i & pcu_dec_multi_cycle_i;
	
	//end
	
	assign data_hazard_flag_o = data_hazard_flag_int;
	assign data_hazard_src_o = data_hazard_src_int;
	
	/* CONTROL HAZARD PROCESS 
		At the moment the bit 0 of ctrl_hazard_flag encodes for traps as well, since they behave like jumps. When branch predictors will be supported, traps
		will need an extra bit in order to separate them from jumps
	*/
	
	assign pcu_ctrl_hazard_flag_o = {( pcu_exe_bju_en_i != 2'b01 ),( pcu_exe_bju_en_i != 2'b00 )};	//01 Branches, 11 Jumps
	assign pcu_trap_hazard_flag_o = pcu_exe_trap_flag_i;						//01 Interrupts, 10 Exceptions
	
	assign pcu_ifs_fetch_en_o = pcu_ifs_fetch_en_int;
	assign pcu_pip0_stall_o = pcu_pip0_stall_int;
	assign pcu_pip0_flush_o = pcu_pip0_flush_int;
	assign pcu_pip1_stall_o = pcu_pip1_stall_int;
	assign pcu_pip1_flush_o = pcu_pip1_flush_int;

endmodule

