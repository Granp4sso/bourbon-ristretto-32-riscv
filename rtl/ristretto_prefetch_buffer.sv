`include "pkg/ristretto_if_stage_pkg.sv"

/*
	Prefetch Buffer v0.1 01/11/2022

	******|| INSTANTIABLES 	||******
						- CodeType,	Mandatory,	Supported
		-N/A				- [N/A		N/A		N/A	]

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.

	******|| REMARKABLE 	||******


	******|| NOTES		||******



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
	output logic			if_pb_busy_o,
	output logic[1:0]		if_pb_penality_o,		
	
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

	logic [BufferSize-1:0][DataWidth-1:0] 	buffer_mem_int;
	logic [$clog2(BufferSize)-1:0] 		buffer_head_int;
	logic [$clog2(BufferSize)-1:0] 		buffer_tail_int;
	logic [$clog2(BufferSize)-1:0] 		buffer_headinc_int;
	logic [AddrWidth-1:0]			buffer_pc_int;
	
	logic 				if_pb_busy_int;
	logic[DataWidth-1:0]		buffer_instr_int;
	logic[DataWidth-1:0]		instr_int;
	logic				buffer_new_instr_int;
	logic				new_instr_int;
	logic				pb_fu_fetch_int;
	logic				pb_race_cond_int;
	
	logic				buffer_empty_int;
	logic				buffer_full_int;
	
	logic				pb_active_int;
	
	logic [AddrWidth-1:0]		current_pc_int;
	
	/* Test area */
	
	logic [BufferSize-1:0] 		test_buffer_fillmask_int;
	logic				test_pb_fu_pendinginstr_int;
	
	logic				test_pb_instr_tag_int;
	
	// 0-latency passthrough
	
	assign buffer_empty_int = ~|test_buffer_fillmask_int;//( buffer_head_int == buffer_tail_int );
	//assign buffer_headinc_int = buffer_head_int + 1;
	assign buffer_full_int = &test_buffer_fillmask_int;//( ( buffer_headinc_int ) == buffer_tail_int );
	
	always_comb begin : passthrough
	
		pb_fu_fetch_int = ( ~if_pb_fu_busy_i & ~buffer_full_int ) ? 1'b1 : 1'b0;
		
		if( pb_active_int & (if_pb_trap_hazard_flag_i | if_pb_ctrl_hazard_flag_i) ) begin
			//Se il flag è alto contemporaneamente all'fu fetch, non cambiare niente (usare l'fu state forse sarebbe meglio)
			//in caso contrario inietta una NOP nella pipe e il pc - 4.
			instr_int = {{(DataWidth-8){1'b0}},8'h13}; //( buffer_empty_int & ~buffer_new_instr_int & if_pb_fetch_en_i ) ? if_pb_instr_i : buffer_instr_int ;
			//current_pc_int = if_pb_current_pc_i - 4 ;
		end
		else begin
			instr_int = ( buffer_empty_int & ~buffer_new_instr_int & if_pb_fetch_en_i ) ? if_pb_instr_i : buffer_instr_int ;	
		end
		
		current_pc_int = ( buffer_empty_int & ~buffer_new_instr_int & if_pb_fetch_en_i ) ? if_pb_current_pc_i : buffer_pc_int ;
		new_instr_int = ( buffer_empty_int & ~buffer_new_instr_int & if_pb_fetch_en_i ) ? if_pb_fu_new_instr_i : buffer_new_instr_int ;
		
	end
	
	always_ff@(posedge clk_i) begin: imem_protocol
		if( rstn_i == 1'b0 ) begin
		
			buffer_mem_int <= '0;
			buffer_head_int <= '0;
			buffer_tail_int <= '0;
			buffer_pc_int <= '0;
			test_buffer_fillmask_int <= '0;
			
			buffer_instr_int <= '0;
			buffer_new_instr_int <= '0;
			
			pb_race_cond_int <= '0;
			
			pb_active_int <= '0;
			
			test_pb_fu_pendinginstr_int <= '0;
			test_pb_instr_tag_int <= '0;
			
			
		end
		else if( (if_pb_trap_hazard_flag_i | if_pb_ctrl_hazard_flag_i) & ~buffer_empty_int ) begin	//Flush the buffer
			buffer_mem_int <= '0;
			buffer_head_int <= '0;
			buffer_tail_int <= '0;
			buffer_pc_int <= '0;
			test_buffer_fillmask_int <= '0;
			
			buffer_instr_int <= '0;
			buffer_new_instr_int <= '0;
			
			pb_race_cond_int <= '0;
			
			test_pb_fu_pendinginstr_int <= '0;
			test_pb_instr_tag_int <= '0;
		end
		else begin
		
			//Prefetch Buffer active
			if( ~pb_active_int & ~buffer_empty_int ) pb_active_int <= 1'b1;
			else if( pb_active_int & buffer_empty_int ) pb_active_int <= 1'b0;
			
			//Store a pending valid instruction if the buffer is full
			
			if( buffer_full_int & if_pb_fu_new_instr_i ) test_pb_fu_pendinginstr_int <= 1'b1;
		
			//Writing into the buffer 
			
			if( ~buffer_full_int ) begin							//Buffer is not full
				if( if_pb_fu_new_instr_i | test_pb_fu_pendinginstr_int) begin		//FU has a new instruction and no fetch from the core has been required yet
				
					if( (~if_pb_fetch_en_i & buffer_empty_int ) | ~buffer_empty_int ) begin /*& ( pb_race_cond_int | ~if_pb_fetch_en_i )*/
					
						if( buffer_empty_int ) begin							//First write into the buffer
							buffer_pc_int <= if_pb_current_pc_i - 4;
							pb_race_cond_int <= 1'b1;
						end
						
						buffer_mem_int[buffer_head_int] <= if_pb_instr_i;
						test_buffer_fillmask_int[buffer_head_int] <= 1'b1;
						buffer_head_int <= buffer_head_int + 1;		
						
						test_pb_fu_pendinginstr_int <= '0;	
						
						if( if_pb_fu_new_instr_i & if_pb_fetch_en_i ) pb_race_cond_int <= 1'b0;		//handling last overlapping instruction
					end

				end			
			end
			
			//Reading from the buffer
			
			//buffer_instr_int <= if_pb_instr_i ;
			
			if( if_pb_fetch_en_i ) begin
			
				if( ~buffer_empty_int ) begin								//Buffer is not empty
					buffer_instr_int <= buffer_mem_int[buffer_tail_int];
					test_buffer_fillmask_int[buffer_tail_int] <= 1'b0;
					buffer_pc_int <= buffer_pc_int + 4;
					buffer_tail_int <= buffer_tail_int + 1;
					buffer_new_instr_int <= 1'b1 ;
					test_pb_instr_tag_int <= 1'b1;
					
				end
				else begin 
					buffer_new_instr_int <= 1'b0 ;
					test_pb_instr_tag_int <= 1'b0;
				end
			end
			else  begin buffer_new_instr_int <= 1'b0 ; end
			//else if( buffer_new_instr_int ) begin buffer_new_instr_int <= 1'b0 ; end
			
			//if( buffer_new_instr_int ) begin buffer_new_instr_int <= 1'b0 ; end
			
			
			
			
		end
	end
	
	assign if_pb_instr_o = instr_int;
	assign if_pb_new_instr_o = new_instr_int;
	assign if_pb_busy_o = 0;
	assign if_pb_penality_o = '0;
	assign if_pb_fu_fetch_o = pb_fu_fetch_int;
	assign if_pb_current_pc_o = current_pc_int;
	assign if_pb_active_o = pb_active_int;
	assign if_pb_instr_tag_o = test_pb_instr_tag_int;

endmodule;




