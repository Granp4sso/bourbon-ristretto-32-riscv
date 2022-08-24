/*
	Load & Store unit v 0.1
	13/05/2022

	
	-The Data Memory protocol will is basically the same for read and write 
		--Once the lsu_en_i raises, a new request will be forwarded to the dmem: LOAD - rdata_req_o, or STORE - wdata_req_o
		--addresses, strobe and eventually data must be changed by the lsu, an so is the busy signal.
		--The dmem will send a ready_i signal to notify that the request has been accepteed. (strb,addr and eventually data are latched by the dmem)
		--Once the valid_i signal is high (for exactly one clock cycle), the data_i will be captured from the lsu in case of store.
		--busy signal can now be lowered
		--If a memory error occurs the LSU can bear an exception an lower the busy signal. (probably an exception busy signal will
		  be asserted somewhere else).



*/

module beta_lsu import beta_pkg::*; #(
	parameter unsigned DataWidth = 32,
	parameter unsigned AddressWidth = 32
)(
	input  logic 			clk_i,
	input  logic 			rstn_i,

	/*Operand Port*/
	input  logic[DataWidth-1:0] 	op_data_i,
	input  logic[AddressWidth-1:0] 	op_addr_i,

	/*Read Data Memory Port*/
	input  logic			rdata_ready_i,
	input  logic			rdata_valid_i,
	input  logic[DataWidth-1:0] 	rdata_data_i,
	output logic[AddressWidth-1:0] 	rdata_addr_o,
	output logic[DataWidth/8-1:0]	rdata_strb_o,
	output logic 			rdata_req_o,

	/*Write Data Memory Port*/
	input  logic			wdata_ready_i,
	input  logic			wdata_valid_i,
	output logic[DataWidth-1:0] 	wdata_data_o,
	output logic[AddressWidth-1:0] 	wdata_addr_o,
	output logic[DataWidth/8-1:0]	wdata_strb_o,
	output logic 			wdata_req_o,

	/*Error Data Memory Port*/
	
	/*Misaligned Address Exception*/
	
	output logic[1:0]		lsu_misalig_op_o,
	output logic[AddressWidth-1:0]	lsu_invalid_addr_o,

	/*Exe Control Unit Port*/
	input  logic[1:0] 		lsu_op_size_i,
	input  logic 			lsu_op_i,
	input  logic 			lsu_op_en_i,
	input  logic[11:0]		lsu_woffset_i,
	output logic 			lsu_busy_o,

	output logic[DataWidth-1:0] 	lsu_result_o

);

	logic[AddressWidth-1:0] 	rdata_addr_int;
	logic[DataWidth/8-1:0]		rdata_strb_int;
	logic 				rdata_req_int;

	logic[DataWidth-1:0] 		wdata_data_int;
	logic[AddressWidth-1:0] 	wdata_addr_int;
	logic[DataWidth/8-1:0]		wdata_strb_int;
	logic 				wdata_req_int;

	logic [1:0]			lsu_misalig_op_int;
	logic 				lsu_misalig_flag_int;
	logic 				lsu_busy_int;
	logic[DataWidth-1:0] 		lsu_result_int;
	
	
	/* Misaligned store/loads path */
	
	logic [DataWidth-1:0] evaluating_addr_int;
	
	always_comb begin: misaligned_load_store

		evaluating_addr_int = ( lsu_op_i == MEM_LOAD_OP ) ? op_addr_i : woffset_addr_int;
		
		case(lsu_op_size_i)
			MEM_SIZE_WORD : lsu_misalig_flag_int = ( evaluating_addr_int[1] | evaluating_addr_int[0] ) ? 1'b1 : 1'b0;	//Word
			MEM_SIZE_HALF : lsu_misalig_flag_int = ( evaluating_addr_int[0] ) ? 1'b1 : 1'b0; 				//Half Word
			default : lsu_misalig_flag_int = 1'b0;
		endcase
		
		lsu_misalig_op_int[0] = ( lsu_op_i == MEM_LOAD_OP ) ? lsu_misalig_flag_int : 1'b0;
		lsu_misalig_op_int[1] = ( lsu_op_i == MEM_STORE_OP ) ? lsu_misalig_flag_int : 1'b0;
	
	end
	
	assign lsu_invalid_addr_o = evaluating_addr_int;

	/*Read Data Memory Protocol*/

	logic[rdmem_fsm_bsize-1:0] rdmem_state;

	always_ff@(posedge clk_i) begin: dmem_read_protocol
		if(rstn_i == 1'b0) begin

			rdata_addr_int <= '0;
			rdata_strb_int <= '0;
			rdata_req_int <= '0;
			lsu_busy_int <= '0;
			lsu_result_int <= '0;

			rdmem_state <= RDMEM_IDLE;
		end
		else begin
			case(rdmem_state)

			RDMEM_IDLE: begin
				if(lsu_op_en_i & lsu_op_i == MEM_LOAD_OP) begin
					lsu_busy_int <= 1'b1;
					rdata_req_int <= 1'b1;
					rdata_addr_int <= op_addr_i;
					case (lsu_op_size_i)
						MEM_SIZE_WORD : rdata_strb_int <= 4'b1111;	//Word
						MEM_SIZE_HALF : rdata_strb_int <= 4'b0011; 	//Half Word
						MEM_SIZE_BYTE : rdata_strb_int <= 4'b0001;  	//Byte
						default : rdata_strb_int <= 4'b0000;  		//N/A
					endcase
					rdmem_state <= RDMEM_WRDY;
				end
			end

			RDMEM_WRDY: begin
				if(rdata_ready_i) begin
					rdata_req_int <= 1'b0;
					rdmem_state <= RDMEM_WVLD;		
				end
			end

			RDMEM_WVLD: begin
				if(rdata_valid_i) begin
					lsu_busy_int <= 1'b0;
					lsu_result_int <= rdata_data_i;
					rdmem_state <= RDMEM_IDLE;		
				end
			end
			default: rdmem_state <= RDMEM_IDLE;
			endcase
			
		end
	end

	/*Write Data Memory Protocol*/

	logic[wdmem_fsm_bsize-1:0] wdmem_state;
	logic[DataWidth-1:0] woffset_int;
	logic[DataWidth-1:0] woffset_addr_int;

	assign woffset_int = (lsu_woffset_i[11]) ? {20'hfffff,lsu_woffset_i} : {20'h00000,lsu_woffset_i}; //Sign extended store offset
	assign woffset_addr_int = op_addr_i + woffset_int;

	always_ff@(posedge clk_i) begin: wdmem_read_protocol
		if(rstn_i == 1'b0) begin

			wdata_data_int <= '0;
			wdata_addr_int <= '0;
			wdata_strb_int <= '0;
			wdata_req_int <= '0;
			lsu_busy_int <= '0;
			lsu_result_int <= '0;

			wdmem_state <= WDMEM_IDLE;
		end
		else begin
			case(wdmem_state)

			WDMEM_IDLE: begin
				if(lsu_op_en_i & lsu_op_i == MEM_STORE_OP) begin
					lsu_busy_int <= 1'b1;
					wdata_req_int <= 1'b1;
					wdata_data_int <= op_data_i;
					wdata_addr_int <= woffset_addr_int ;
					case (lsu_op_size_i)
						MEM_SIZE_WORD : wdata_strb_int <= 4'b1111;	//Word
						MEM_SIZE_HALF : wdata_strb_int <= 4'b0011; 	//Half Word
						MEM_SIZE_BYTE : wdata_strb_int <= 4'b0001;  	//Byte
						default : wdata_strb_int <= 4'b0000;  		//N/A
					endcase
					wdmem_state <= WDMEM_WRDY;
				end
			end

			WDMEM_WRDY: begin
				if(wdata_ready_i) begin
					wdata_req_int <= 1'b0;
					wdmem_state <= WDMEM_WVLD;		
				end
			end

			WDMEM_WVLD: begin
				if(wdata_valid_i) begin
					lsu_busy_int <= 1'b0;
					lsu_result_int <= '0;
					wdmem_state <= WDMEM_IDLE;		
				end
			end
			default: wdmem_state <= WDMEM_IDLE;
			endcase
			
		end
	end



	assign rdata_addr_o = rdata_addr_int;
	assign rdata_strb_o = rdata_strb_int;
	assign rdata_req_o = rdata_req_int;

	assign wdata_data_o = wdata_data_int;
	assign wdata_addr_o = wdata_addr_int;
	assign wdata_strb_o = wdata_strb_int;
	assign wdata_req_o = wdata_req_int;

	assign lsu_busy_o = lsu_busy_int;
	assign lsu_result_o = lsu_result_int;
	assign lsu_misalig_op_o = lsu_misalig_op_int;

endmodule
