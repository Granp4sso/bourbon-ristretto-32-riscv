`include "pkg/beta_if_stage_pkg.sv"

/*
	Fetch Unit v0.1 22/05/2022

	******|| INSTANTIABLES 	||******
						- CodeType,	Mandatory,	Supported
		-N/A				- [N/A		N/A		N/A	]

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	-if_fu_fetch_en_i : 	Enables new instruction fetch
	-if_fu_instr_ready_i :	Instruction memory is ready to serve a data
	-if_fu_instr_valid_i :	Instruction memory provided a valid data
	-if_fu_instr_rdata_i :	Instruction memory provided data
	-if_fu_instr_req_o :	Fetch Unit requesting a new instruction
	-if_fu_instr_o :	New instruction read from the instruction memory
	-if_fu_stage_busy_o :	The if stage is busy. (i.e. sequential operations are running, like the imem protocol)

	******|| REMARKABLE 	||******

	-imem_protocol : 	this process implements the instruction memory protocol:
				--Once the fetch_en raises a new request will be forwarded to the imem (instr_req_o) to curr_pc_o address
				--The imem will send an instr_ready_i signal to notify that the request has been accepteed.
				--Once the instr_rvalid_i signal is high (for exactly one clock cycle), the instr_rdata_i will be captured into the instruction register

	******|| NOTES		||******

	This unit is meant to provide the imem protocol interface to the outside. It is meant to interact with the outside world
	so that it will provide the fetched instruction to the IF stage/ Buffer/ TCM/ Caches or whatever, but it will read directly
	from the memory. 
	In the future I'd like to support an AMBA like protocol, maybe with an external controller. So the Imem hierarchy should
	look as:
		-Instruction Memory <-> AMBA Protocol Converter <-> Fetch Unit <-> iCache <-> TCM <-> Prefetch Buffer <-> IF stage 

	Given an ideal 1 clk cycle response, the protocol takes 3 clock cycles from the request to the outside to the provisioniong of the
	new instruction.


*/

module beta_fetch_unit import beta_if_stage_pkg::*; #(
	parameter unsigned DataWidth = 32
)(
	input logic			clk_i,
	input logic			rstn_i,
	input logic			if_fu_fetch_en_i,
	input logic			if_fu_instr_ready_i,
	input logic			if_fu_instr_valid_i,
	input logic[DataWidth-1:0] 	if_fu_instr_rdata_i,
	output logic 			if_fu_instr_req_o,

	output logic[DataWidth-1:0]	if_fu_instr_o,
	output logic			if_fu_new_instr_o,
	output logic			if_fu_stage_busy_o,
	
	input logic			if_fu_ctrl_hazard_flag_i
);

	logic 				if_stage_busy_int;
	logic 				instr_req_int;
	logic[DataWidth-1:0]		instr_int;
	logic				new_instr_int;

	logic[imem_fsm_bsize-1:0] 	imem_state_int;

	always_ff@(posedge clk_i) begin: imem_protocol
		if(rstn_i == 1'b0) begin
			instr_int <= '0;
			if_stage_busy_int <= 1'b0;
			new_instr_int <= 1'b0;
			imem_state_int <= IMEM_IDLE;
		end
		else begin
			case(imem_state_int)

			IMEM_IDLE: begin
				if(if_fu_fetch_en_i) begin
					if_stage_busy_int <= 1'b1;
					instr_req_int <= 1'b1;
					imem_state_int <= IMEM_WRDY;
				end
				new_instr_int <= 1'b0;
			end

			IMEM_WRDY: begin
				if(if_fu_instr_ready_i) begin
					instr_req_int <= 1'b0;
					imem_state_int <= IMEM_WVLD;		
				end
			end

			IMEM_WVLD: begin
				if(if_fu_instr_valid_i) begin
					if_stage_busy_int <= 1'b0;
					instr_int <= ( if_fu_ctrl_hazard_flag_i )? 32'h00000013 : if_fu_instr_rdata_i;	//inject a NOP if a ctrl hazard is detected
					new_instr_int <= 1'b1;
					imem_state_int <= IMEM_IDLE;		
				end
			end
			default: imem_state_int <= IMEM_IDLE; 
			endcase
			
		end
	end

	assign if_fu_instr_o = instr_int;
	assign if_fu_instr_req_o = instr_req_int;
	assign if_fu_stage_busy_o = if_stage_busy_int;
	assign if_fu_new_instr_o = new_instr_int;

endmodule;



