//`include "pkg/ristretto_pkg.sv"

/*
	Pipeline Control Unit v0.3 30/09/2022

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	-AddrWidth :		Width of addresses
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	-pcu_ifs_busy_i :		Instruction Fetch Stage busy signal
	-pcu_ifs_fetch_en_o : 		Enable the IF stage to fetch a new instruction
	-pcu_decs_busy_i :		Instruction Decode Stage busy signal
	-pcu_exes_busy_i :		Execution Stage busy signal
	-pcu_pip0_stall_o : 		Stall the IF-DEC pipeline 
	-pcu_pip0_flush_o :		Flush the IF-DEC pipeline 	(When pipes are flushed, I'm not using this signal. So it is useless atm.)
	-pcu_pip1_stall_o :		Stall the DEC-EXE pipeline 
	-pcu_pip1_flush_o :		Flush the DEC-EXE pipeline 	(When pipes are flushed, I'm not using this signal. So it is useless atm.)
	-pcu_dec_rsrc1_i :		Decode stage register source 1, used for data hazard detection
	-pcu_dec_rsrc2_i :		Decode stage register source 2, used for data hazard detection
	-pcu_r_op_i :			Exe stage requested type operation (Reg operation or not?), used for data hazard detection
	-pcu_exe_rd_i :			Exe stage requested destination register, used for data hazard detection
	-pcu_exe_wreq_i :		Exe stage write reg signal, used for data hazard detection
	-pcu_exe_multi_cycle_i: 	High if a multi-cycle instruction is in the Exe stage, used for data hazard detection
	-pcu_dec_multi_cycle_i: 	High if a multi-cycle instruction is in the Decode stage, used for data hazard detection
	-data_hazard_flag_o :		If a data hazard is detected, set this signal
	-data_hazard_src_o :		If a data hazard is detected, replace the correct source with the forwarding
	-pcu_exe_trap_flag_i :		A trap has been detected into the exe stage
	-pcu_exe_bju_en_i :		A Ctrl opcode has been executed into the exe stage
	-pcu_trap_hazard_flag_o : 	Because of a trap, we have a hazard
	-pcu_ctrl_hazard_flag_o	:	Because of a Branch or a Jump, we have a hazard

	******|| REMARKABLE 	||******

	 pipeline_controller:
	 	This process drives a FF used to drive the if fetch signal. 

	******|| NOTES		||******

	The entire unit is quite minimal, which is good. However the pipeline system is sort of a mess. As you can see the entire module is just made of a bunch
	of assign, but the flush signal is never actually used. Pipeline flushes are handled differently.
	Stalls works in a weird way, and pipeline0 stall has is periodic which does not break the correct behaviour of the system, but leads to a useless greater energy consumption.
	Here, an overall rework is required.

*/

module ristretto_pipeline_control_unit #(

	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32
)(

	input  logic 			clk_i,
	input  logic 			rstn_i,

	/* Fetch Stage Signals */

	input  logic			pcu_ifs_busy_i,
	output logic			pcu_ifs_fetch_en_o,

	/* Decode Stage signals */

	input  logic			pcu_decs_busy_i,
	input  logic			pcu_decs_new_instr_i,
	input  logic			pcu_decs_pb_instr_tag_i,

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
	input logic			pcu_exe_branch_taken_i,
	
	output logic			data_hazard_flag_o,
	output logic[1:0] 		data_hazard_src_o,
	
	/* Control Hazard Signals */
	
	input logic[1:0]		pcu_exe_trap_flag_i,
	input logic[1:0]		pcu_exe_bju_en_i,
	output logic[1:0]		pcu_trap_hazard_flag_o,
	output logic[1:0]		pcu_ctrl_hazard_flag_o
	
);

	logic		pcu_ifs_fetch_en_int;
	logic		pcu_pip0_stall_int;
	logic		pcu_pip0_flush_int;
	logic		pcu_pip1_stall_int;
	logic		pcu_pip1_flush_int;

	logic		ifs_triggered_int;
	logic		pip0_stall_ff;
	
	always_ff@(posedge clk_i) begin : pipeline_controller
	
		
		if( rstn_i == 1'b0 ) begin
			pip0_stall_ff <= 1'b0;
		end
		else begin	

			if( pcu_decs_new_instr_i & pcu_exes_busy_i ) begin pip0_stall_ff <= 1'b1; end
			else if( pip0_stall_ff & ~pcu_exes_busy_i ) begin pip0_stall_ff <= 1'b0; end
			
		end
		
	end
	
	assign pcu_pip0_flush_int = |pcu_exe_trap_flag_i | (pcu_ctrl_hazard_flag_o == 2'b11) | (pcu_ctrl_hazard_flag_o == 2'b01 & pcu_exe_branch_taken_i);
	assign pcu_pip1_flush_int = |pcu_exe_trap_flag_i | (pcu_ctrl_hazard_flag_o == 2'b11) | (pcu_ctrl_hazard_flag_o == 2'b01 & pcu_exe_branch_taken_i);
	assign pcu_ifs_fetch_en_int = ~pcu_ifs_busy_i & ~pcu_pip0_stall_int;

	assign pcu_pip0_stall_int = ( ~pcu_decs_pb_instr_tag_i & pip0_stall_ff ) | ( pcu_decs_pb_instr_tag_i & pcu_exes_busy_i ) | pcu_decs_busy_i ;
	//assign pcu_pip0_stall_int = pip0_stall_ff | ( pcu_decs_pb_instr_tag_i & pcu_exes_busy_i ) | pcu_decs_busy_i ;
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
	assign data_hazard_flag_int = ~pcu_r_op_i[1] & ( ~pcu_r_op_i[0] & data_hazard_src_int[0] | pcu_r_op_i[0] & ( data_hazard_src_int[0] | data_hazard_src_int[1] ) ) & pcu_exe_wreq_i /*& pcu_exe_multi_cycle_i & pcu_dec_multi_cycle_i*/;
	
	//end
	
	assign data_hazard_flag_o = data_hazard_flag_int;
	assign data_hazard_src_o = data_hazard_src_int;
	
	
	assign pcu_ctrl_hazard_flag_o = {( pcu_exe_bju_en_i != 2'b01 ),( pcu_exe_bju_en_i != 2'b00 )};	//01 Branches, 11 Jumps
	assign pcu_trap_hazard_flag_o = pcu_exe_trap_flag_i;						//01 Interrupts, 10 Exceptions

	assign pcu_ifs_fetch_en_o = pcu_ifs_fetch_en_int;
	assign pcu_pip0_stall_o = pcu_pip0_stall_int;
	assign pcu_pip0_flush_o = pcu_pip0_flush_int;
	assign pcu_pip1_stall_o = pcu_pip1_stall_int;
	assign pcu_pip1_flush_o = pcu_pip1_flush_int;

endmodule

