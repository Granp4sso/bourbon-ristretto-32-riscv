`include "pkg/beta_if_stage_pkg.sv"

/*
	Instruction Fetch Stage v0.4 22/05/2022

	******|| INSTANTIABLES 	||******

	The instruction fetch stage is the first stage in the pipe. It can support the following units:

						- CodeType,	Mandatory,	Supported
		-Tightly Coupled Memory 	- [UNIT		N		N	]
		-Instruction Cache 		- [UNIT		N		N	]
		-Instruction pre-fetch buffer	- [UNIT		N		N	]
		-Program Counter		- [PROCESS	Y		Y	]
		-Instruction Fetch Unit		- [UNIT		Y		Y	]

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	-PrefetchBuffer :	Presence of a pre-fetch buffer. This feature is not supported yet
	-iTCM :			Presence of a tightly coupled memory. This feature is not supported yet
	-iCache :		Presence of a cache. This feature is not supported yet
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	-if_fetch_en_i : 	Enables new instruction fetc
	-if_instr_ready_i :	Instruction memory is ready to serve a data
	-if_instr_valid_i :	Instruction memory provided a valid data
	-if_instr_rdata_i :	Instruction memory provided data
	-if_instr_req_o :	Fetch Unit requesting a new instruction
	-if_pc_en_i :		Enable the program counter to catch new data (from another stage)
	-if_next_pc_i :		Program Counter next data to be saved
	-if_curr_pc_o :		Current Program Counter. It is used by following stages to compute branches and exceptions
	-if_instr_o :		Instruction data read from the instruction memory. It will be further decided by next stages
	-if_new_instr_o :	This signal notifies that a new instruction has been read to the next stages
	-f_stage_busy_o :	The if stage is busy. (i.e. sequential operations are running, like the imem protocol)

	******|| REMARKABLE 	||******

	******|| NOTES		||******

	Future updates will support a prefetch buffer for performance. TCMs and Caches as well.
	Other stages supports also a control unit. At the moment the if is not required to do so, but we will see in the future.
	
*/

module beta_if_stage import beta_pkg::*; #(

	parameter unsigned DataWidth = 32,

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
	output logic 			if_instr_req_o,

	/*Registers signals*/
	input				if_pc_en_i,
	input logic[DataWidth-1:0]	if_next_pc_i,
	output logic[DataWidth-1:0]	if_curr_pc_o,
	output logic[DataWidth-1:0] 	if_instr_o,
	output logic			if_new_instr_o,

	/*Intra stage sync*/
	output logic			if_stage_busy_o

);

	logic[DataWidth-1:0]	curr_pc_int;
	logic[DataWidth-1:0] 	instr_int;
	logic			if_stage_busy_int;
	logic			new_instr_int;
	logic 			instr_req_int;

	assign new_instr_int = if_instr_valid_i; //In the future this signal will depend also oin memory exceptions.

	/*Program Counter Process. In the future I could dedicate an entire unit for it*/

	always_ff@(posedge clk_i) begin: PC_process
		if(rstn_i == 1'b0) begin
			curr_pc_int <= '0;
		end
		else begin
			if(if_pc_en_i & if_fetch_en_i) begin
				curr_pc_int <= if_next_pc_i;
			end
		end
	end

	/*Fetch Unit instantiation*/

	beta_fetch_unit #(
		.DataWidth		(DataWidth)
	) fu (
		.clk_i			(clk_i),
		.rstn_i			(rstn_i),
		.if_fu_fetch_en_i	(if_fetch_en_i),
		.if_fu_instr_ready_i	(if_instr_ready_i),
		.if_fu_instr_valid_i	(if_instr_valid_i),
		.if_fu_instr_rdata_i	(if_instr_rdata_i),
		.if_fu_instr_req_o	(instr_req_int),

		.if_fu_instr_o		(instr_int),
		.if_fu_stage_busy_o	(if_stage_busy_int)

	);

	assign if_curr_pc_o = curr_pc_int;
	assign if_instr_o = instr_int;
	assign if_instr_req_o = instr_req_int;
	assign if_stage_busy_o = if_stage_busy_int;
	assign if_new_instr_o = new_instr_int;

endmodule
