// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vbeta_top__Syms.h"


//======================

void Vbeta_top::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addInitCb(&traceInit, __VlSymsp);
    traceRegister(tfp->spTrace());
}

void Vbeta_top::traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vbeta_top__Syms* __restrict vlSymsp = static_cast<Vbeta_top__Syms*>(userp);
    if (!Verilated::calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->module(vlSymsp->name());
    tracep->scopeEscape(' ');
    Vbeta_top::traceInitTop(vlSymsp, tracep);
    tracep->scopeEscape('.');
}

//======================


void Vbeta_top::traceInitTop(void* userp, VerilatedVcd* tracep) {
    Vbeta_top__Syms* __restrict vlSymsp = static_cast<Vbeta_top__Syms*>(userp);
    Vbeta_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceInitSub0(userp, tracep);
    }
}

void Vbeta_top::traceInitSub0(void* userp, VerilatedVcd* tracep) {
    Vbeta_top__Syms* __restrict vlSymsp = static_cast<Vbeta_top__Syms*>(userp);
    Vbeta_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    const int c = vlSymsp->__Vm_baseCode;
    if (false && tracep && c) {}  // Prevent unused
    // Body
    {
        tracep->declBit(c+124,"clk_i", false,-1);
        tracep->declBit(c+125,"rstn_i", false,-1);
        tracep->declBit(c+126,"instr_ready_i", false,-1);
        tracep->declBit(c+127,"instr_valid_i", false,-1);
        tracep->declBus(c+128,"instr_rdata_i", false,-1, 31,0);
        tracep->declBit(c+129,"instr_req_o", false,-1);
        tracep->declBus(c+130,"instr_addr_o", false,-1, 31,0);
        tracep->declBit(c+131,"rdata_ready_i", false,-1);
        tracep->declBit(c+132,"rdata_valid_i", false,-1);
        tracep->declBus(c+133,"rdata_data_i", false,-1, 31,0);
        tracep->declBus(c+134,"rdata_addr_o", false,-1, 31,0);
        tracep->declBus(c+135,"rdata_strb_o", false,-1, 3,0);
        tracep->declBit(c+136,"rdata_req_o", false,-1);
        tracep->declBit(c+137,"wdata_ready_i", false,-1);
        tracep->declBit(c+138,"wdata_valid_i", false,-1);
        tracep->declBus(c+139,"wdata_data_o", false,-1, 31,0);
        tracep->declBus(c+140,"wdata_addr_o", false,-1, 31,0);
        tracep->declBus(c+141,"wdata_strb_o", false,-1, 3,0);
        tracep->declBit(c+142,"wdata_req_o", false,-1);
        tracep->declBus(c+143,"result_o", false,-1, 31,0);
        tracep->declBit(c+144,"alu_op_end_o", false,-1);
        tracep->declBus(c+145,"beta_top DataWidth", false,-1, 31,0);
        tracep->declBus(c+145,"beta_top AddressWidth", false,-1, 31,0);
        tracep->declBit(c+124,"beta_top clk_i", false,-1);
        tracep->declBit(c+125,"beta_top rstn_i", false,-1);
        tracep->declBit(c+126,"beta_top instr_ready_i", false,-1);
        tracep->declBit(c+127,"beta_top instr_valid_i", false,-1);
        tracep->declBus(c+128,"beta_top instr_rdata_i", false,-1, 31,0);
        tracep->declBit(c+129,"beta_top instr_req_o", false,-1);
        tracep->declBus(c+130,"beta_top instr_addr_o", false,-1, 31,0);
        tracep->declBit(c+131,"beta_top rdata_ready_i", false,-1);
        tracep->declBit(c+132,"beta_top rdata_valid_i", false,-1);
        tracep->declBus(c+133,"beta_top rdata_data_i", false,-1, 31,0);
        tracep->declBus(c+134,"beta_top rdata_addr_o", false,-1, 31,0);
        tracep->declBus(c+135,"beta_top rdata_strb_o", false,-1, 3,0);
        tracep->declBit(c+136,"beta_top rdata_req_o", false,-1);
        tracep->declBit(c+137,"beta_top wdata_ready_i", false,-1);
        tracep->declBit(c+138,"beta_top wdata_valid_i", false,-1);
        tracep->declBus(c+139,"beta_top wdata_data_o", false,-1, 31,0);
        tracep->declBus(c+140,"beta_top wdata_addr_o", false,-1, 31,0);
        tracep->declBus(c+141,"beta_top wdata_strb_o", false,-1, 3,0);
        tracep->declBit(c+142,"beta_top wdata_req_o", false,-1);
        tracep->declBus(c+143,"beta_top result_o", false,-1, 31,0);
        tracep->declBit(c+144,"beta_top alu_op_end_o", false,-1);
        tracep->declBus(c+1,"beta_top result_int", false,-1, 31,0);
        tracep->declBus(c+2,"beta_top dec_offset12_int", false,-1, 11,0);
        tracep->declBus(c+3,"beta_top dec_offset20_int", false,-1, 19,0);
        tracep->declBus(c+4,"beta_top dec_operand_a_int", false,-1, 31,0);
        tracep->declBus(c+5,"beta_top dec_operand_b_int", false,-1, 31,0);
        tracep->declBus(c+6,"beta_top dec_rd_addr_int", false,-1, 4,0);
        tracep->declBus(c+7,"beta_top exe_rd_addr_int", false,-1, 4,0);
        tracep->declBus(c+8,"beta_top dec_control_word_int", false,-1, 24,0);
        tracep->declBus(c+9,"beta_top dec_next_pc_int", false,-1, 31,0);
        tracep->declBit(c+10,"beta_top dec_new_instr_int", false,-1);
        tracep->declBus(c+11,"beta_top next_pc_int", false,-1, 31,0);
        tracep->declBit(c+146,"beta_top alu_op_end_int", false,-1);
        tracep->declBit(c+12,"beta_top reg_wr_en_int", false,-1);
        tracep->declBit(c+13,"beta_top new_instr_int", false,-1);
        tracep->declBit(c+14,"beta_top pc_en_int", false,-1);
        tracep->declBit(c+15,"beta_top fetch_en_int", false,-1);
        tracep->declBus(c+16,"beta_top instr_addr_int", false,-1, 31,0);
        tracep->declBus(c+17,"beta_top instr_int", false,-1, 31,0);
        tracep->declBit(c+18,"beta_top instr_req_int", false,-1);
        tracep->declBit(c+10,"beta_top pip0_new_instr_int", false,-1);
        tracep->declBus(c+19,"beta_top pip0_instr_int", false,-1, 31,0);
        tracep->declBus(c+9,"beta_top pip0_next_pc_int", false,-1, 31,0);
        tracep->declBus(c+20,"beta_top pip1_offset12_int", false,-1, 11,0);
        tracep->declBus(c+21,"beta_top pip1_offset20_int", false,-1, 19,0);
        tracep->declBus(c+22,"beta_top pip1_operand_a_int", false,-1, 31,0);
        tracep->declBus(c+23,"beta_top pip1_operand_b_int", false,-1, 31,0);
        tracep->declBus(c+7,"beta_top pip1_rd_addr_int", false,-1, 4,0);
        tracep->declBus(c+24,"beta_top pip1_control_word_int", false,-1, 24,0);
        tracep->declBus(c+25,"beta_top pip1_next_pc_int", false,-1, 31,0);
        tracep->declBit(c+26,"beta_top pip1_new_instr_int", false,-1);
        tracep->declBit(c+27,"beta_top if_stage_busy_int", false,-1);
        tracep->declBit(c+28,"beta_top dec_stage_busy_int", false,-1);
        tracep->declBit(c+29,"beta_top exe_stage_busy_int", false,-1);
        tracep->declBit(c+30,"beta_top pcu_pip0_stall_int", false,-1);
        tracep->declBit(c+31,"beta_top pcu_pip0_flush_int", false,-1);
        tracep->declBit(c+32,"beta_top pcu_pip1_stall_int", false,-1);
        tracep->declBit(c+33,"beta_top pcu_pip1_flush_int", false,-1);
        tracep->declBit(c+34,"beta_top first_reset", false,-1);
        tracep->declBus(c+145,"beta_top if_stage DataWidth", false,-1, 31,0);
        tracep->declBus(c+147,"beta_top if_stage PrefetchBuffer", false,-1, 31,0);
        tracep->declBus(c+147,"beta_top if_stage iTCM", false,-1, 31,0);
        tracep->declBus(c+147,"beta_top if_stage iCache", false,-1, 31,0);
        tracep->declBit(c+124,"beta_top if_stage clk_i", false,-1);
        tracep->declBit(c+125,"beta_top if_stage rstn_i", false,-1);
        tracep->declBit(c+15,"beta_top if_stage if_fetch_en_i", false,-1);
        tracep->declBit(c+126,"beta_top if_stage if_instr_ready_i", false,-1);
        tracep->declBit(c+127,"beta_top if_stage if_instr_valid_i", false,-1);
        tracep->declBus(c+128,"beta_top if_stage if_instr_rdata_i", false,-1, 31,0);
        tracep->declBit(c+18,"beta_top if_stage if_instr_req_o", false,-1);
        tracep->declBit(c+14,"beta_top if_stage if_pc_en_i", false,-1);
        tracep->declBus(c+11,"beta_top if_stage if_next_pc_i", false,-1, 31,0);
        tracep->declBus(c+16,"beta_top if_stage if_curr_pc_o", false,-1, 31,0);
        tracep->declBus(c+17,"beta_top if_stage if_instr_o", false,-1, 31,0);
        tracep->declBit(c+13,"beta_top if_stage if_new_instr_o", false,-1);
        tracep->declBit(c+27,"beta_top if_stage if_stage_busy_o", false,-1);
        tracep->declBus(c+16,"beta_top if_stage curr_pc_int", false,-1, 31,0);
        tracep->declBus(c+17,"beta_top if_stage instr_int", false,-1, 31,0);
        tracep->declBit(c+27,"beta_top if_stage if_stage_busy_int", false,-1);
        tracep->declBit(c+13,"beta_top if_stage new_instr_int", false,-1);
        tracep->declBit(c+18,"beta_top if_stage instr_req_int", false,-1);
        tracep->declBus(c+145,"beta_top if_stage fu DataWidth", false,-1, 31,0);
        tracep->declBit(c+124,"beta_top if_stage fu clk_i", false,-1);
        tracep->declBit(c+125,"beta_top if_stage fu rstn_i", false,-1);
        tracep->declBit(c+15,"beta_top if_stage fu if_fu_fetch_en_i", false,-1);
        tracep->declBit(c+126,"beta_top if_stage fu if_fu_instr_ready_i", false,-1);
        tracep->declBit(c+127,"beta_top if_stage fu if_fu_instr_valid_i", false,-1);
        tracep->declBus(c+128,"beta_top if_stage fu if_fu_instr_rdata_i", false,-1, 31,0);
        tracep->declBit(c+18,"beta_top if_stage fu if_fu_instr_req_o", false,-1);
        tracep->declBus(c+17,"beta_top if_stage fu if_fu_instr_o", false,-1, 31,0);
        tracep->declBit(c+13,"beta_top if_stage fu if_fu_new_instr_o", false,-1);
        tracep->declBit(c+27,"beta_top if_stage fu if_fu_stage_busy_o", false,-1);
        tracep->declBit(c+27,"beta_top if_stage fu if_stage_busy_int", false,-1);
        tracep->declBit(c+18,"beta_top if_stage fu instr_req_int", false,-1);
        tracep->declBus(c+17,"beta_top if_stage fu instr_int", false,-1, 31,0);
        tracep->declBit(c+13,"beta_top if_stage fu new_instr_int", false,-1);
        tracep->declBus(c+35,"beta_top if_stage fu imem_state_int", false,-1, 1,0);
        tracep->declBus(c+145,"beta_top pipe0 DataWidth", false,-1, 31,0);
        tracep->declBit(c+124,"beta_top pipe0 clk_i", false,-1);
        tracep->declBit(c+125,"beta_top pipe0 rstn_i", false,-1);
        tracep->declBus(c+17,"beta_top pipe0 pip_instr_i", false,-1, 31,0);
        tracep->declBit(c+13,"beta_top pipe0 pip_new_instr_i", false,-1);
        tracep->declBus(c+19,"beta_top pipe0 pip_instr_o", false,-1, 31,0);
        tracep->declBit(c+10,"beta_top pipe0 pip_new_instr_o", false,-1);
        tracep->declBus(c+16,"beta_top pipe0 pip_next_pc_i", false,-1, 31,0);
        tracep->declBus(c+9,"beta_top pipe0 pip_next_pc_o", false,-1, 31,0);
        tracep->declBit(c+30,"beta_top pipe0 pip_stall_i", false,-1);
        tracep->declBit(c+31,"beta_top pipe0 pip_flush_i", false,-1);
        tracep->declBus(c+19,"beta_top pipe0 pip_instr_int", false,-1, 31,0);
        tracep->declBit(c+10,"beta_top pipe0 pip_new_instr_int", false,-1);
        tracep->declBus(c+9,"beta_top pipe0 pip_next_pc_int", false,-1, 31,0);
        tracep->declBus(c+145,"beta_top dec_stage DataWidth", false,-1, 31,0);
        tracep->declBus(c+147,"beta_top dec_stage Compressed", false,-1, 31,0);
        tracep->declBus(c+147,"beta_top dec_stage Embedded", false,-1, 31,0);
        tracep->declBit(c+124,"beta_top dec_stage clk_i", false,-1);
        tracep->declBit(c+125,"beta_top dec_stage rstn_i", false,-1);
        tracep->declBus(c+9,"beta_top dec_stage dec_next_pc_i", false,-1, 31,0);
        tracep->declBus(c+19,"beta_top dec_stage dec_instr_i", false,-1, 31,0);
        tracep->declBit(c+10,"beta_top dec_stage dec_new_instr_i", false,-1);
        tracep->declBus(c+1,"beta_top dec_stage dec_rd_wdata_i", false,-1, 31,0);
        tracep->declBus(c+7,"beta_top dec_stage dec_rd_addr_i", false,-1, 4,0);
        tracep->declBit(c+12,"beta_top dec_stage dec_reg_wr_en_i", false,-1);
        tracep->declBus(c+2,"beta_top dec_stage dec_offset12_o", false,-1, 11,0);
        tracep->declBus(c+3,"beta_top dec_stage dec_offset20_o", false,-1, 19,0);
        tracep->declBus(c+4,"beta_top dec_stage dec_operand_a_o", false,-1, 31,0);
        tracep->declBus(c+5,"beta_top dec_stage dec_operand_b_o", false,-1, 31,0);
        tracep->declBus(c+6,"beta_top dec_stage dec_rd_addr_o", false,-1, 4,0);
        tracep->declBus(c+8,"beta_top dec_stage dec_control_word_o", false,-1, 24,0);
        tracep->declBus(c+9,"beta_top dec_stage dec_next_pc_o", false,-1, 31,0);
        tracep->declBit(c+10,"beta_top dec_stage dec_new_instr_o", false,-1);
        tracep->declBit(c+27,"beta_top dec_stage if_stage_busy_i", false,-1);
        tracep->declBit(c+28,"beta_top dec_stage dec_stage_busy_o", false,-1);
        tracep->declBus(c+36,"beta_top dec_stage rs1_addr_int", false,-1, 4,0);
        tracep->declBus(c+37,"beta_top dec_stage rs2_addr_int", false,-1, 4,0);
        tracep->declBus(c+2,"beta_top dec_stage imm12_int", false,-1, 11,0);
        tracep->declBus(c+3,"beta_top dec_stage imm20_int", false,-1, 19,0);
        tracep->declBus(c+38,"beta_top dec_stage rs1_data_int", false,-1, 31,0);
        tracep->declBus(c+39,"beta_top dec_stage rs2_data_int", false,-1, 31,0);
        tracep->declBus(c+40,"beta_top dec_stage cu_address_int", false,-1, 8,0);
        tracep->declBit(c+41,"beta_top dec_stage invalid_instr_int", false,-1);
        tracep->declBus(c+6,"beta_top dec_stage rd_addr_int", false,-1, 4,0);
        tracep->declBus(c+4,"beta_top dec_stage operand_a_int", false,-1, 31,0);
        tracep->declBus(c+5,"beta_top dec_stage operand_b_int", false,-1, 31,0);
        tracep->declBit(c+42,"beta_top dec_stage rd_wr_en_int", false,-1);
        tracep->declBit(c+28,"beta_top dec_stage new_instruction_latch", false,-1);
        tracep->declBit(c+10,"beta_top dec_stage dec_new_instr_int", false,-1);
        tracep->declBus(c+8,"beta_top dec_stage control_word_int", false,-1, 24,0);
        tracep->declBit(c+124,"beta_top dec_stage decoder clk_i", false,-1);
        tracep->declBit(c+125,"beta_top dec_stage decoder rstn_i", false,-1);
        tracep->declBus(c+19,"beta_top dec_stage decoder instr_i", false,-1, 31,0);
        tracep->declBus(c+36,"beta_top dec_stage decoder rs1_o", false,-1, 4,0);
        tracep->declBus(c+37,"beta_top dec_stage decoder rs2_o", false,-1, 4,0);
        tracep->declBus(c+6,"beta_top dec_stage decoder rd_o", false,-1, 4,0);
        tracep->declBus(c+2,"beta_top dec_stage decoder imm12_o", false,-1, 11,0);
        tracep->declBus(c+3,"beta_top dec_stage decoder imm20_o", false,-1, 19,0);
        tracep->declBus(c+40,"beta_top dec_stage decoder cu_addr_o", false,-1, 8,0);
        tracep->declBit(c+41,"beta_top dec_stage decoder invalid_instr_o", false,-1);
        tracep->declBus(c+43,"beta_top dec_stage decoder opcode_int", false,-1, 6,0);
        tracep->declBus(c+44,"beta_top dec_stage decoder funct3_int", false,-1, 2,0);
        tracep->declBus(c+45,"beta_top dec_stage decoder funct7_int", false,-1, 6,0);
        tracep->declBus(c+36,"beta_top dec_stage decoder rs1_int", false,-1, 4,0);
        tracep->declBus(c+37,"beta_top dec_stage decoder rs2_int", false,-1, 4,0);
        tracep->declBus(c+6,"beta_top dec_stage decoder rd_int", false,-1, 4,0);
        tracep->declBus(c+2,"beta_top dec_stage decoder imm12_int", false,-1, 11,0);
        tracep->declBus(c+3,"beta_top dec_stage decoder imm20_int", false,-1, 19,0);
        tracep->declBus(c+46,"beta_top dec_stage decoder cu_addr_int", false,-1, 8,0);
        tracep->declBit(c+41,"beta_top dec_stage decoder invalid_instr_int", false,-1);
        tracep->declBit(c+47,"beta_top dec_stage decoder funct7_mask_bit_int", false,-1);
        tracep->declBit(c+48,"beta_top dec_stage decoder funct3_mask_bit_int", false,-1);
        tracep->declBit(c+49,"beta_top dec_stage decoder invalid_opcode_int", false,-1);
        tracep->declBit(c+124,"beta_top dec_stage regfile clk_i", false,-1);
        tracep->declBit(c+125,"beta_top dec_stage regfile rstn_i", false,-1);
        tracep->declBus(c+36,"beta_top dec_stage regfile rs1_addr_i", false,-1, 4,0);
        tracep->declBus(c+37,"beta_top dec_stage regfile rs2_addr_i", false,-1, 4,0);
        tracep->declBus(c+7,"beta_top dec_stage regfile rd_addr_i", false,-1, 4,0);
        tracep->declBit(c+42,"beta_top dec_stage regfile wr_en_i", false,-1);
        tracep->declBus(c+1,"beta_top dec_stage regfile rd_wdata_i", false,-1, 31,0);
        tracep->declBus(c+38,"beta_top dec_stage regfile rs1_data_o", false,-1, 31,0);
        tracep->declBus(c+39,"beta_top dec_stage regfile rs2_data_o", false,-1, 31,0);
        tracep->declBus(c+38,"beta_top dec_stage regfile rs1_data_int", false,-1, 31,0);
        tracep->declBus(c+39,"beta_top dec_stage regfile rs2_data_int", false,-1, 31,0);
        {int i; for (i=0; i<32; i++) {
                tracep->declBus(c+50+i*1,"beta_top dec_stage regfile regfile_data_int", true,(i+0), 31,0);}}
        tracep->declBus(c+82,"beta_top dec_stage regfile write_proc unnamedblk1 i", false,-1, 31,0);
        tracep->declBit(c+124,"beta_top dec_stage control_unit clk_i", false,-1);
        tracep->declBit(c+125,"beta_top dec_stage control_unit rstn_i", false,-1);
        tracep->declBus(c+40,"beta_top dec_stage control_unit cu_address_i", false,-1, 8,0);
        tracep->declBit(c+41,"beta_top dec_stage control_unit invalid_instr_i", false,-1);
        tracep->declBus(c+8,"beta_top dec_stage control_unit control_word_o", false,-1, 24,0);
        tracep->declBus(c+8,"beta_top dec_stage control_unit cw_int", false,-1, 24,0);
        tracep->declBus(c+145,"beta_top pipe1 DataWidth", false,-1, 31,0);
        tracep->declBit(c+124,"beta_top pipe1 clk_i", false,-1);
        tracep->declBit(c+125,"beta_top pipe1 rstn_i", false,-1);
        tracep->declBus(c+2,"beta_top pipe1 pip_offset12_i", false,-1, 11,0);
        tracep->declBus(c+3,"beta_top pipe1 pip_offset20_i", false,-1, 19,0);
        tracep->declBus(c+4,"beta_top pipe1 pip_operand_a_i", false,-1, 31,0);
        tracep->declBus(c+5,"beta_top pipe1 pip_operand_b_i", false,-1, 31,0);
        tracep->declBus(c+6,"beta_top pipe1 pip_rd_addr_i", false,-1, 4,0);
        tracep->declBus(c+8,"beta_top pipe1 pip_control_word_i", false,-1, 24,0);
        tracep->declBus(c+9,"beta_top pipe1 pip_next_pc_i", false,-1, 31,0);
        tracep->declBit(c+10,"beta_top pipe1 pip_new_instr_i", false,-1);
        tracep->declBus(c+20,"beta_top pipe1 pip_offset12_o", false,-1, 11,0);
        tracep->declBus(c+21,"beta_top pipe1 pip_offset20_o", false,-1, 19,0);
        tracep->declBus(c+22,"beta_top pipe1 pip_operand_a_o", false,-1, 31,0);
        tracep->declBus(c+23,"beta_top pipe1 pip_operand_b_o", false,-1, 31,0);
        tracep->declBus(c+7,"beta_top pipe1 pip_rd_addr_o", false,-1, 4,0);
        tracep->declBus(c+24,"beta_top pipe1 pip_control_word_o", false,-1, 24,0);
        tracep->declBus(c+25,"beta_top pipe1 pip_next_pc_o", false,-1, 31,0);
        tracep->declBit(c+26,"beta_top pipe1 pip_new_instr_o", false,-1);
        tracep->declBit(c+32,"beta_top pipe1 pip_stall_i", false,-1);
        tracep->declBit(c+33,"beta_top pipe1 pip_flush_i", false,-1);
        tracep->declBus(c+20,"beta_top pipe1 pip_offset12_int", false,-1, 11,0);
        tracep->declBus(c+21,"beta_top pipe1 pip_offset20_int", false,-1, 19,0);
        tracep->declBus(c+22,"beta_top pipe1 pip_operand_a_int", false,-1, 31,0);
        tracep->declBus(c+23,"beta_top pipe1 pip_operand_b_int", false,-1, 31,0);
        tracep->declBus(c+7,"beta_top pipe1 pip_rd_addr_int", false,-1, 4,0);
        tracep->declBus(c+24,"beta_top pipe1 pip_control_word_int", false,-1, 24,0);
        tracep->declBus(c+25,"beta_top pipe1 pip_next_pc_int", false,-1, 31,0);
        tracep->declBit(c+26,"beta_top pipe1 pip_new_instr_int", false,-1);
        tracep->declBus(c+145,"beta_top exe_stage DataWidth", false,-1, 31,0);
        tracep->declBus(c+145,"beta_top exe_stage AddressWidth", false,-1, 31,0);
        tracep->declBit(c+124,"beta_top exe_stage clk_i", false,-1);
        tracep->declBit(c+125,"beta_top exe_stage rstn_i", false,-1);
        tracep->declBit(c+26,"beta_top exe_stage exe_new_instr_i", false,-1);
        tracep->declBus(c+22,"beta_top exe_stage exe_operand_a_i", false,-1, 31,0);
        tracep->declBus(c+23,"beta_top exe_stage exe_operand_b_i", false,-1, 31,0);
        tracep->declBus(c+7,"beta_top exe_stage exe_rd_addr_i", false,-1, 4,0);
        tracep->declBus(c+25,"beta_top exe_stage exe_pc_i", false,-1, 31,0);
        tracep->declBus(c+20,"beta_top exe_stage exe_offset12_i", false,-1, 11,0);
        tracep->declBus(c+21,"beta_top exe_stage exe_offset20_i", false,-1, 19,0);
        tracep->declBus(c+83,"beta_top exe_stage exe_control_word_i", false,-1, 18,0);
        tracep->declBit(c+146,"beta_top exe_stage exe_alu_op_end_o", false,-1);
        tracep->declBus(c+11,"beta_top exe_stage exe_next_pc_o", false,-1, 31,0);
        tracep->declBus(c+1,"beta_top exe_stage exe_result_o", false,-1, 31,0);
        tracep->declBus(c+7,"beta_top exe_stage exe_rd_addr_o", false,-1, 4,0);
        tracep->declBit(c+12,"beta_top exe_stage exe_reg_wr_en_o", false,-1);
        tracep->declBit(c+28,"beta_top exe_stage dec_stage_busy_i", false,-1);
        tracep->declBit(c+29,"beta_top exe_stage exe_stage_busy_o", false,-1);
        tracep->declBit(c+131,"beta_top exe_stage rdata_ready_i", false,-1);
        tracep->declBit(c+132,"beta_top exe_stage rdata_valid_i", false,-1);
        tracep->declBus(c+133,"beta_top exe_stage rdata_data_i", false,-1, 31,0);
        tracep->declBus(c+134,"beta_top exe_stage rdata_addr_o", false,-1, 31,0);
        tracep->declBus(c+135,"beta_top exe_stage rdata_strb_o", false,-1, 3,0);
        tracep->declBit(c+136,"beta_top exe_stage rdata_req_o", false,-1);
        tracep->declBit(c+137,"beta_top exe_stage wdata_ready_i", false,-1);
        tracep->declBit(c+138,"beta_top exe_stage wdata_valid_i", false,-1);
        tracep->declBus(c+139,"beta_top exe_stage wdata_data_o", false,-1, 31,0);
        tracep->declBus(c+140,"beta_top exe_stage wdata_addr_o", false,-1, 31,0);
        tracep->declBus(c+141,"beta_top exe_stage wdata_strb_o", false,-1, 3,0);
        tracep->declBit(c+142,"beta_top exe_stage wdata_req_o", false,-1);
        tracep->declBit(c+146,"beta_top exe_stage exe_alu_op_end_int", false,-1);
        tracep->declBus(c+11,"beta_top exe_stage exe_next_pc_int", false,-1, 31,0);
        tracep->declBus(c+1,"beta_top exe_stage exe_result_int", false,-1, 31,0);
        tracep->declBus(c+84,"beta_top exe_stage exe_alu_stat_int", false,-1, 2,0);
        tracep->declBus(c+85,"beta_top exe_stage alu_result_int", false,-1, 31,0);
        tracep->declBus(c+7,"beta_top exe_stage exe_rd_addr_int", false,-1, 4,0);
        tracep->declBus(c+86,"beta_top exe_stage alu_op_int", false,-1, 4,0);
        tracep->declBus(c+87,"beta_top exe_stage bju_op_int", false,-1, 4,0);
        tracep->declBus(c+88,"beta_top exe_stage bju_next_pc_int", false,-1, 31,0);
        tracep->declBus(c+89,"beta_top exe_stage incr_pc_int", false,-1, 31,0);
        tracep->declBus(c+90,"beta_top exe_stage result_mux_sel_int", false,-1, 5,0);
        tracep->declBit(c+91,"beta_top exe_stage nextpc_mux_sel_int", false,-1);
        tracep->declBus(c+92,"beta_top exe_stage shu_mode_int", false,-1, 1,0);
        tracep->declBit(c+93,"beta_top exe_stage shu_en_int", false,-1);
        tracep->declBit(c+94,"beta_top exe_stage shu_busy_int", false,-1);
        tracep->declBus(c+95,"beta_top exe_stage shu_size_int", false,-1, 1,0);
        tracep->declBit(c+96,"beta_top exe_stage lsu_busy_int", false,-1);
        tracep->declBus(c+97,"beta_top exe_stage lsu_op_size_int", false,-1, 1,0);
        tracep->declBit(c+98,"beta_top exe_stage lsu_op_int", false,-1);
        tracep->declBit(c+99,"beta_top exe_stage lsu_en_int", false,-1);
        tracep->declBus(c+100,"beta_top exe_stage lsu_result_int", false,-1, 31,0);
        tracep->declBit(c+29,"beta_top exe_stage exe_stage_busy_int", false,-1);
        tracep->declBus(c+101,"beta_top exe_stage shu_result_int", false,-1, 31,0);
        tracep->declBus(c+85,"beta_top exe_stage lsu_addr_int", false,-1, 31,0);
        tracep->declBus(c+145,"beta_top exe_stage exe_cu DataWidth", false,-1, 31,0);
        tracep->declBit(c+124,"beta_top exe_stage exe_cu clk_i", false,-1);
        tracep->declBit(c+125,"beta_top exe_stage exe_cu rstn_i", false,-1);
        tracep->declBus(c+83,"beta_top exe_stage exe_cu execu_control_word_i", false,-1, 18,0);
        tracep->declBit(c+146,"beta_top exe_stage exe_cu execu_alu_op_end_i", false,-1);
        tracep->declBus(c+86,"beta_top exe_stage exe_cu execu_alu_op_o", false,-1, 4,0);
        tracep->declBus(c+95,"beta_top exe_stage exe_cu execu_shu_size_i", false,-1, 1,0);
        tracep->declBit(c+94,"beta_top exe_stage exe_cu execu_shu_busy_i", false,-1);
        tracep->declBus(c+92,"beta_top exe_stage exe_cu execu_shu_mode_o", false,-1, 1,0);
        tracep->declBit(c+93,"beta_top exe_stage exe_cu execu_shu_en_o", false,-1);
        tracep->declBus(c+87,"beta_top exe_stage exe_cu execu_bju_op_o", false,-1, 4,0);
        tracep->declBit(c+96,"beta_top exe_stage exe_cu execu_lsu_busy_i", false,-1);
        tracep->declBus(c+97,"beta_top exe_stage exe_cu execu_lsu_op_size_o", false,-1, 1,0);
        tracep->declBit(c+98,"beta_top exe_stage exe_cu execu_lsu_op_o", false,-1);
        tracep->declBit(c+99,"beta_top exe_stage exe_cu execu_lsu_en_o", false,-1);
        tracep->declBus(c+90,"beta_top exe_stage exe_cu execu_result_sel_o", false,-1, 5,0);
        tracep->declBit(c+91,"beta_top exe_stage exe_cu execu_nextpc_sel_o", false,-1);
        tracep->declBit(c+28,"beta_top exe_stage exe_cu execu_dec_stage_busy_i", false,-1);
        tracep->declBit(c+29,"beta_top exe_stage exe_cu execu_exe_stage_busy_o", false,-1);
        tracep->declBus(c+86,"beta_top exe_stage exe_cu execu_alu_op_int", false,-1, 4,0);
        tracep->declBus(c+87,"beta_top exe_stage exe_cu execu_bju_op_int", false,-1, 4,0);
        tracep->declBus(c+92,"beta_top exe_stage exe_cu execu_shu_mode_int", false,-1, 1,0);
        tracep->declBit(c+93,"beta_top exe_stage exe_cu execu_shu_en_int", false,-1);
        tracep->declBus(c+90,"beta_top exe_stage exe_cu execu_result_sel_int", false,-1, 5,0);
        tracep->declBit(c+91,"beta_top exe_stage exe_cu execu_nextpc_sel_int", false,-1);
        tracep->declBit(c+29,"beta_top exe_stage exe_cu execu_exe_stage_busy_int", false,-1);
        tracep->declBit(c+99,"beta_top exe_stage exe_cu execu_lsu_en_int", false,-1);
        tracep->declBus(c+97,"beta_top exe_stage exe_cu execu_lsu_op_size_int", false,-1, 1,0);
        tracep->declBit(c+98,"beta_top exe_stage exe_cu execu_lsu_op_int", false,-1);
        tracep->declBus(c+102,"beta_top exe_stage exe_cu shift_fsm", false,-1, 1,0);
        tracep->declBus(c+103,"beta_top exe_stage exe_cu lsu_fsm", false,-1, 1,0);
        tracep->declBit(c+104,"beta_top exe_stage exe_cu event_latch", false,-1);
        tracep->declBus(c+105,"beta_top exe_stage exe_cu shift_latch", false,-1, 1,0);
        tracep->declBus(c+106,"beta_top exe_stage exe_cu lsu_latch", false,-1, 1,0);
        tracep->declBit(c+124,"beta_top exe_stage alu clk_i", false,-1);
        tracep->declBit(c+125,"beta_top exe_stage alu rstn_i", false,-1);
        tracep->declBus(c+22,"beta_top exe_stage alu operand_a_i", false,-1, 31,0);
        tracep->declBus(c+23,"beta_top exe_stage alu operand_b_i", false,-1, 31,0);
        tracep->declBus(c+86,"beta_top exe_stage alu operation_i", false,-1, 4,0);
        tracep->declBus(c+84,"beta_top exe_stage alu alu_stat_o", false,-1, 2,0);
        tracep->declBit(c+146,"beta_top exe_stage alu alu_op_end_o", false,-1);
        tracep->declBus(c+85,"beta_top exe_stage alu alu_result_o", false,-1, 31,0);
        tracep->declBus(c+85,"beta_top exe_stage alu op_result_int", false,-1, 31,0);
        tracep->declBus(c+107,"beta_top exe_stage alu status_comp_data", false,-1, 31,0);
        tracep->declBit(c+146,"beta_top exe_stage alu alu_int_end", false,-1);
        tracep->declBit(c+148,"beta_top exe_stage alu status_flag_int", false,-1);
        tracep->declBus(c+84,"beta_top exe_stage alu alu_stat_int", false,-1, 2,0);
        tracep->declBit(c+124,"beta_top exe_stage shu clk_i", false,-1);
        tracep->declBit(c+125,"beta_top exe_stage shu rstn_i", false,-1);
        tracep->declBus(c+22,"beta_top exe_stage shu operand_a_i", false,-1, 31,0);
        tracep->declBus(c+108,"beta_top exe_stage shu operand_b_i", false,-1, 4,0);
        tracep->declBus(c+92,"beta_top exe_stage shu shu_mode_i", false,-1, 1,0);
        tracep->declBit(c+93,"beta_top exe_stage shu shu_en_i", false,-1);
        tracep->declBit(c+94,"beta_top exe_stage shu shu_busy_o", false,-1);
        tracep->declBus(c+101,"beta_top exe_stage shu shu_result_o", false,-1, 31,0);
        tracep->declBit(c+94,"beta_top exe_stage shu shu_busy_int", false,-1);
        tracep->declBus(c+101,"beta_top exe_stage shu shu_result_int", false,-1, 31,0);
        tracep->declBus(c+109,"beta_top exe_stage shu shiftreg_cnt_int", false,-1, 4,0);
        tracep->declBit(c+110,"beta_top exe_stage shu shu_end", false,-1);
        tracep->declBus(c+149,"beta_top exe_stage bju DATAWIDTH", false,-1, 31,0);
        tracep->declBit(c+124,"beta_top exe_stage bju clk_i", false,-1);
        tracep->declBit(c+125,"beta_top exe_stage bju rstn_i", false,-1);
        tracep->declBus(c+25,"beta_top exe_stage bju bju_pc_i", false,-1, 31,0);
        tracep->declBus(c+20,"beta_top exe_stage bju bju_offset12_i", false,-1, 11,0);
        tracep->declBus(c+21,"beta_top exe_stage bju bju_offset20_i", false,-1, 19,0);
        tracep->declBus(c+22,"beta_top exe_stage bju bju_basereg_i", false,-1, 31,0);
        tracep->declBus(c+84,"beta_top exe_stage bju bju_alu_stat_i", false,-1, 2,0);
        tracep->declBus(c+87,"beta_top exe_stage bju bju_op_i", false,-1, 4,0);
        tracep->declBus(c+88,"beta_top exe_stage bju bju_next_pc_o", false,-1, 31,0);
        tracep->declBit(c+111,"beta_top exe_stage bju bju_branch_taken_o", false,-1);
        tracep->declBus(c+88,"beta_top exe_stage bju bju_next_pc_int", false,-1, 31,0);
        tracep->declBus(c+112,"beta_top exe_stage bju bju_selected_data_int", false,-1, 31,0);
        tracep->declBit(c+111,"beta_top exe_stage bju bju_branch_taken_int", false,-1);
        tracep->declBus(c+145,"beta_top exe_stage lsu DataWidth", false,-1, 31,0);
        tracep->declBus(c+145,"beta_top exe_stage lsu AddressWidth", false,-1, 31,0);
        tracep->declBit(c+124,"beta_top exe_stage lsu clk_i", false,-1);
        tracep->declBit(c+125,"beta_top exe_stage lsu rstn_i", false,-1);
        tracep->declBus(c+23,"beta_top exe_stage lsu op_data_i", false,-1, 31,0);
        tracep->declBus(c+85,"beta_top exe_stage lsu op_addr_i", false,-1, 31,0);
        tracep->declBit(c+131,"beta_top exe_stage lsu rdata_ready_i", false,-1);
        tracep->declBit(c+132,"beta_top exe_stage lsu rdata_valid_i", false,-1);
        tracep->declBus(c+133,"beta_top exe_stage lsu rdata_data_i", false,-1, 31,0);
        tracep->declBus(c+134,"beta_top exe_stage lsu rdata_addr_o", false,-1, 31,0);
        tracep->declBus(c+135,"beta_top exe_stage lsu rdata_strb_o", false,-1, 3,0);
        tracep->declBit(c+136,"beta_top exe_stage lsu rdata_req_o", false,-1);
        tracep->declBit(c+137,"beta_top exe_stage lsu wdata_ready_i", false,-1);
        tracep->declBit(c+138,"beta_top exe_stage lsu wdata_valid_i", false,-1);
        tracep->declBus(c+139,"beta_top exe_stage lsu wdata_data_o", false,-1, 31,0);
        tracep->declBus(c+140,"beta_top exe_stage lsu wdata_addr_o", false,-1, 31,0);
        tracep->declBus(c+141,"beta_top exe_stage lsu wdata_strb_o", false,-1, 3,0);
        tracep->declBit(c+142,"beta_top exe_stage lsu wdata_req_o", false,-1);
        tracep->declBus(c+97,"beta_top exe_stage lsu lsu_op_size_i", false,-1, 1,0);
        tracep->declBit(c+98,"beta_top exe_stage lsu lsu_op_i", false,-1);
        tracep->declBit(c+99,"beta_top exe_stage lsu lsu_op_en_i", false,-1);
        tracep->declBus(c+20,"beta_top exe_stage lsu lsu_woffset_i", false,-1, 11,0);
        tracep->declBit(c+96,"beta_top exe_stage lsu lsu_busy_o", false,-1);
        tracep->declBus(c+100,"beta_top exe_stage lsu lsu_result_o", false,-1, 31,0);
        tracep->declBus(c+113,"beta_top exe_stage lsu rdata_addr_int", false,-1, 31,0);
        tracep->declBus(c+114,"beta_top exe_stage lsu rdata_strb_int", false,-1, 3,0);
        tracep->declBit(c+115,"beta_top exe_stage lsu rdata_req_int", false,-1);
        tracep->declBus(c+116,"beta_top exe_stage lsu wdata_data_int", false,-1, 31,0);
        tracep->declBus(c+117,"beta_top exe_stage lsu wdata_addr_int", false,-1, 31,0);
        tracep->declBus(c+118,"beta_top exe_stage lsu wdata_strb_int", false,-1, 3,0);
        tracep->declBit(c+119,"beta_top exe_stage lsu wdata_req_int", false,-1);
        tracep->declBit(c+96,"beta_top exe_stage lsu lsu_busy_int", false,-1);
        tracep->declBus(c+100,"beta_top exe_stage lsu lsu_result_int", false,-1, 31,0);
        tracep->declBus(c+120,"beta_top exe_stage lsu rdmem_state", false,-1, 1,0);
        tracep->declBus(c+121,"beta_top exe_stage lsu wdmem_state", false,-1, 1,0);
        tracep->declBus(c+122,"beta_top exe_stage lsu woffset_int", false,-1, 31,0);
        tracep->declBus(c+145,"beta_top pcu DataWidth", false,-1, 31,0);
        tracep->declBus(c+150,"beta_top pcu StageNum", false,-1, 31,0);
        tracep->declBit(c+124,"beta_top pcu clk_i", false,-1);
        tracep->declBit(c+125,"beta_top pcu rstn_i", false,-1);
        tracep->declBit(c+27,"beta_top pcu pcu_ifs_busy_i", false,-1);
        tracep->declBit(c+15,"beta_top pcu pcu_ifs_fetch_en_o", false,-1);
        tracep->declBit(c+28,"beta_top pcu pcu_decs_busy_i", false,-1);
        tracep->declBit(c+29,"beta_top pcu pcu_exes_busy_i", false,-1);
        tracep->declBit(c+30,"beta_top pcu pcu_pip0_stall_o", false,-1);
        tracep->declBit(c+31,"beta_top pcu pcu_pip0_flush_o", false,-1);
        tracep->declBit(c+32,"beta_top pcu pcu_pip1_stall_o", false,-1);
        tracep->declBit(c+33,"beta_top pcu pcu_pip1_flush_o", false,-1);
        tracep->declBit(c+15,"beta_top pcu pcu_ifs_fetch_en_int", false,-1);
        tracep->declBit(c+30,"beta_top pcu pcu_pip0_stall_int", false,-1);
        tracep->declBit(c+31,"beta_top pcu pcu_pip0_flush_int", false,-1);
        tracep->declBit(c+32,"beta_top pcu pcu_pip1_stall_int", false,-1);
        tracep->declBit(c+33,"beta_top pcu pcu_pip1_flush_int", false,-1);
        tracep->declBit(c+123,"beta_top pcu ifs_triggered_int", false,-1);
        tracep->declBit(c+151,"beta_top pcu decs_triggered_int", false,-1);
        tracep->declBit(c+152,"beta_top pcu exes_triggered_int", false,-1);
        tracep->declBit(c+153,"beta_top pcu ifs_halt_int", false,-1);
        tracep->declBit(c+154,"beta_top pcu decs_halt_int", false,-1);
        tracep->declBit(c+155,"beta_top pcu exes_halt_int", false,-1);
        tracep->declBus(c+156,"beta_pkg XLEN", false,-1, 31,0);
        tracep->declBus(c+157,"beta_if_stage_pkg imem_fsm_bsize", false,-1, 31,0);
        tracep->declBus(c+158,"beta_if_stage_pkg IMEM_IDLE", false,-1, 1,0);
        tracep->declBus(c+159,"beta_if_stage_pkg IMEM_WRDY", false,-1, 1,0);
        tracep->declBus(c+160,"beta_if_stage_pkg IMEM_WVLD", false,-1, 1,0);
        tracep->declBus(c+161,"beta_dec_stage_pkg Major_IMM", false,-1, 4,0);
        tracep->declBus(c+162,"beta_dec_stage_pkg Major_LUI", false,-1, 4,0);
        tracep->declBus(c+163,"beta_dec_stage_pkg Major_AUIPC", false,-1, 4,0);
        tracep->declBus(c+164,"beta_dec_stage_pkg Major_REG", false,-1, 4,0);
        tracep->declBus(c+165,"beta_dec_stage_pkg Major_JAL", false,-1, 4,0);
        tracep->declBus(c+166,"beta_dec_stage_pkg Major_JALR", false,-1, 4,0);
        tracep->declBus(c+167,"beta_dec_stage_pkg Major_BRANCH", false,-1, 4,0);
        tracep->declBus(c+168,"beta_dec_stage_pkg Major_LOAD", false,-1, 4,0);
        tracep->declBus(c+169,"beta_dec_stage_pkg Major_STORE", false,-1, 4,0);
        tracep->declBus(c+170,"beta_dec_stage_pkg Minor_ADD", false,-1, 2,0);
        tracep->declBus(c+170,"beta_dec_stage_pkg Minor_SUB", false,-1, 2,0);
        tracep->declBus(c+171,"beta_dec_stage_pkg Minor_SLL", false,-1, 2,0);
        tracep->declBus(c+172,"beta_dec_stage_pkg Minor_SLT", false,-1, 2,0);
        tracep->declBus(c+173,"beta_dec_stage_pkg Minor_SLTU", false,-1, 2,0);
        tracep->declBus(c+174,"beta_dec_stage_pkg Minor_XOR", false,-1, 2,0);
        tracep->declBus(c+175,"beta_dec_stage_pkg Minor_SRL", false,-1, 2,0);
        tracep->declBus(c+175,"beta_dec_stage_pkg Minor_SRA", false,-1, 2,0);
        tracep->declBus(c+176,"beta_dec_stage_pkg Minor_OR", false,-1, 2,0);
        tracep->declBus(c+177,"beta_dec_stage_pkg Minor_AND", false,-1, 2,0);
        tracep->declBus(c+170,"beta_dec_stage_pkg Minor_ADDI", false,-1, 2,0);
        tracep->declBus(c+172,"beta_dec_stage_pkg Minor_SLTI", false,-1, 2,0);
        tracep->declBus(c+173,"beta_dec_stage_pkg Minor_SLTIU", false,-1, 2,0);
        tracep->declBus(c+174,"beta_dec_stage_pkg Minor_XORI", false,-1, 2,0);
        tracep->declBus(c+176,"beta_dec_stage_pkg Minor_ORI", false,-1, 2,0);
        tracep->declBus(c+177,"beta_dec_stage_pkg Minor_ANDI", false,-1, 2,0);
        tracep->declBus(c+171,"beta_dec_stage_pkg Minor_SLLI", false,-1, 2,0);
        tracep->declBus(c+175,"beta_dec_stage_pkg Minor_SRLI", false,-1, 2,0);
        tracep->declBus(c+175,"beta_dec_stage_pkg Minor_SRAI", false,-1, 2,0);
        tracep->declBus(c+170,"beta_dec_stage_pkg Minor_LB", false,-1, 2,0);
        tracep->declBus(c+171,"beta_dec_stage_pkg Minor_LH", false,-1, 2,0);
        tracep->declBus(c+172,"beta_dec_stage_pkg Minor_LW", false,-1, 2,0);
        tracep->declBus(c+174,"beta_dec_stage_pkg Minor_LBU", false,-1, 2,0);
        tracep->declBus(c+175,"beta_dec_stage_pkg Minor_LHU", false,-1, 2,0);
        tracep->declBus(c+170,"beta_dec_stage_pkg Minor_SB", false,-1, 2,0);
        tracep->declBus(c+171,"beta_dec_stage_pkg Minor_SH", false,-1, 2,0);
        tracep->declBus(c+172,"beta_dec_stage_pkg Minor_SW", false,-1, 2,0);
        tracep->declBus(c+170,"beta_dec_stage_pkg Minor_BEQ", false,-1, 2,0);
        tracep->declBus(c+171,"beta_dec_stage_pkg Minor_BNE", false,-1, 2,0);
        tracep->declBus(c+174,"beta_dec_stage_pkg Minor_BLT", false,-1, 2,0);
        tracep->declBus(c+175,"beta_dec_stage_pkg Minor_BGE", false,-1, 2,0);
        tracep->declBus(c+176,"beta_dec_stage_pkg Minor_BLTU", false,-1, 2,0);
        tracep->declBus(c+177,"beta_dec_stage_pkg Minor_BGEU", false,-1, 2,0);
        tracep->declBus(c+158,"beta_exe_stage_pkg SHIFT_NONE", false,-1, 1,0);
        tracep->declBus(c+159,"beta_exe_stage_pkg SHIFT_LEFT", false,-1, 1,0);
        tracep->declBus(c+160,"beta_exe_stage_pkg SHIFT_RIGHT", false,-1, 1,0);
        tracep->declBus(c+178,"beta_exe_stage_pkg SHIFT_ARIGHT", false,-1, 1,0);
        tracep->declBus(c+158,"beta_exe_stage_pkg MEM_SIZE_WORD", false,-1, 1,0);
        tracep->declBus(c+159,"beta_exe_stage_pkg MEM_SIZE_HALF", false,-1, 1,0);
        tracep->declBus(c+160,"beta_exe_stage_pkg MEM_SIZE_BYTE", false,-1, 1,0);
        tracep->declBit(c+179,"beta_exe_stage_pkg MEM_LOAD_OP", false,-1);
        tracep->declBit(c+146,"beta_exe_stage_pkg MEM_STORE_OP", false,-1);
        tracep->declBus(c+157,"beta_exe_stage_pkg wdmem_fsm_bsize", false,-1, 31,0);
        tracep->declBus(c+157,"beta_exe_stage_pkg rdmem_fsm_bsize", false,-1, 31,0);
        tracep->declBus(c+158,"beta_exe_stage_pkg RDMEM_IDLE", false,-1, 1,0);
        tracep->declBus(c+159,"beta_exe_stage_pkg RDMEM_WRDY", false,-1, 1,0);
        tracep->declBus(c+160,"beta_exe_stage_pkg RDMEM_WVLD", false,-1, 1,0);
        tracep->declBus(c+158,"beta_exe_stage_pkg WDMEM_IDLE", false,-1, 1,0);
        tracep->declBus(c+159,"beta_exe_stage_pkg WDMEM_WRDY", false,-1, 1,0);
        tracep->declBus(c+160,"beta_exe_stage_pkg WDMEM_WVLD", false,-1, 1,0);
    }
}

void Vbeta_top::traceRegister(VerilatedVcd* tracep) {
    // Body
    {
        tracep->addFullCb(&traceFullTop0, __VlSymsp);
        tracep->addChgCb(&traceChgTop0, __VlSymsp);
        tracep->addCleanupCb(&traceCleanup, __VlSymsp);
    }
}

void Vbeta_top::traceFullTop0(void* userp, VerilatedVcd* tracep) {
    Vbeta_top__Syms* __restrict vlSymsp = static_cast<Vbeta_top__Syms*>(userp);
    Vbeta_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceFullSub0(userp, tracep);
    }
}

void Vbeta_top::traceFullSub0(void* userp, VerilatedVcd* tracep) {
    Vbeta_top__Syms* __restrict vlSymsp = static_cast<Vbeta_top__Syms*>(userp);
    Vbeta_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->fullIData(oldp+1,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_result_int),32);
        tracep->fullSData(oldp+2,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int),12);
        tracep->fullIData(oldp+3,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm20_int),20);
        tracep->fullIData(oldp+4,(((0U == (3U & (vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                                 >> 0x16U)))
                                    ? vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int
                                   [(0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                              >> 0xfU))]
                                    : ((1U == (3U & 
                                               (vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                                >> 0x16U)))
                                        ? (vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm20_int 
                                           << 0xcU)
                                        : 0U))),32);
        tracep->fullIData(oldp+5,(((0x200000U & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int)
                                    ? ((0x100000U & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int)
                                        ? 0U : vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm20_int)
                                    : ((0x100000U & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int)
                                        ? ((0x80000U 
                                            & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int)
                                            ? (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int)
                                            : ((0x800U 
                                                & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int))
                                                ? (0xfffff000U 
                                                   | (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int))
                                                : (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int)))
                                        : vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int
                                       [(0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                  >> 0x14U))]))),32);
        tracep->fullCData(oldp+6,((0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                            >> 7U))),5);
        tracep->fullCData(oldp+7,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_rd_addr_int),5);
        tracep->fullIData(oldp+8,(vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int),25);
        tracep->fullIData(oldp+9,(vlTOPp->beta_top__DOT__pipe0__DOT__pip_next_pc_int),32);
        tracep->fullBit(oldp+10,(vlTOPp->beta_top__DOT__pipe0__DOT__pip_new_instr_int));
        tracep->fullIData(oldp+11,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_next_pc_int),32);
        tracep->fullBit(oldp+12,(vlTOPp->beta_top__DOT__reg_wr_en_int));
        tracep->fullBit(oldp+13,(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__new_instr_int));
        tracep->fullBit(oldp+14,(((IData)(vlTOPp->beta_top__DOT__reg_wr_en_int) 
                                  | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int))));
        tracep->fullBit(oldp+15,(vlTOPp->beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int));
        tracep->fullIData(oldp+16,(vlTOPp->beta_top__DOT__if_stage__DOT__curr_pc_int),32);
        tracep->fullIData(oldp+17,(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__instr_int),32);
        tracep->fullBit(oldp+18,(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__instr_req_int));
        tracep->fullIData(oldp+19,(vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int),32);
        tracep->fullSData(oldp+20,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int),12);
        tracep->fullIData(oldp+21,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset20_int),20);
        tracep->fullIData(oldp+22,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int),32);
        tracep->fullIData(oldp+23,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int),32);
        tracep->fullIData(oldp+24,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int),25);
        tracep->fullIData(oldp+25,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_next_pc_int),32);
        tracep->fullBit(oldp+26,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_new_instr_int));
        tracep->fullBit(oldp+27,(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__if_stage_busy_int));
        tracep->fullBit(oldp+28,(vlTOPp->beta_top__DOT__dec_stage__DOT__new_instruction_latch));
        tracep->fullBit(oldp+29,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_exe_stage_busy_int));
        tracep->fullBit(oldp+30,(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip0_stall_int));
        tracep->fullBit(oldp+31,(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip0_flush_int));
        tracep->fullBit(oldp+32,(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_stall_int));
        tracep->fullBit(oldp+33,(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_flush_int));
        tracep->fullBit(oldp+34,(vlTOPp->beta_top__DOT__first_reset));
        tracep->fullCData(oldp+35,(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int),2);
        tracep->fullCData(oldp+36,((0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                             >> 0xfU))),5);
        tracep->fullCData(oldp+37,((0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                             >> 0x14U))),5);
        tracep->fullIData(oldp+38,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int
                                   [(0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                              >> 0xfU))]),32);
        tracep->fullIData(oldp+39,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int
                                   [(0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                              >> 0x14U))]),32);
        tracep->fullSData(oldp+40,(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int),9);
        tracep->fullBit(oldp+41,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__invalid_instr_int));
        tracep->fullBit(oldp+42,(((IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__new_instruction_latch) 
                                  & (IData)(vlTOPp->beta_top__DOT__reg_wr_en_int))));
        tracep->fullCData(oldp+43,((0x7fU & vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int)),7);
        tracep->fullCData(oldp+44,((7U & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                          >> 0xcU))),3);
        tracep->fullCData(oldp+45,((0x7fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                             >> 0x19U))),7);
        tracep->fullSData(oldp+46,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__cu_addr_int),9);
        tracep->fullBit(oldp+47,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int));
        tracep->fullBit(oldp+48,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int));
        tracep->fullBit(oldp+49,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__invalid_opcode_int));
        tracep->fullIData(oldp+50,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0]),32);
        tracep->fullIData(oldp+51,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[1]),32);
        tracep->fullIData(oldp+52,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[2]),32);
        tracep->fullIData(oldp+53,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[3]),32);
        tracep->fullIData(oldp+54,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[4]),32);
        tracep->fullIData(oldp+55,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[5]),32);
        tracep->fullIData(oldp+56,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[6]),32);
        tracep->fullIData(oldp+57,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[7]),32);
        tracep->fullIData(oldp+58,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[8]),32);
        tracep->fullIData(oldp+59,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[9]),32);
        tracep->fullIData(oldp+60,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[10]),32);
        tracep->fullIData(oldp+61,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[11]),32);
        tracep->fullIData(oldp+62,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[12]),32);
        tracep->fullIData(oldp+63,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[13]),32);
        tracep->fullIData(oldp+64,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[14]),32);
        tracep->fullIData(oldp+65,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[15]),32);
        tracep->fullIData(oldp+66,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[16]),32);
        tracep->fullIData(oldp+67,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[17]),32);
        tracep->fullIData(oldp+68,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[18]),32);
        tracep->fullIData(oldp+69,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[19]),32);
        tracep->fullIData(oldp+70,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[20]),32);
        tracep->fullIData(oldp+71,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[21]),32);
        tracep->fullIData(oldp+72,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[22]),32);
        tracep->fullIData(oldp+73,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[23]),32);
        tracep->fullIData(oldp+74,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[24]),32);
        tracep->fullIData(oldp+75,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[25]),32);
        tracep->fullIData(oldp+76,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[26]),32);
        tracep->fullIData(oldp+77,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[27]),32);
        tracep->fullIData(oldp+78,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[28]),32);
        tracep->fullIData(oldp+79,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[29]),32);
        tracep->fullIData(oldp+80,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[30]),32);
        tracep->fullIData(oldp+81,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[31]),32);
        tracep->fullIData(oldp+82,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__write_proc__DOT__unnamedblk1__DOT__i),32);
        tracep->fullIData(oldp+83,((0x7ffffU & vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int)),19);
        tracep->fullCData(oldp+84,(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int),3);
        tracep->fullIData(oldp+85,(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int),32);
        tracep->fullCData(oldp+86,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_alu_op_int),5);
        tracep->fullCData(oldp+87,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int),5);
        tracep->fullIData(oldp+88,(((3U == (3U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int)))
                                     ? vlTOPp->beta_top__DOT__exe_stage__DOT__bju__DOT__bju_selected_data_int
                                     : (vlTOPp->beta_top__DOT__pipe1__DOT__pip_next_pc_int 
                                        + vlTOPp->beta_top__DOT__exe_stage__DOT__bju__DOT__bju_selected_data_int))),32);
        tracep->fullIData(oldp+89,(((IData)(4U) + vlTOPp->beta_top__DOT__pipe1__DOT__pip_next_pc_int)),32);
        tracep->fullCData(oldp+90,(((0x20U & ((vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                               >> 3U) 
                                              & ((~ 
                                                  (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                                   >> 9U)) 
                                                 << 5U))) 
                                    | ((0x10U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                                 << 2U)) 
                                       | ((8U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                                 >> 0xdU)) 
                                          | (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu_size_int) 
                                              << 1U) 
                                             | (1U 
                                                & ((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int) 
                                                   >> 1U))))))),6);
        tracep->fullBit(oldp+91,((1U & (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int) 
                                         >> 1U) | (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int)))));
        tracep->fullCData(oldp+92,((3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                          >> 6U))),2);
        tracep->fullBit(oldp+93,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int));
        tracep->fullBit(oldp+94,(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_busy_int));
        tracep->fullCData(oldp+95,(vlTOPp->beta_top__DOT__exe_stage__DOT__shu_size_int),2);
        tracep->fullBit(oldp+96,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_busy_int));
        tracep->fullCData(oldp+97,((3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                          >> 0xaU))),2);
        tracep->fullBit(oldp+98,((1U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                        >> 9U))));
        tracep->fullBit(oldp+99,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int));
        tracep->fullIData(oldp+100,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_result_int),32);
        tracep->fullIData(oldp+101,(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int),32);
        tracep->fullCData(oldp+102,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm),2);
        tracep->fullCData(oldp+103,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm),2);
        tracep->fullBit(oldp+104,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__event_latch));
        tracep->fullCData(oldp+105,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_latch),2);
        tracep->fullCData(oldp+106,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_latch),2);
        tracep->fullIData(oldp+107,(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__status_comp_data),32);
        tracep->fullCData(oldp+108,((0x1fU & vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int)),5);
        tracep->fullCData(oldp+109,(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int),5);
        tracep->fullBit(oldp+110,(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_end));
        tracep->fullBit(oldp+111,(vlTOPp->beta_top__DOT__exe_stage__DOT__bju__DOT__bju_branch_taken_int));
        tracep->fullIData(oldp+112,(vlTOPp->beta_top__DOT__exe_stage__DOT__bju__DOT__bju_selected_data_int),32);
        tracep->fullIData(oldp+113,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_addr_int),32);
        tracep->fullCData(oldp+114,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_strb_int),4);
        tracep->fullBit(oldp+115,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_req_int));
        tracep->fullIData(oldp+116,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_data_int),32);
        tracep->fullIData(oldp+117,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_addr_int),32);
        tracep->fullCData(oldp+118,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_strb_int),4);
        tracep->fullBit(oldp+119,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_req_int));
        tracep->fullCData(oldp+120,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state),2);
        tracep->fullCData(oldp+121,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state),2);
        tracep->fullIData(oldp+122,(((0x800U & (IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int))
                                      ? (0xfffff000U 
                                         | (IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int))
                                      : (IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int))),32);
        tracep->fullBit(oldp+123,(vlTOPp->beta_top__DOT__pcu__DOT__ifs_triggered_int));
        tracep->fullBit(oldp+124,(vlTOPp->clk_i));
        tracep->fullBit(oldp+125,(vlTOPp->rstn_i));
        tracep->fullBit(oldp+126,(vlTOPp->instr_ready_i));
        tracep->fullBit(oldp+127,(vlTOPp->instr_valid_i));
        tracep->fullIData(oldp+128,(vlTOPp->instr_rdata_i),32);
        tracep->fullBit(oldp+129,(vlTOPp->instr_req_o));
        tracep->fullIData(oldp+130,(vlTOPp->instr_addr_o),32);
        tracep->fullBit(oldp+131,(vlTOPp->rdata_ready_i));
        tracep->fullBit(oldp+132,(vlTOPp->rdata_valid_i));
        tracep->fullIData(oldp+133,(vlTOPp->rdata_data_i),32);
        tracep->fullIData(oldp+134,(vlTOPp->rdata_addr_o),32);
        tracep->fullCData(oldp+135,(vlTOPp->rdata_strb_o),4);
        tracep->fullBit(oldp+136,(vlTOPp->rdata_req_o));
        tracep->fullBit(oldp+137,(vlTOPp->wdata_ready_i));
        tracep->fullBit(oldp+138,(vlTOPp->wdata_valid_i));
        tracep->fullIData(oldp+139,(vlTOPp->wdata_data_o),32);
        tracep->fullIData(oldp+140,(vlTOPp->wdata_addr_o),32);
        tracep->fullCData(oldp+141,(vlTOPp->wdata_strb_o),4);
        tracep->fullBit(oldp+142,(vlTOPp->wdata_req_o));
        tracep->fullIData(oldp+143,(vlTOPp->result_o),32);
        tracep->fullBit(oldp+144,(vlTOPp->alu_op_end_o));
        tracep->fullIData(oldp+145,(0x20U),32);
        tracep->fullBit(oldp+146,(1U));
        tracep->fullIData(oldp+147,(0U),32);
        tracep->fullBit(oldp+148,(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__status_flag_int));
        tracep->fullIData(oldp+149,(0x20U),32);
        tracep->fullIData(oldp+150,(3U),32);
        tracep->fullBit(oldp+151,(vlTOPp->beta_top__DOT__pcu__DOT__decs_triggered_int));
        tracep->fullBit(oldp+152,(vlTOPp->beta_top__DOT__pcu__DOT__exes_triggered_int));
        tracep->fullBit(oldp+153,(vlTOPp->beta_top__DOT__pcu__DOT__ifs_halt_int));
        tracep->fullBit(oldp+154,(vlTOPp->beta_top__DOT__pcu__DOT__decs_halt_int));
        tracep->fullBit(oldp+155,(vlTOPp->beta_top__DOT__pcu__DOT__exes_halt_int));
        tracep->fullIData(oldp+156,(0x20U),32);
        tracep->fullIData(oldp+157,(2U),32);
        tracep->fullCData(oldp+158,(0U),2);
        tracep->fullCData(oldp+159,(1U),2);
        tracep->fullCData(oldp+160,(2U),2);
        tracep->fullCData(oldp+161,(4U),5);
        tracep->fullCData(oldp+162,(0xdU),5);
        tracep->fullCData(oldp+163,(5U),5);
        tracep->fullCData(oldp+164,(0xcU),5);
        tracep->fullCData(oldp+165,(0x1bU),5);
        tracep->fullCData(oldp+166,(0x19U),5);
        tracep->fullCData(oldp+167,(0x18U),5);
        tracep->fullCData(oldp+168,(0U),5);
        tracep->fullCData(oldp+169,(8U),5);
        tracep->fullCData(oldp+170,(0U),3);
        tracep->fullCData(oldp+171,(1U),3);
        tracep->fullCData(oldp+172,(2U),3);
        tracep->fullCData(oldp+173,(3U),3);
        tracep->fullCData(oldp+174,(4U),3);
        tracep->fullCData(oldp+175,(5U),3);
        tracep->fullCData(oldp+176,(6U),3);
        tracep->fullCData(oldp+177,(7U),3);
        tracep->fullCData(oldp+178,(3U),2);
        tracep->fullBit(oldp+179,(0U));
    }
}
