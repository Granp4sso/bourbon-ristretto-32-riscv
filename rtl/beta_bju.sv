
/*
	Branch & Jump Unit v0.4 27/08/2022

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	-AddrWidth :		Width of addresses
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	
	-bju_pc_i :			The execution stage current program counter.
	-bju_offset12_i :		The 12 bit offset coming from the decode stage (used for Branches and JALRs)
	-bju_offset20_i :		The 20 bit offset coming from the decode stage (used for JALs)
	-bju_basereg_i :		The base register used for branches and jalrs.
	-bju_alu_stat_i :		ALU status bits, used to evaluate branches
	-bju_op_i :			Bju required operation (control signal). 00 none, 01 branch, 10 jal, 11 jalr
	-bju_misalig_pc_o :		Misaligned address has been computed
	-bju_next_pc_o :		Next program counter. It will be sent to the Instruction Fetch stage
	-bju_branch_taken_o :		If a branch has been taken, it will be 1.

	******|| REMARKABLE 	||******
	
	bju_misalig_address:
	
		If the lower two bits of the new PC are different from 00 raise an exception
		
	bju_compute_next_pc:
	
		This process elaborates the next pc based on the required operation.


	******|| NOTES		||******

	The BJU takes the offset, the PC and the alu status. It reads from the control words which alu status bit has to be evaluated and
	if it must be taken as set or reset. In this way we can compute all branches conditions only using 3 bits. 
	If bju_en = 00, current PC will be the output. PS: PC+4 will be computed into the exe stage externally to the BJU unit.

	BRANCHES : 	Takes offset_12, sign extend it and then adds it to the PC
	JAL : 		Takes offset_20, sign extend it and then adds it to the PC
	JALR : 		JALR can work exactly as a JAL but we must take the rs1 data. Therefore we can drive operand_a signal into BJU as well.

	Branches and Jump addresses have bit 0 forced to 0 (2 alignment). an exception will be raised in case of misaligned addresses
	(not aligned on a power of 4)

*/


module beta_bju import beta_pkg::*; #(
	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32
)
(
	input logic 			clk_i,
	input logic			rstn_i,

	input logic[DataWidth-1:0] 	bju_pc_i,
	input logic[11:0]		bju_offset12_i,
	input logic[19:0]		bju_offset20_i,
	input logic[DataWidth-1:0]	bju_basereg_i,
	input exe_alu_status_t		bju_alu_stat_i,
	input exe_bju_op_t		bju_op_i,

	output logic			bju_misalig_pc_o,
	output logic[DataWidth-1:0] 	bju_next_pc_o,
	output logic 			bju_branch_taken_o
	
);
	logic[DataWidth-1:0] 	bju_next_pc_int;
	logic[DataWidth-1:0] 	bju_selected_data_int;
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
	assign bju_next_pc_o = ( bju_misalig_pc_int ) ? bju_pc_i : bju_next_pc_int;


endmodule;
