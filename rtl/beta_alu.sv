
/*
	ALU v0.8 27/08/2022

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	-AddrWidth :		Width of addresses
	
	******|| INTERFACES 	||******

	-clk_i and rstn_i are used to drive the clock signal and the reset one respectively.
	
	-alu_operand_a_i :		First operand provided by the decode stage (Usually register data)
	-alu_operand_b_i :		Second operand provided by the decode stage (Register data or Immediate)
	-alu_op_i :			ALU operation required. This is a control signal coming from the decode stage, urom.
	-alu_stat_o :			3 bits pointing to the ALU status (Zero, Overflow, Negative)
	-alu_op_end_o :			Alu ended its operation. It is useless atm because ALU is combinatorial, hence it always take a single clock cycle to complete.
	-alu_result_o :			The result produced according to the operation required.

	******|| REMARKABLE 	||******

	alu_stat_flag:
	
		ALU has a series of flags. The are used to compute branch conditions outside the ALU.
		This process must take into account signed and unsigned operations to properly set the flags.
	alu_op:
		
		This process computes the ALU result depending on the specific operation required. If none is selected, the operand_a (usually a source register) is passed unmodified

	******|| NOTES		||******

	ALU supports the following base operations: ADD, SUB, OR, XOR, AND, ADDI, SLTI, SLTIU, XORI, ORI, ANDI.
	LUI and AUIPC are supported as well. In fact, AUIPC uses the same LUI path except for a PC sum.
	Branches & Jumps are handled by the bju, while memory transactions are handled into the LSU.
	Adder is implemented with + operator, but for an ASIC implementation a proper Log adder coul be instantiated.
	Overflow bit is never used atm.
	ALU_op_end is basically useless.

*/

module beta_alu import beta_pkg::*; #(

	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32

)
(

	input logic 			clk_i,
	input logic 			rstn_i,
	
	//Alu Input Interface

	input logic[DataWidth-1:0] 	alu_operand_a_i,
	input logic[DataWidth-1:0] 	alu_operand_b_i,
	input exe_alu_op_t 		alu_op_i,

	//Alu Output Interface

	output exe_alu_status_t 	alu_stat_o,
	output logic 			alu_op_end_o,
	output logic[DataWidth-1:0] 	alu_result_o

);

	logic [DataWidth-1:0] 		op_result_int;
	logic [DataWidth-1:0] 		status_comp_data;


	logic 				alu_int_end;
	logic 				status_flag_int;
	exe_alu_status_t 		alu_stat_int;

	assign alu_result_o = op_result_int;
	assign alu_op_end_o = alu_int_end ;
	assign alu_stat_o = alu_stat_int;


	always_comb begin : alu_stat_flag

		status_comp_data = alu_operand_a_i + (~alu_operand_b_i + 1);

		if( status_comp_data == '0 ) begin					//Evaluating Zero Flag
			alu_stat_int.zero = 1'b1;
			alu_stat_int.overflow = 1'b0;
			alu_stat_int.negative = 1'b0;
		end
		else if( alu_op_i.exe_alu_unsigned_n_en == 1'b0 ) begin			//Evaluating Negative Flag
			if ( status_comp_data[DataWidth-1] == 1'b1 ) begin //A < B
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
		else if( alu_op_i.exe_alu_unsigned_n_en == 1'b1 ) begin
			if ( (status_comp_data[DataWidth-1] & alu_operand_b_i[DataWidth-1]) | (status_comp_data[DataWidth-1] & ~alu_operand_a_i[DataWidth-1]) | (~alu_operand_a_i[DataWidth-1] & alu_operand_b_i[DataWidth-1])) begin //unsigned condition for negative bit
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
		if( alu_op_i.exe_alu_add_en == 1'b1 ) begin			//ADD
			op_result_int = alu_operand_a_i + alu_operand_b_i;
		end
		else if( alu_op_i.exe_alu_sub_en == 1'b1 ) begin		//SUB
			op_result_int = alu_operand_a_i + (~alu_operand_b_i + 1);
		end

		//Logic
		else if( alu_op_i.exe_alu_logic_en == 2'b01 ) begin 		//AND
			op_result_int = alu_operand_a_i & alu_operand_b_i;
		end
		else if( alu_op_i.exe_alu_logic_en == 2'b10 ) begin 		//OR
			op_result_int = alu_operand_a_i | alu_operand_b_i;
		end
		else if( alu_op_i.exe_alu_logic_en == 2'b11 ) begin 		//XOR
			op_result_int = alu_operand_a_i ^ alu_operand_b_i;
		end
		else begin
			op_result_int = alu_operand_a_i;
		end 
		
	end;

endmodule;
