//`include "beta_def.sv"

/*
26/04/2022
Version 0.7
	-Shift operations is now supported by a dedicated unit, and made external
	-Alu operations could be encoded (only one operation at a time can be carried out by the alu)
	-Combinatorial atm
	-ALU should support the following base operations:
		-- Add -V
		-- Sub -V
		-- right Shift -V (every shift takes opB + 2 clock cycles)
		-- left Shift -V (every shift takes opB + 2 clock cycles)
		-- Logic OR -V
		-- Logic XOR -V
		-- Logic AND -V

		Status
		--Zero flag -V
		--Negative signed flag -V
		--Negative unsigned flag -V (it shall be correct)
		--Overflow flag -X

		Opcode supported:
		--ADDI,SLTI,SLTIU,XORI,ORI,ANDI,SLLI,SRLI,SRAI,ADD,SUB,SLL,SLT,SLTU,XOR,SRL,SRA,OR,AND,LUI,

		Opcode partially-supported:
		--AUIPC can be supported calculatng LUI in the ALU and optionally adding it to the PC externally
		  it requires the control word to specify a bit for that anyway.
		--Branches are actually supported as well as long as PC + offset are computed into the branch unit
		--Jumps are actually supported externally to ALU

		Opcode Unsupported:
		--LB,LW,LH,LBU,BHU,SB,SH,SW,FENCE


	-Adder is implemented with + operator, but I could implement a Log adder

	-
*/

module beta_alu import beta_pkg::*; #()
(

	input logic 		clk_i,
	input logic 		rstn_i,

	//Alu Input Interface

	input logic[XLEN-1:0] 	operand_a_i,
	input logic[XLEN-1:0] 	operand_b_i,
	input exe_alu_op_t 	operation_i,

	//Alu Output Interface

	output exe_alu_status_t alu_stat_o,
	output logic 		alu_op_end_o,
	output logic[XLEN-1:0] 	alu_result_o

);

	logic [XLEN-1:0] 	op_result_int;
	logic [XLEN-1:0] 	status_comp_data;


	logic 			alu_int_end;
	logic 			status_flag_int;
	exe_alu_status_t 	alu_stat_int;

	assign alu_result_o = op_result_int;
	assign alu_op_end_o = alu_int_end ;
	assign alu_stat_o = alu_stat_int;


	always_comb begin : alu_stat_flag

		status_comp_data = operand_a_i + (~operand_b_i + 1);

		if( status_comp_data == '0 ) begin
			alu_stat_int.zero = 1'b1;
			alu_stat_int.overflow = 1'b0;
			alu_stat_int.negative = 1'b0;
		end
		else if( operation_i.exe_alu_unsigned_n_en == 1'b0 ) begin
			if ( status_comp_data[XLEN-1] == 1'b1 ) begin //A < B
				alu_stat_int.zero = 1'b0;
				alu_stat_int.overflow = 1'b0;
				alu_stat_int.negative = 1'b1;
			end
			else begin
				alu_stat_int.zero = 1'b0;
				alu_stat_int.overflow = 1'b0;
				alu_stat_int.negative = 1'b0;
			end
		end
		else if( operation_i.exe_alu_unsigned_n_en == 1'b1 ) begin
			if ( (status_comp_data[XLEN-1] & operand_b_i[XLEN-1]) | (status_comp_data[XLEN-1] & ~operand_a_i[XLEN-1]) | (~operand_a_i[XLEN-1] & operand_b_i[XLEN-1])) begin //unsigned condition for negative bit
				alu_stat_int.zero = 1'b0;
				alu_stat_int.overflow = 1'b0;
				alu_stat_int.negative = 1'b1;
			end
			else begin
			alu_stat_int.zero = 1'b0;
			alu_stat_int.overflow = 1'b0;
			alu_stat_int.negative = 1'b0;
			end
		end
		else begin
			alu_stat_int.zero = 1'b0;
			alu_stat_int.overflow = 1'b0;
			alu_stat_int.negative = 1'b0;
		end

	end;

	always_comb begin : alu_op

		alu_int_end = 1'b1;

		//Arithmetic
		if( operation_i.exe_alu_add_en == 1'b1 ) begin
			op_result_int = operand_a_i + operand_b_i;
		end
		else if( operation_i.exe_alu_sub_en == 1'b1 ) begin
			op_result_int = operand_a_i + (~operand_b_i + 1);
		end

		//Logic
		else if( operation_i.exe_alu_logic_en == 2'b01 ) begin //AND
			op_result_int = operand_a_i & operand_b_i;
		end
		else if( operation_i.exe_alu_logic_en == 2'b10 ) begin //OR
			op_result_int = operand_a_i | operand_b_i;
		end
		else if( operation_i.exe_alu_logic_en == 2'b11 ) begin //XOR
			op_result_int = operand_a_i ^ operand_b_i;
		end
		else begin
			op_result_int = operand_a_i;
		end 
		
	end;

endmodule;
