`include "pkg/ristretto_if_stage_pkg.sv"

/*
	Instruction Fetch Stage v0.6 02/01/2023

	******|| INSTANTIABLES 	||******

	The instruction fetch stage is the first stage in the pipe. It can support the following units:

						- CodeType,	Mandatory,	Supported
		-Tightly Coupled Memory 	- [UNIT		N		N	]
		-Instruction Cache 		- [UNIT		N		N	]
		-Instruction pre-fetch buffer	- [UNIT		N		N	]
		-Program Counter		- [PROCESS	Y		Y	]
		-Instruction Fetch Unit		- [UNIT		Y		Y	]

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines
	-DataWidth :		Width of addresses
	-PrefetchBuffer :	Presence of a pre-fetch buffer. This feature is not supported yet
	-iTCM :			Presence of a tightly coupled memory. This feature is not supported yet
	-iCache :		Presence of a cache. This feature is not supported yet
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	-if_fetch_en_i : 		Enables new instruction fetch
	-if_instr_ready_i :		Instruction memory is ready to serve a data
	-if_instr_valid_i :		Instruction memory provided a valid data
	-if_instr_rdata_i :		Instruction memory provided data
	-if_instr_req_o :		Fetch Unit requesting a new instruction
	-if_pc_en_i :			Enable the program counter to catch new data (from another stage)
	-if_next_pc_i :			Program Counter next data to be saved
	-if_curr_pc_o :			Current Program Counter. It is used by following stages to compute branches and exceptions
	-if_instr_o :			Instruction data read from the instruction memory. It will be further decided by next stages
	-if_new_instr_o :		This signal notifies that a new instruction has been read to the next stages
	-f_stage_busy_o :		The if stage is busy. (i.e. sequential operations are running, like the imem protocol)
	-if_ctrl_hazard_flag_i:		A control hazard is notified to the fetch unit
	-if_trap_hazard_flag_i:		A trap hazard is notified to the fetch unit
	-if_penality_o:			Notifies the type of penality NOP

	******|| REMARKABLE 	||******
	
	-PC_proc:
		Implements the program counter.

	******|| NOTES		||******

	Future updates will support TCMs and Caches as well.
	Other stages supports also a control unit. At the moment the if is not required to do so, but we will see in the future.
	
*/

module ristretto_if_stage import ristretto_if_stage_pkg::*; #(

	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32,

	parameter unsigned PrefetchBuffer = 0,
	parameter unsigned iTCM = 0,
	parameter unsigned iCache = 0

) (
	input logic 			clk_i,
	input logic 			rstn_i,

	/*Instruction Memory Port*/
	input				if_fetch_en_i,
	input logic			if_instr_ready_i,
	input logic			if_instr_valid_i,
	input logic[DataWidth-1:0] 	if_instr_rdata_i,
	output logic[AddrWidth-1:0]	if_instr_addr_o,
	output logic 			if_instr_req_o,

	/*Register signals*/
	input				if_pc_en_i,
	input  logic[AddrWidth-1:0]	if_next_pc_i,
	output logic[AddrWidth-1:0]	if_curr_pc_o,
	output logic[DataWidth-1:0] 	if_instr_o,
	output logic			if_new_instr_o,

	/*Intra stage sync*/
	output logic			if_pb_instr_tag_o,
	input logic			if_ctrl_hazard_flag_i,
	input logic			if_trap_hazard_flag_i,
	output logic			if_stage_busy_o,
	output logic[1:0]		if_penality_o

);

	// Instruction Fetch Stage signals
	
	logic[AddrWidth-1:0]	if_curr_pc_reg;
	logic[AddrWidth-1:0]	if_fast_pc_int;
	logic			if_stage_busy_int;
	logic 			if_instr_req_int;
	
	// Fetch Unit Signals
	
	logic[DataWidth-1:0] 	if_fu_instr_int;
	logic			if_fu_busy_int;
	logic			if_fu_new_instr_int;
	logic			if_fu_fetch_en_int;
	
	// [ Prefetch Buffer Signals ]
	logic			if_pb_instr_tag_int = 1'b0;
	logic			if_pb_active_int = 1'b0;
	
	// Final Output Signals
	
	logic[AddrWidth-1:0] 	if_fin_curr_pc_int;
	logic[AddrWidth-1:0] 	if_fin_instr_int;
	logic			if_fin_new_instr_int;
	
	/* Prefetch Buffer Optional instantiation */
	
	if( PrefetchBuffer ) begin
	
		logic [DataWidth-1:0]	if_pb_curr_pc_int;
		logic [DataWidth-1:0] 	if_pb_instr_int;
		logic			if_pb_new_instr_int;			
		logic			if_pb_fu_fetch_en_int;		
		
		assign if_fin_curr_pc_int = 	if_pb_curr_pc_int;
		assign if_fin_instr_int = 	if_pb_instr_int;
		assign if_fin_new_instr_int = 	if_pb_new_instr_int;
		assign if_fu_fetch_en_int = 	if_pb_fu_fetch_en_int;	
		assign if_stage_busy_int = 	1'b0;
		
		ristretto_prefetch_buffer #(
			.DataWidth			(DataWidth),
			.AddrWidth			(AddrWidth),
			.BufferSize			(8)
		) pb (
			.clk_i				(clk_i),
			.rstn_i				(rstn_i),
			.if_pb_fetch_en_i		(if_fetch_en_i),
			.if_pb_instr_o			(if_pb_instr_int),
			.if_pb_instr_tag_o		(if_pb_instr_tag_int),
			.if_pb_new_instr_o		(if_pb_new_instr_int),		
			.if_pb_trap_hazard_flag_i	(if_trap_hazard_flag_i),	
			.if_pb_ctrl_hazard_flag_i	(if_ctrl_hazard_flag_i),
			.if_pb_current_pc_o		(if_pb_curr_pc_int),
			.if_pb_active_o			(if_pb_active_int),
			
			.if_pb_current_pc_i		(if_fast_pc_int),
			.if_pb_fu_new_instr_i		(if_fu_new_instr_int),
			.if_pb_instr_i			(if_fu_instr_int),
			.if_pb_fu_busy_i		(if_fu_busy_int),
			.if_pb_fu_fetch_o		(if_pb_fu_fetch_en_int)
		);
		
	end
	else begin
	
		assign if_fin_curr_pc_int = 	if_curr_pc_reg;
		assign if_fin_instr_int = 	if_fu_instr_int;
		assign if_fin_new_instr_int = 	if_fu_new_instr_int;
		assign if_fu_fetch_en_int = 	if_fetch_en_i;
		assign if_stage_busy_int = 	if_fu_busy_int;
		
		assign if_pb_instr_tag_int = 	1'b0;
		assign if_pb_active_int = 	1'b0;
	
	end

	/*Program Counter Process */
	
	assign if_fast_pc_int = ( if_fetch_en_i & ( if_ctrl_hazard_flag_i | if_trap_hazard_flag_i ) ) ? if_next_pc_i : if_curr_pc_reg;

	always_ff@(posedge clk_i) begin: PC_proc
		if(rstn_i == 1'b0) begin
			if_curr_pc_reg <= '0;
		end
		else begin
			if( if_fu_fetch_en_int ) begin
				if_curr_pc_reg <= ( if_ctrl_hazard_flag_i | if_trap_hazard_flag_i ) ? if_next_pc_i : if_curr_pc_reg + 4;
			end
			else if( if_fetch_en_i & if_trap_hazard_flag_i ) if_curr_pc_reg <= if_next_pc_i ;
			else if( if_fetch_en_i & if_ctrl_hazard_flag_i ) if_curr_pc_reg <= ( if_pb_active_int & ~if_instr_req_int ) ? if_next_pc_i - 4 : if_next_pc_i ;
		end
	end

	/*Fetch Unit instantiation*/

	ristretto_fetch_unit #(
		.DataWidth			(DataWidth)
	) fu (
		.clk_i				(clk_i),
		.rstn_i				(rstn_i),
		.if_fu_fetch_en_i		(if_fu_fetch_en_int),
		.if_fu_instr_ready_i		(if_instr_ready_i),
		.if_fu_instr_valid_i		(if_instr_valid_i),
		.if_fu_instr_rdata_i		(if_instr_rdata_i),
		.if_fu_instr_req_o		(if_instr_req_int),

		.if_fu_instr_o			(if_fu_instr_int),
		.if_fu_new_instr_o		(if_fu_new_instr_int),
		.if_fu_stage_busy_o		(if_fu_busy_int),
		.if_fu_penality_o		(if_penality_o),
		.if_fu_state_o			(),
		
		.if_fu_trap_hazard_flag_i	(if_trap_hazard_flag_i),
		.if_fu_ctrl_hazard_flag_i	(if_ctrl_hazard_flag_i)

	);
	
	assign if_curr_pc_o = 		if_fin_curr_pc_int;
	assign if_instr_addr_o = 	if_fast_pc_int;
	assign if_instr_o = 		if_fin_instr_int;
	assign if_instr_req_o = 	if_instr_req_int;
	assign if_stage_busy_o = 	if_stage_busy_int;
	assign if_new_instr_o = 	if_fin_new_instr_int;
	assign if_pb_instr_tag_o = 	if_pb_instr_tag_int;

endmodule
