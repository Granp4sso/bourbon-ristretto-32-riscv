//`include "beta_def.sv"

/*
	Version 0.2
	26/04/2022
		-It takes opB + 2 clock cycles to complete the entire Shift Instruction cycle.
		-It takes 1 clock cyckes to shift 0 and 1


*/

module beta_shift_unit import beta_pkg::*; #()
(
	input logic 		clk_i,
	input logic 		rstn_i,

	input logic[XLEN-1:0] 	operand_a_i,
	input logic[4:0] 	operand_b_i,
	input logic[1:0] 	shu_mode_i,
	input logic	 	shu_en_i,

	output 			shu_busy_o,
	output logic[XLEN-1:0] 	shu_result_o

);

	logic 		shu_busy_int;
	logic[XLEN-1:0] shu_result_int;
	logic[4:0] 	shiftreg_cnt_int;
	logic		shu_end;

	always_ff@(posedge clk_i) begin: shift_proc
		if( rstn_i == 1'b0 ) begin

			shu_result_int <= '0;
			shu_busy_int <= 1'b0;
			shiftreg_cnt_int <= '0;
			shu_end <= 1'b0;

		end
		else if( shu_en_i == 1'b1 & shu_end == 1'b0 ) begin
			shu_busy_int <= 1'b1;
			if( shu_mode_i == SHIFT_LEFT ) begin
				if(shiftreg_cnt_int == '0) begin
					shu_result_int <= {operand_a_i[XLEN-2:0],1'b0};
				end
				else begin
					shu_result_int <= {shu_result_int[XLEN-2:0],1'b0};
				end
				shiftreg_cnt_int <= shiftreg_cnt_int+5'h01;
			end

			else if( shu_mode_i == SHIFT_RIGHT ) begin //Right Shift
				if(shiftreg_cnt_int == '0) begin
					shu_result_int <= {1'b0,operand_a_i[XLEN-1:1]};
				end
				else begin
					shu_result_int <= {1'b0,shu_result_int[XLEN-1:1]};
				end
				shiftreg_cnt_int <= shiftreg_cnt_int+5'h01;
			end

			else if( shu_mode_i == SHIFT_ARIGHT ) begin //Right Arithmetic Shift
				if(shiftreg_cnt_int == 0) begin
					shu_result_int <= ( operand_a_i[XLEN-1] == 1'b1 ) ? {1'b1,operand_a_i[XLEN-1:1]} : {1'b0,operand_a_i[XLEN-1:1]};
				end
				else begin
					shu_result_int <= ( operand_a_i[XLEN-1] == 1'b1 ) ? {1'b1,shu_result_int[XLEN-1:1]} : {1'b0,shu_result_int[XLEN-1:1]};
				end
				shiftreg_cnt_int <= shiftreg_cnt_int+5'h01;
			end


			if( shiftreg_cnt_int >= operand_b_i - 1) begin
				
				shu_end <= 1'b1;
				shu_busy_int <= 1'b0; 
				shiftreg_cnt_int <= '0;
				
			end
		end
		else begin
			shu_busy_int <= 1'b0;
			shiftreg_cnt_int <= '0;
			shu_end <= 1'b0;
		end
	end


	assign shu_busy_o = shu_busy_int;
	assign shu_result_o = shu_result_int;


endmodule;
