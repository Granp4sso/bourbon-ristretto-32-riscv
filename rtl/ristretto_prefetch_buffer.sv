`include "pkg/ristretto_if_stage_pkg.sv"

/*
	Prefetch Buffer v0.4 02/01/2023

	******|| INSTANTIABLES 	||******
						- CodeType,	Mandatory,	Supported
		-N/A				- [N/A		N/A		N/A	]

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	-AddrWidth : 		Width of address bus (32 bits or 64 bits)
	-BufferSize :		Prefetch Buffer entries number ( power of two required )
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	if_pb_fetch_en_i :		The core is requesting the fetch of a new instruction
	if_pb_instr_o :			Prefetch buffer provided instruction. It can be a passedthrough instruction from the FU or a stored instruction in the pb queue
	if_pb_instr_tag_o :		High if the instruction is fetched from the buffer, 0 if it is provided by the FU
	if_pb_new_instr_o :		New instruction signal attached with the new instruction		
	if_pb_trap_hazard_flag_i :	An exception/interrupt Occurred. Flush the buffer.
	if_pb_ctrl_hazard_flag_i :	A Jump Occurred. Flush the buffer.
	if_pb_current_pc_o :		Produce the current PC address.
	if_pb_active_o :		The prefetch buffer is storing/providing new instructions
	if_pb_current_pc_i :		Receive the program counter from the outside
	if_pb_fu_new_instr_i :		New instruction signal from the FU
	if_pb_instr_i :			Instruction produced by the FU
	if_pb_fu_busy_i :		Read the FU state
	if_pb_fu_fetch_o :		Require a new instruction to the FU

	******|| REMARKABLE 	||******

	passthrough :
		The prefetch buffer must require a new instruction from the FU unless it is full. The passthrough logic establishes if an instruction, its new instruction signal and
		the instruction address has to be taken from the FU directly or from the PB buffer ( or if it is a NOP penality ).

	pb_protocol :
		The pb protocol is a sequential machine handling meant to handle the queue structure for read and write.
		It also handles the flush of the buffer whenever a control hazard is detected.
	
	******|| NOTES		||******

		The prefetch buffer is actually quite simple, it is just a queue. It allows the core to mask the instruction memory delay and achieve a 1 cycle execution for each stage.
		Of course it will be quite useful for memory intensive workloads and less for compute intensive ones ( unless imem can respond faster than execution stage can provide data,
		and that might be the case for some multi-cycle instructions such as divisions ).
		There are some signals used to handle "limit situations" such as the last instruction released when a buffer becomes empty or the instruction received
		upon a flush ( which must not be stored ).
*/

module ristretto_prefetch_buffer import ristretto_if_stage_pkg::*; #(

	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32,
	parameter unsigned BufferSize = 8
	
)(
	input logic			clk_i,
	input logic			rstn_i,
	
	//Instruction fetch stage interface
	
	input logic			if_pb_fetch_en_i,
	
	output logic[DataWidth-1:0]	if_pb_instr_o,
	output logic			if_pb_instr_tag_o,
	output logic			if_pb_new_instr_o,		
	
	input logic			if_pb_trap_hazard_flag_i,
	input logic			if_pb_ctrl_hazard_flag_i,
	
	output logic[AddrWidth-1:0]	if_pb_current_pc_o,
	output logic			if_pb_active_o,
	
	//Fetch unit interface
	
	input logic[AddrWidth-1:0]	if_pb_current_pc_i,
	input logic			if_pb_fu_new_instr_i,
	input logic[DataWidth-1:0]	if_pb_instr_i,
	input logic			if_pb_fu_busy_i,
	output logic			if_pb_fu_fetch_o
	
);

	logic [BufferSize-1:0][DataWidth-1:0] 	pb_buffer_mem;
	logic [$clog2(BufferSize)-1:0] 		pb_buffer_head_reg;
	logic [$clog2(BufferSize)-1:0] 		pb_buffer_tail_reg;
	logic [AddrWidth-1:0]			pb_buffer_pc_reg;
	logic [DataWidth-1:0]			pb_buffer_instr_reg;
	logic					pb_buffer_new_instr_ff;
	logic					pb_buffer_empty_int;
	logic					pb_buffer_full_int;
	logic [BufferSize-1:0] 			pb_buffer_fillmask_reg;
	
	logic					pb_fu_instr_pend_ff;
	logic					pb_instr_tag_ff;
	logic					pb_last_instr_flag_int;			//Last Instruction - New Instruction - Overlap
	logic					pb_instr_after_flush_ff;		//Reject Instruction Adter Flush
	
	logic [DataWidth-1:0]			pb_instr_int;
	logic					pb_new_instr_int;
	logic					pb_fu_fetch_int;
	logic					pb_active_int;
	logic [AddrWidth-1:0]			pb_current_pc_int;

	// 0-latency passthrough
	
	assign pb_buffer_empty_int = ~|pb_buffer_fillmask_reg;
	assign pb_buffer_full_int = &pb_buffer_fillmask_reg;
	
	always_comb begin : passthrough
	
		pb_last_instr_flag_int = pb_buffer_new_instr_ff & pb_buffer_empty_int;
		pb_fu_fetch_int = ( ~if_pb_fu_busy_i & ~pb_buffer_full_int ) ? 1'b1 : 1'b0;
		
		if( pb_active_int & (if_pb_trap_hazard_flag_i | if_pb_ctrl_hazard_flag_i) ) begin
			pb_instr_int = {{(DataWidth-8){1'b0}},8'h13}; 
		end
		else begin
			pb_instr_int = ( pb_buffer_empty_int & ~pb_buffer_new_instr_ff & if_pb_fetch_en_i ) ? if_pb_instr_i : pb_buffer_instr_reg ;	
		end
		
		pb_current_pc_int = ( pb_buffer_empty_int & ~pb_buffer_new_instr_ff & if_pb_fetch_en_i ) ? if_pb_current_pc_i : pb_buffer_pc_reg ;
		pb_new_instr_int = ( pb_buffer_empty_int & ~pb_buffer_new_instr_ff & if_pb_fetch_en_i ) ? if_pb_fu_new_instr_i : pb_buffer_new_instr_ff ;
		
	end
	
	always_ff@(posedge clk_i) begin: pb_protocol
		if( rstn_i == 1'b0 ) begin
		
			pb_buffer_mem <= '0;
			pb_buffer_head_reg <= '0;
			pb_buffer_tail_reg <= '0;
			pb_buffer_pc_reg <= '0;
			pb_buffer_fillmask_reg <= '0;
			
			pb_buffer_instr_reg <= '0;
			pb_buffer_new_instr_ff <= '0;
			
			pb_active_int <= '0;
			
			pb_fu_instr_pend_ff <= '0;
			pb_instr_tag_ff <= '0;
			pb_instr_after_flush_ff <= '0;
				
		end
		else if( (if_pb_trap_hazard_flag_i | if_pb_ctrl_hazard_flag_i) & (~pb_buffer_empty_int | pb_last_instr_flag_int) ) begin	//Flush the buffer
			
			pb_buffer_head_reg <= pb_buffer_tail_reg;
			pb_buffer_pc_reg <= '0;
			pb_buffer_fillmask_reg <= '0;
			
			pb_buffer_instr_reg <= '0;
			pb_buffer_new_instr_ff <= '0;
			
			pb_fu_instr_pend_ff <= '0;
			pb_instr_tag_ff <= '0;
			
			pb_instr_after_flush_ff <= ( if_pb_fu_new_instr_i ) ? 1'b0 : 1'b1;
		end
		else begin
		
			//Prefetch Buffer active
			if( ~pb_active_int & ~pb_buffer_empty_int ) pb_active_int <= 1'b1;
			else if( pb_active_int & pb_buffer_empty_int ) pb_active_int <= 1'b0;
			
			//Store a pending valid instruction if the buffer is full
			
			if( pb_buffer_full_int & if_pb_fu_new_instr_i ) pb_fu_instr_pend_ff <= 1'b1;
		
			//Writing into the buffer 
			
			if( ~pb_buffer_full_int ) begin						//Buffer is not full
				if( if_pb_fu_new_instr_i | pb_fu_instr_pend_ff ) begin		//FU has a new instruction and no fetch from the core has been required yet
				
					if( (~if_pb_fetch_en_i & pb_buffer_empty_int ) | ~pb_buffer_empty_int | pb_last_instr_flag_int ) begin 
					
						if( pb_buffer_empty_int ) begin							//First write into the buffer
							pb_buffer_pc_reg <= if_pb_current_pc_i - 4;
						end
						
						pb_buffer_mem[pb_buffer_head_reg] <= if_pb_instr_i;
						pb_buffer_fillmask_reg[pb_buffer_head_reg] <= 1'b1;
						pb_buffer_head_reg <= pb_buffer_head_reg + 1;		
						
						pb_fu_instr_pend_ff <= '0;	
					end

				end			
			end
			
			//Reading from the buffer
			
			if( if_pb_fetch_en_i ) begin
			
				if( ~pb_buffer_empty_int ) begin								//Buffer is not empty
					pb_buffer_instr_reg <= pb_buffer_mem[pb_buffer_tail_reg];
					pb_buffer_fillmask_reg[pb_buffer_tail_reg] <= 1'b0;
					pb_buffer_pc_reg <= pb_buffer_pc_reg + 4;
					pb_buffer_tail_reg <= pb_buffer_tail_reg + 1;
					pb_buffer_new_instr_ff <= 1'b1 ;
					pb_instr_tag_ff <= 1'b1;
					
				end
				else begin 
					pb_buffer_new_instr_ff <= 1'b0 ;
					pb_instr_tag_ff <= 1'b0;
				end
			end
			else  begin pb_buffer_new_instr_ff <= 1'b0 ; end
			
			//Reset Reject Instruction After Flush FF
			
			pb_instr_after_flush_ff <= 1'b0;
			
		
		end
	end
	
	assign if_pb_instr_o = pb_instr_int;
	assign if_pb_new_instr_o = pb_new_instr_int & ~pb_instr_after_flush_ff;
	assign if_pb_fu_fetch_o = pb_fu_fetch_int;
	assign if_pb_current_pc_o = pb_current_pc_int;
	assign if_pb_active_o = pb_active_int;
	assign if_pb_instr_tag_o = pb_instr_tag_ff;

endmodule;




