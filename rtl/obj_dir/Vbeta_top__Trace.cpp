// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vbeta_top__Syms.h"


void Vbeta_top::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    Vbeta_top__Syms* __restrict vlSymsp = static_cast<Vbeta_top__Syms*>(userp);
    Vbeta_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void Vbeta_top::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    Vbeta_top__Syms* __restrict vlSymsp = static_cast<Vbeta_top__Syms*>(userp);
    Vbeta_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[1U])) {
            tracep->chgIData(oldp+0,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_result_int),32);
            tracep->chgSData(oldp+1,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int),12);
            tracep->chgIData(oldp+2,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm20_int),20);
            tracep->chgIData(oldp+3,(((0U == (3U & 
                                              (vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                               >> 0x16U)))
                                       ? vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int
                                      [(0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                 >> 0xfU))]
                                       : ((1U == (3U 
                                                  & (vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                                     >> 0x16U)))
                                           ? (vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm20_int 
                                              << 0xcU)
                                           : 0U))),32);
            tracep->chgIData(oldp+4,(((0x200000U & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int)
                                       ? ((0x100000U 
                                           & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int)
                                           ? 0U : vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm20_int)
                                       : ((0x100000U 
                                           & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int)
                                           ? ((0x80000U 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int)
                                               ? (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int)
                                               : ((0x800U 
                                                   & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int))
                                                   ? 
                                                  (0xfffff000U 
                                                   | (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int))
                                                   : (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int)))
                                           : vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int
                                          [(0x1fU & 
                                            (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                             >> 0x14U))]))),32);
            tracep->chgCData(oldp+5,((0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                               >> 7U))),5);
            tracep->chgCData(oldp+6,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_rd_addr_int),5);
            tracep->chgIData(oldp+7,(vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int),25);
            tracep->chgIData(oldp+8,(vlTOPp->beta_top__DOT__pipe0__DOT__pip_next_pc_int),32);
            tracep->chgBit(oldp+9,(vlTOPp->beta_top__DOT__pipe0__DOT__pip_new_instr_int));
            tracep->chgIData(oldp+10,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_next_pc_int),32);
            tracep->chgBit(oldp+11,(vlTOPp->beta_top__DOT__reg_wr_en_int));
            tracep->chgBit(oldp+12,(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__new_instr_int));
            tracep->chgBit(oldp+13,(((IData)(vlTOPp->beta_top__DOT__reg_wr_en_int) 
                                     | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int))));
            tracep->chgBit(oldp+14,(vlTOPp->beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int));
            tracep->chgIData(oldp+15,(vlTOPp->beta_top__DOT__if_stage__DOT__curr_pc_int),32);
            tracep->chgIData(oldp+16,(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__instr_int),32);
            tracep->chgBit(oldp+17,(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__instr_req_int));
            tracep->chgIData(oldp+18,(vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int),32);
            tracep->chgSData(oldp+19,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int),12);
            tracep->chgIData(oldp+20,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset20_int),20);
            tracep->chgIData(oldp+21,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int),32);
            tracep->chgIData(oldp+22,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int),32);
            tracep->chgIData(oldp+23,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int),25);
            tracep->chgIData(oldp+24,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_next_pc_int),32);
            tracep->chgBit(oldp+25,(vlTOPp->beta_top__DOT__pipe1__DOT__pip_new_instr_int));
            tracep->chgBit(oldp+26,(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__if_stage_busy_int));
            tracep->chgBit(oldp+27,(vlTOPp->beta_top__DOT__dec_stage__DOT__new_instruction_latch));
            tracep->chgBit(oldp+28,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_exe_stage_busy_int));
            tracep->chgBit(oldp+29,(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip0_stall_int));
            tracep->chgBit(oldp+30,(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip0_flush_int));
            tracep->chgBit(oldp+31,(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_stall_int));
            tracep->chgBit(oldp+32,(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_flush_int));
            tracep->chgBit(oldp+33,(vlTOPp->beta_top__DOT__first_reset));
            tracep->chgCData(oldp+34,(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int),2);
            tracep->chgCData(oldp+35,((0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                >> 0xfU))),5);
            tracep->chgCData(oldp+36,((0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                >> 0x14U))),5);
            tracep->chgIData(oldp+37,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int
                                      [(0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                 >> 0xfU))]),32);
            tracep->chgIData(oldp+38,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int
                                      [(0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                 >> 0x14U))]),32);
            tracep->chgSData(oldp+39,(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int),9);
            tracep->chgBit(oldp+40,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__invalid_instr_int));
            tracep->chgBit(oldp+41,(((IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__new_instruction_latch) 
                                     & (IData)(vlTOPp->beta_top__DOT__reg_wr_en_int))));
            tracep->chgCData(oldp+42,((0x7fU & vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int)),7);
            tracep->chgCData(oldp+43,((7U & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                             >> 0xcU))),3);
            tracep->chgCData(oldp+44,((0x7fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                >> 0x19U))),7);
            tracep->chgSData(oldp+45,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__cu_addr_int),9);
            tracep->chgBit(oldp+46,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int));
            tracep->chgBit(oldp+47,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int));
            tracep->chgBit(oldp+48,(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__invalid_opcode_int));
            tracep->chgIData(oldp+49,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0]),32);
            tracep->chgIData(oldp+50,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[1]),32);
            tracep->chgIData(oldp+51,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[2]),32);
            tracep->chgIData(oldp+52,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[3]),32);
            tracep->chgIData(oldp+53,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[4]),32);
            tracep->chgIData(oldp+54,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[5]),32);
            tracep->chgIData(oldp+55,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[6]),32);
            tracep->chgIData(oldp+56,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[7]),32);
            tracep->chgIData(oldp+57,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[8]),32);
            tracep->chgIData(oldp+58,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[9]),32);
            tracep->chgIData(oldp+59,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[10]),32);
            tracep->chgIData(oldp+60,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[11]),32);
            tracep->chgIData(oldp+61,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[12]),32);
            tracep->chgIData(oldp+62,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[13]),32);
            tracep->chgIData(oldp+63,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[14]),32);
            tracep->chgIData(oldp+64,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[15]),32);
            tracep->chgIData(oldp+65,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[16]),32);
            tracep->chgIData(oldp+66,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[17]),32);
            tracep->chgIData(oldp+67,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[18]),32);
            tracep->chgIData(oldp+68,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[19]),32);
            tracep->chgIData(oldp+69,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[20]),32);
            tracep->chgIData(oldp+70,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[21]),32);
            tracep->chgIData(oldp+71,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[22]),32);
            tracep->chgIData(oldp+72,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[23]),32);
            tracep->chgIData(oldp+73,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[24]),32);
            tracep->chgIData(oldp+74,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[25]),32);
            tracep->chgIData(oldp+75,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[26]),32);
            tracep->chgIData(oldp+76,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[27]),32);
            tracep->chgIData(oldp+77,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[28]),32);
            tracep->chgIData(oldp+78,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[29]),32);
            tracep->chgIData(oldp+79,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[30]),32);
            tracep->chgIData(oldp+80,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[31]),32);
            tracep->chgIData(oldp+81,(vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__write_proc__DOT__unnamedblk1__DOT__i),32);
            tracep->chgIData(oldp+82,((0x7ffffU & vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int)),19);
            tracep->chgCData(oldp+83,(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int),3);
            tracep->chgIData(oldp+84,(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int),32);
            tracep->chgCData(oldp+85,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_alu_op_int),5);
            tracep->chgCData(oldp+86,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int),5);
            tracep->chgIData(oldp+87,(((3U == (3U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int)))
                                        ? vlTOPp->beta_top__DOT__exe_stage__DOT__bju__DOT__bju_selected_data_int
                                        : (vlTOPp->beta_top__DOT__pipe1__DOT__pip_next_pc_int 
                                           + vlTOPp->beta_top__DOT__exe_stage__DOT__bju__DOT__bju_selected_data_int))),32);
            tracep->chgIData(oldp+88,(((IData)(4U) 
                                       + vlTOPp->beta_top__DOT__pipe1__DOT__pip_next_pc_int)),32);
            tracep->chgCData(oldp+89,(((0x20U & ((vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                                  >> 3U) 
                                                 & ((~ 
                                                     (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                                      >> 9U)) 
                                                    << 5U))) 
                                       | ((0x10U & 
                                           (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                            << 2U)) 
                                          | ((8U & 
                                              (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                               >> 0xdU)) 
                                             | (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu_size_int) 
                                                 << 1U) 
                                                | (1U 
                                                   & ((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int) 
                                                      >> 1U))))))),6);
            tracep->chgBit(oldp+90,((1U & (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int) 
                                            >> 1U) 
                                           | (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int)))));
            tracep->chgCData(oldp+91,((3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                             >> 6U))),2);
            tracep->chgBit(oldp+92,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int));
            tracep->chgBit(oldp+93,(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_busy_int));
            tracep->chgCData(oldp+94,(vlTOPp->beta_top__DOT__exe_stage__DOT__shu_size_int),2);
            tracep->chgBit(oldp+95,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_busy_int));
            tracep->chgCData(oldp+96,((3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                             >> 0xaU))),2);
            tracep->chgBit(oldp+97,((1U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                           >> 9U))));
            tracep->chgBit(oldp+98,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int));
            tracep->chgIData(oldp+99,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_result_int),32);
            tracep->chgIData(oldp+100,(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int),32);
            tracep->chgCData(oldp+101,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm),2);
            tracep->chgCData(oldp+102,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm),2);
            tracep->chgBit(oldp+103,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__event_latch));
            tracep->chgCData(oldp+104,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_latch),2);
            tracep->chgCData(oldp+105,(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_latch),2);
            tracep->chgIData(oldp+106,(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__status_comp_data),32);
            tracep->chgCData(oldp+107,((0x1fU & vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int)),5);
            tracep->chgCData(oldp+108,(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int),5);
            tracep->chgBit(oldp+109,(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_end));
            tracep->chgBit(oldp+110,(vlTOPp->beta_top__DOT__exe_stage__DOT__bju__DOT__bju_branch_taken_int));
            tracep->chgIData(oldp+111,(vlTOPp->beta_top__DOT__exe_stage__DOT__bju__DOT__bju_selected_data_int),32);
            tracep->chgIData(oldp+112,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_addr_int),32);
            tracep->chgCData(oldp+113,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_strb_int),4);
            tracep->chgBit(oldp+114,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_req_int));
            tracep->chgIData(oldp+115,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_data_int),32);
            tracep->chgIData(oldp+116,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_addr_int),32);
            tracep->chgCData(oldp+117,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_strb_int),4);
            tracep->chgBit(oldp+118,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_req_int));
            tracep->chgCData(oldp+119,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state),2);
            tracep->chgCData(oldp+120,(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state),2);
            tracep->chgIData(oldp+121,(((0x800U & (IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int))
                                         ? (0xfffff000U 
                                            | (IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int))
                                         : (IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int))),32);
            tracep->chgBit(oldp+122,(vlTOPp->beta_top__DOT__pcu__DOT__ifs_triggered_int));
        }
        tracep->chgBit(oldp+123,(vlTOPp->clk_i));
        tracep->chgBit(oldp+124,(vlTOPp->rstn_i));
        tracep->chgBit(oldp+125,(vlTOPp->instr_ready_i));
        tracep->chgBit(oldp+126,(vlTOPp->instr_valid_i));
        tracep->chgIData(oldp+127,(vlTOPp->instr_rdata_i),32);
        tracep->chgBit(oldp+128,(vlTOPp->instr_req_o));
        tracep->chgIData(oldp+129,(vlTOPp->instr_addr_o),32);
        tracep->chgBit(oldp+130,(vlTOPp->rdata_ready_i));
        tracep->chgBit(oldp+131,(vlTOPp->rdata_valid_i));
        tracep->chgIData(oldp+132,(vlTOPp->rdata_data_i),32);
        tracep->chgIData(oldp+133,(vlTOPp->rdata_addr_o),32);
        tracep->chgCData(oldp+134,(vlTOPp->rdata_strb_o),4);
        tracep->chgBit(oldp+135,(vlTOPp->rdata_req_o));
        tracep->chgBit(oldp+136,(vlTOPp->wdata_ready_i));
        tracep->chgBit(oldp+137,(vlTOPp->wdata_valid_i));
        tracep->chgIData(oldp+138,(vlTOPp->wdata_data_o),32);
        tracep->chgIData(oldp+139,(vlTOPp->wdata_addr_o),32);
        tracep->chgCData(oldp+140,(vlTOPp->wdata_strb_o),4);
        tracep->chgBit(oldp+141,(vlTOPp->wdata_req_o));
        tracep->chgIData(oldp+142,(vlTOPp->result_o),32);
        tracep->chgBit(oldp+143,(vlTOPp->alu_op_end_o));
    }
}

void Vbeta_top::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    Vbeta_top__Syms* __restrict vlSymsp = static_cast<Vbeta_top__Syms*>(userp);
    Vbeta_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
        vlTOPp->__Vm_traceActivity[1U] = 0U;
    }
}
