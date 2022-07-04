//`include "pkg/beta_pkg.sv"

/*
	Global Pipeline Control Unit v0.1 27/06/2022

	******|| INSTANTIABLES 	||******

	******|| PARAMETERS 	||******

	-DataWidth :		Width of data lines (32 bits or 64 bits)
	-StageNum :		Number of pipeline stages (3 in Bourbon)
	
	******|| INTERFACES 	||******


	******|| REMARKABLE 	||******

	

	******|| NOTES		||******

	The Pipeline control unit is responsible for the Pipeline syncronization and Hazard detection.
	It will host N ports, where N is the number of pipeline stages. Eache stage will at least support the flush and stall signals.
	The pipeline is quite inefficient at the moment, because the pip0_stall toggles quite too often uselessly. Moreover, many fetches are performed
	from the imem, while they are not require. The pipeline still works because the instruction address does not change.
	


*/

module beta_pipeline_control_unit import beta_pkg::*; #(

	parameter unsigned DataWidth = 32,
	parameter unsigned StageNum = 3		//Atm it is not that useful
)(

	input  logic 			clk_i,
	input  logic 			rstn_i,

	/* Fetch Stage Signals */

	input  logic			pcu_ifs_busy_i,
	output logic			pcu_ifs_fetch_en_o,

	/* Decode Stage signals */

	input  logic			pcu_decs_busy_i,

	/* Execution Stage signals */

	input  logic			pcu_exes_busy_i,

	/* Pipe if-to-dec signals */

	output logic			pcu_pip0_stall_o,
	output logic			pcu_pip0_flush_o,

	/* Pipe dec-to-exe signals */

	output logic			pcu_pip1_stall_o,
	output logic			pcu_pip1_flush_o
	
);

	logic			pcu_ifs_fetch_en_int;
	logic			pcu_pip0_stall_int;
	logic			pcu_pip0_flush_int;
	logic			pcu_pip1_stall_int;
	logic			pcu_pip1_flush_int;

	logic			ifs_triggered_int;	
	logic			decs_triggered_int;	
	logic			exes_triggered_int;	

	logic 			ifs_halt_int;
	logic 			decs_halt_int;
	logic 			exes_halt_int;


	always_ff@(posedge clk_i) begin : pipeline_controller
		
		/*ifs_halt_int  = ifs_triggered_int | decs_triggered_int | exes_triggered_int;
		decs_halt_int = decs_triggered_int | exes_triggered_int;
		exes_halt_int = exes_triggered_int;*/

		if( rstn_i == 1'b0 ) begin
			pcu_ifs_fetch_en_int <= 1'b1;
			//pcu_pip0_stall_int <= 1'b0;
			pcu_pip0_flush_int <= 1'b0;
			//pcu_pip1_stall_int <= 1'b0;
			pcu_pip1_flush_int <= 1'b0;
			ifs_triggered_int  <= 1'b0;
		end
		else begin
			if( pcu_ifs_busy_i & ifs_triggered_int == 1'b0 ) begin 
				ifs_triggered_int <= 1'b1;
				pcu_ifs_fetch_en_int <= 1'b0;
			end
			else if( ~pcu_ifs_busy_i & ifs_triggered_int == 1'b1 ) begin
				if( ~pcu_pip0_stall_int & ~pcu_pip1_stall_int ) begin
					ifs_triggered_int <= 1'b0;
					pcu_ifs_fetch_en_int <= 1'b1;
				end else begin
					pcu_ifs_fetch_en_int <= 1'b0;
				end
			end
			else begin
				pcu_ifs_fetch_en_int <= 1'b0;
			end
		end
		
	end

	/*
		the trigger notices us when the if stage succesfully fetched a new instruction 
		Because the dec stage only takes 1 clk cycles, the trigger will become high exactly when the dec_busy will fall down. So, we will stall the pipe only if a new instruction
		has been charged into the ifs stage, but the decode stage has not passed its decoded instruction yet to the execution stage.
		When the decode stage will take more than 1 clk cycles, things will get more complicated: i.e. the pipe will have some "shadow-stalls" which won't affect the 
		correct behaviour, but will periodically and uselessly commutate-> consume power
	*/
	
	assign pcu_pip0_stall_int = ifs_triggered_int & pcu_ifs_busy_i & pcu_decs_busy_i;
	assign pcu_pip1_stall_int = pcu_exes_busy_i; //& pcu_decs_busy_i ;
	
	assign pcu_ifs_fetch_en_o = pcu_ifs_fetch_en_int;
	assign pcu_pip0_stall_o = pcu_pip0_stall_int;
	assign pcu_pip0_flush_o = pcu_pip0_flush_int;
	assign pcu_pip1_stall_o = pcu_pip1_stall_int;
	assign pcu_pip1_flush_o = pcu_pip1_flush_int;

endmodule

