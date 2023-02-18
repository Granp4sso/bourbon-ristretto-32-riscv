`include "pkg/ristretto_exe_stage_pkg.sv"

import ristretto_exe_stage_pkg::*;

module ristretto_pmp #(

	parameter unsigned DataWidth = 32,
	parameter unsigned AddrWidth = 32,
	parameter unsigned PMPenable = PMP_EN_TRUE,
	parameter unsigned PMPentries = 16

)
(

    input  logic                    pmp_curr_pvm_i,
    input  logic[AddrWidth-1:0] 	pmp_next_pc_i,
    input  logic[AddrWidth-1:0] 	pmp_data_addr_i,

    input  logic[1:0]               pmp_op_i,

	input  logic [DataWidth-1:0] 	pmp_pmpcfg_i[PMPentries/4],
	input  logic [AddrWidth-1:0]	pmp_pmpaddr_i[PMPentries],

    output logic                    pmp_grantx_o,       //Grant Execution
    output logic                    pmp_grantw_o,       //Grant Store
    output logic                    pmp_grantr_o        //Grant Load

);

    /*
        1 - For each PMP entry {addr,cfg} implement a decode block and extract base and range {B,R}
        2 - Use pmp_next_pc_i to address the entries
        3 - Use the entry id and the pmp_curr_pv_i to select a single entry. 
        4 - Check if X permission is 1 in cfg, and set pmp_grantx_o accordingly
        
        NB: do 2-4 using pmp_data_addr_i in parallel as well and set pmp_grantw_o and pmprantr_o

        grant signals are going to be used by the TCU to handle the access fault.
    
    */

    // Decode Address Processs

    logic [7:0] pmp_pmpcfgx_int[PMPentries];
    logic [AddrWidth-1:0] pmp_lower_addr_int[PMPentries];
    logic [AddrWidth-1:0] pmp_upper_addr_int[PMPentries];

    //NAPOT encoding signals
    
    /* verilator lint_off UNOPTFLAT */
    logic [AddrWidth/2-1:0] pmp_napot_ctr_int[PMPentries];
    logic [AddrWidth/2-1:0] pmp_napot_sel_int[PMPentries];
    logic [AddrWidth/2-1:0] pmp_napot_flt_int[PMPentries];
    logic [AddrWidth-1:0] pmp_napot_basemask_int[PMPentries];

    logic [$clog2(AddrWidth):0][AddrWidth-1:0] pmp_napot_treesum_int[PMPentries];

    logic [AddrWidth-1:0] pmp_napot_addrsize_int[PMPentries];
    logic [AddrWidth-1:0] pmp_napot_addrshft_int[PMPentries];

    /* verilator lint_on UNOPTFLAT */

    logic [AddrWidth-1:0] test[PMPentries];

    assign test[0] = 32'h101010ff;
    assign test[1] = 32'h1010107f;
    assign test[2] = 32'h1010103f;
    assign test[3] = 32'h1011ffff;

    for(genvar i = 0; i < PMPentries; i++) begin

        /* verilator lint_off UNOPTFLAT */

        // Extracting NAPOT basemask (i.e. the strike of least significant ones)

        for(genvar j = 0; j < AddrWidth/2; j++) begin : pmp_napot_decoder
            assign pmp_napot_ctr_int[i][j] = (j == 0) ? 1'b1 : pmp_napot_sel_int[i][j-1];
            assign pmp_napot_flt_int[i][j] = pmp_napot_ctr_int[i][j] & test[i][2*j];
            assign pmp_napot_sel_int[i][j] = pmp_napot_flt_int[i][j] & test[i][2*(j+1)-1];
            assign pmp_napot_basemask_int[i][2*(j+1)-1:2*j] = (pmp_napot_sel_int[i][j]) ? {test[i][2*(j+1)-1], pmp_napot_flt_int[i][j]} : {1'b0, pmp_napot_flt_int[i][j]};      
        end

        // Tree-based sum to get shift amount (PS: guarda ai fogli e disegnati schemi, è un casino)

        assign pmp_napot_treesum_int[i][0] = pmp_napot_basemask_int[i];

        for(genvar j = 1; j <= $clog2(AddrWidth); j++) begin : pmp_napot_treesum_levels
            for(genvar k = 0; k < AddrWidth/2**j; k++) begin : pmp_napot_treesum_sums
               assign pmp_napot_treesum_int[i][j][(2**j)*(k+1)-1:(2**j)*k] = 
                    {{2**(j-1){1'b0}},pmp_napot_treesum_int[i][j-1][k*(2**j)+(2**(j-1))-1:k*(2**j)]} + {{2**(j-1){1'b0}},pmp_napot_treesum_int[i][j-1][(k+1)*(2**j)-1:k*(2**j)+2**(j-1)]};
            end
        end

        assign pmp_napot_addrshft_int[i] = pmp_napot_treesum_int[i][$clog2(AddrWidth)];
        assign pmp_napot_addrsize_int[i] = {pmp_napot_basemask_int[i][DataWidth-4 : 0],3'b000} + 32'h8;
        /* verilator lint_on UNOPTFLAT */

        always_comb begin : pmp_addr_decode_proc

            pmp_pmpcfgx_int[i] = pmp_pmpcfg_i[{2'b00,i[DataWidth-1:2]}][8*({2'b00,i[1:0]}+1)-1:8*{2'b00,i[1:0]}];

            case( pmp_pmpcfgx_int[i][4:3] ) 
                PMPCFG_ADDR_NONE : begin pmp_lower_addr_int[i] = '0; pmp_upper_addr_int[i] = '0; end
                PMPCFG_ADDR_TOR : begin 
                    pmp_upper_addr_int[i] = pmp_pmpaddr_i[i];
                    pmp_lower_addr_int[i] = (i == 0) ? '0 : pmp_pmpaddr_i[i-1];
                end
                PMPCFG_ADDR_NA4 : begin
                    pmp_lower_addr_int[i] = pmp_pmpaddr_i[i] + 32'h4;
                    pmp_upper_addr_int[i] = pmp_pmpaddr_i[i];
                end
                PMPCFG_ADDR_NAPOT : begin 

                    

                end
            endcase
        end

    end

    // Enetry Prioritized Selection Process



    assign pmp_grantx_o = 1'b1;
    assign pmp_grantw_o = 1'b1;
    assign pmp_grantr_o = 1'b1;


endmodule
