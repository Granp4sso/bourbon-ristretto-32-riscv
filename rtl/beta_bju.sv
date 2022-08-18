//s`include "beta_def.sv"

/*
8/05/2022
Version 0.3

	Corrected some bugs

	Branch & Jump unit
	-It takes the offset, the PC and the alu status. It reads from the control words which alu status bit has to be evaluated and
	 if it must be taken as set or reset. It computes the next program counter sent to the PC.
	-If bju_en = 00, PC will be output. PS: PC+4 will be computed into the exe stage externally to the BJU unit because it is also used 
	 as a possible result, hence it must be computed in parallel.

	-Predictors might be instantiated here

	-Exception path will interact with BJU

	-At the moment I forsee 2 offsets, 12 and 20 bits long, respectively for branches and jumps. in future I'd like to support a single
	 20 bits offset and interpret it as a 12 or 20 bits depending on the specific kind of control (b or j)

	BRANCHES
	-Takes offset_12, sign extend it and then adds it to the PC

	JAL
	-Takes offset_20, sign extend it and then adds it to the PC

	JALR
	-JALR can work exactly as a JAL but we must take the rs1 data. Therefore we can drive operand_a signal into BJI as well.

	-Handled Branches and base Jump bit 0 forced to 0 (2 alignemnt). an exception will be raised in case of misaligned addresses
	 (not aligned on a power of 4)
*/


module beta_bju import beta_pkg::*; #(
	parameter integer unsigned DATAWIDTH = 32
)
(
	input logic 			clk_i,
	input logic			rstn_i,

	input logic[DATAWIDTH-1:0] 	bju_pc_i,
	input logic[11:0]		bju_offset12_i,
	input logic[19:0]		bju_offset20_i,
	input logic[DATAWIDTH-1:0]	bju_basereg_i,
	input exe_alu_status_t		bju_alu_stat_i,
	input exe_bju_op_t		bju_op_i,

	output logic			bju_misalig_pc_o,
	output logic[DATAWIDTH-1:0] 	bju_next_pc_o,
	output logic 			bju_branch_taken_o
	
);
	logic[DATAWIDTH-1:0] 	bju_next_pc_int;
	logic[DATAWIDTH-1:0] 	bju_selected_data_int;
	logic			bju_branch_taken_int;
	logic			bju_misalig_pc_int;

	always_comb begin: bju_misalig_address
	
		bju_misalig_pc_int = bju_next_pc_int[1] | bju_next_pc_int[0];
	end
	
	always_comb begin: bju_compute_next_pc
	
		case(bju_op_i.exe_bju_en)
			2'b00: 	begin
					bju_selected_data_int = '0;
					bju_branch_taken_int = 1'b0;
				end					
			2'b01:  begin //Branches
				if(bju_alu_stat_i[bju_op_i.exe_bju_condition_sel] == ~bju_op_i.exe_bju_condition_neg) begin
					bju_selected_data_int = (bju_offset12_i[11] == 1'b1 ) ? {19'h7ffff,bju_offset12_i,1'b0} : {19'h00000,bju_offset12_i,1'b0};	
					bju_branch_taken_int = 1'b1;
				end else begin
					bju_selected_data_int = 32'h4;
					bju_branch_taken_int = 1'b0;	
				end
			end
			2'b10:	begin
				bju_selected_data_int = (bju_offset20_i[19] == 1'b1 ) ? {11'h7ff,bju_offset20_i,1'b0} : {11'h000,bju_offset20_i,1'b0};	
				bju_branch_taken_int = 1'b0;	
			end
			2'b11:	begin
				bju_selected_data_int = (bju_offset20_i[19] == 1'b1 ) ? {20'hfffff,bju_offset12_i} + bju_basereg_i : {20'h00000,bju_offset12_i} + bju_basereg_i;
				bju_branch_taken_int = 1'b0;		
			end
		endcase;
		
	end

	assign bju_next_pc_int = (&bju_op_i.exe_bju_en) ? bju_selected_data_int : bju_pc_i + bju_selected_data_int - 32'h00000004; //In case of JALR do not add to pc
	assign bju_branch_taken_o = bju_branch_taken_int;
	assign bju_misalig_pc_o = bju_misalig_pc_int;
	assign bju_next_pc_o = ( bju_misalig_pc_int ) ? bju_pc_i + 32'h00000004 : bju_next_pc_int;






endmodule;
