// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vbeta_top.h for the primary calling header

#include "Vbeta_top.h"
#include "Vbeta_top__Syms.h"

//==========

void Vbeta_top::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vbeta_top::eval\n"); );
    Vbeta_top__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vbeta_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        vlSymsp->__Vm_activity = true;
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("beta_top.sv", 15, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vbeta_top::_eval_initial_loop(Vbeta_top__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    vlSymsp->__Vm_activity = true;
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("beta_top.sv", 15, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void Vbeta_top::_sequent__TOP__3(Vbeta_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbeta_top::_sequent__TOP__3\n"); );
    Vbeta_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    CData/*6:0*/ __Vtableidx1;
    CData/*4:0*/ __Vtableidx2;
    CData/*1:0*/ __Vdly__beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int;
    CData/*0:0*/ __Vdly__beta_top__DOT__dec_stage__DOT__new_instruction_latch;
    CData/*4:0*/ __Vdlyvdim0__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v0;
    CData/*0:0*/ __Vdlyvset__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v0;
    CData/*0:0*/ __Vdlyvset__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v1;
    CData/*0:0*/ __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int;
    CData/*1:0*/ __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm;
    CData/*0:0*/ __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int;
    CData/*1:0*/ __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm;
    CData/*4:0*/ __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int;
    CData/*1:0*/ __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state;
    CData/*1:0*/ __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state;
    CData/*0:0*/ __Vdly__beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int;
    IData/*31:0*/ __Vdlyvval__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v0;
    IData/*31:0*/ __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int;
    // Body
    __Vdly__beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int 
        = vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int;
    __Vdly__beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int 
        = vlTOPp->beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int;
    __Vdly__beta_top__DOT__dec_stage__DOT__new_instruction_latch 
        = vlTOPp->beta_top__DOT__dec_stage__DOT__new_instruction_latch;
    __Vdlyvset__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v0 = 0U;
    __Vdlyvset__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v1 = 0U;
    __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state 
        = vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state;
    __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state 
        = vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state;
    __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int 
        = vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int;
    __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int 
        = vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int;
    __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm 
        = vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm;
    __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int 
        = vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int;
    __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm 
        = vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm;
    __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int 
        = vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int;
    if ((1U & (~ (IData)(vlTOPp->rstn_i)))) {
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__write_proc__DOT__unnamedblk1__DOT__i = 0x20U;
    }
    vlTOPp->beta_top__DOT__first_reset = (1U & (~ (IData)(vlTOPp->rstn_i)));
    if ((1U & ((~ (IData)(vlTOPp->rstn_i)) | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_flush_int)))) {
        vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset20_int = 0U;
    } else {
        if ((1U & (~ (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_stall_int)))) {
            vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset20_int 
                = vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm20_int;
        }
    }
    if (vlTOPp->rstn_i) {
        if (vlTOPp->beta_top__DOT__pipe0__DOT__pip_new_instr_int) {
            __Vdly__beta_top__DOT__dec_stage__DOT__new_instruction_latch = 1U;
        } else {
            if (((IData)(vlTOPp->beta_top__DOT__reg_wr_en_int) 
                 & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__new_instruction_latch))) {
                __Vdly__beta_top__DOT__dec_stage__DOT__new_instruction_latch = 0U;
            }
        }
    } else {
        __Vdly__beta_top__DOT__dec_stage__DOT__new_instruction_latch = 0U;
    }
    if ((1U & ((~ (IData)(vlTOPp->rstn_i)) | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_flush_int)))) {
        vlTOPp->beta_top__DOT__pipe1__DOT__pip_new_instr_int = 0U;
    } else {
        if ((1U & (~ (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_stall_int)))) {
            vlTOPp->beta_top__DOT__pipe1__DOT__pip_new_instr_int 
                = vlTOPp->beta_top__DOT__pipe0__DOT__pip_new_instr_int;
        }
    }
    if ((1U & ((~ (IData)(vlTOPp->rstn_i)) | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_flush_int)))) {
        vlTOPp->beta_top__DOT__pipe1__DOT__pip_next_pc_int = 0U;
    } else {
        if ((1U & (~ (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_stall_int)))) {
            vlTOPp->beta_top__DOT__pipe1__DOT__pip_next_pc_int 
                = vlTOPp->beta_top__DOT__pipe0__DOT__pip_next_pc_int;
        }
    }
    if (vlTOPp->rstn_i) {
        if (((IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__new_instruction_latch) 
             & (IData)(vlTOPp->beta_top__DOT__reg_wr_en_int))) {
            if ((0U != (IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_rd_addr_int))) {
                __Vdlyvval__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v0 
                    = vlTOPp->beta_top__DOT__exe_stage__DOT__exe_result_int;
                __Vdlyvset__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v0 = 1U;
                __Vdlyvdim0__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v0 
                    = vlTOPp->beta_top__DOT__pipe1__DOT__pip_rd_addr_int;
            }
        }
    } else {
        __Vdlyvset__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v1 = 1U;
    }
    if (vlTOPp->rstn_i) {
        if ((((0U != (3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                            >> 6U))) & (2U <= (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu_size_int))) 
             & (2U != (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_latch)))) {
            if ((0U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm))) {
                if ((1U & ((~ (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int)) 
                           | (~ (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_busy_int))))) {
                    __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int = 1U;
                    __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm = 1U;
                }
            } else {
                if ((1U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm))) {
                    if (vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_busy_int) {
                        __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm = 2U;
                    }
                } else {
                    if ((2U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm))) {
                        if ((1U & (~ (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_busy_int)))) {
                            __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int = 0U;
                            __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm = 0U;
                        }
                    } else {
                        __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int = 0U;
                        __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm = 0U;
                    }
                }
            }
        }
    } else {
        __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int = 0U;
        __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm = 0U;
    }
    if (vlTOPp->rstn_i) {
        if (((vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
              >> 8U) & (2U != (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_latch)))) {
            if ((0U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm))) {
                if ((1U & ((~ (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int)) 
                           | (~ (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_busy_int))))) {
                    __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int = 1U;
                    __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm = 1U;
                }
            } else {
                if ((1U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm))) {
                    if (vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_busy_int) {
                        __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int = 0U;
                        __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm = 2U;
                    }
                } else {
                    if ((2U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm))) {
                        if ((1U & (~ (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_busy_int)))) {
                            __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int = 0U;
                            __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm = 0U;
                        }
                    } else {
                        __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int = 0U;
                        __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm = 0U;
                    }
                }
            }
        }
    } else {
        __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int = 0U;
        __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm = 0U;
    }
    __Vtableidx1 = (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_latch) 
                     << 5U) | (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_busy_int) 
                                << 4U) | (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_latch) 
                                           << 2U) | 
                                          (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_busy_int) 
                                            << 1U) 
                                           | (IData)(vlTOPp->rstn_i)))));
    if ((1U & vlTOPp->__Vtablechg1[__Vtableidx1])) {
        vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__event_latch 
            = vlTOPp->__Vtable1_beta_top__DOT__exe_stage__DOT__exe_cu__DOT__event_latch
            [__Vtableidx1];
    }
    if ((2U & vlTOPp->__Vtablechg1[__Vtableidx1])) {
        vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_latch 
            = vlTOPp->__Vtable1_beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_latch
            [__Vtableidx1];
    }
    if ((4U & vlTOPp->__Vtablechg1[__Vtableidx1])) {
        vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_latch 
            = vlTOPp->__Vtable1_beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_latch
            [__Vtableidx1];
    }
    vlTOPp->beta_top__DOT__dec_stage__DOT__new_instruction_latch 
        = __Vdly__beta_top__DOT__dec_stage__DOT__new_instruction_latch;
    vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm 
        = __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm;
    vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm 
        = __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm;
    if ((1U & ((~ (IData)(vlTOPp->rstn_i)) | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip0_flush_int)))) {
        vlTOPp->beta_top__DOT__pipe0__DOT__pip_new_instr_int = 0U;
    } else {
        if ((1U & (~ (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip0_stall_int)))) {
            vlTOPp->beta_top__DOT__pipe0__DOT__pip_new_instr_int 
                = vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__new_instr_int;
        }
    }
    if ((1U & ((~ (IData)(vlTOPp->rstn_i)) | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip0_flush_int)))) {
        vlTOPp->beta_top__DOT__pipe0__DOT__pip_next_pc_int = 0U;
    } else {
        if ((1U & (~ (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip0_stall_int)))) {
            vlTOPp->beta_top__DOT__pipe0__DOT__pip_next_pc_int 
                = vlTOPp->beta_top__DOT__if_stage__DOT__curr_pc_int;
        }
    }
    if ((1U & ((~ (IData)(vlTOPp->rstn_i)) | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_flush_int)))) {
        vlTOPp->beta_top__DOT__pipe1__DOT__pip_rd_addr_int = 0U;
    } else {
        if ((1U & (~ (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_stall_int)))) {
            vlTOPp->beta_top__DOT__pipe1__DOT__pip_rd_addr_int 
                = (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                            >> 7U));
        }
    }
    if (vlTOPp->rstn_i) {
        if (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int) 
             & (~ (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_end)))) {
            vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_busy_int = 1U;
            if ((1U == (3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                              >> 6U)))) {
                __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int 
                    = ((0U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int))
                        ? (0xfffffffeU & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int 
                                          << 1U)) : 
                       (0xfffffffeU & (vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int 
                                       << 1U)));
                __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int 
                    = (0x1fU & ((IData)(1U) + (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int)));
            } else {
                if ((2U == (3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                  >> 6U)))) {
                    __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int 
                        = ((0U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int))
                            ? (0x7fffffffU & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int 
                                              >> 1U))
                            : (0x7fffffffU & (vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int 
                                              >> 1U)));
                    __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int 
                        = (0x1fU & ((IData)(1U) + (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int)));
                } else {
                    if ((3U == (3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                      >> 6U)))) {
                        __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int 
                            = ((0U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int))
                                ? ((0x80000000U & vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int)
                                    ? (0x80000000U 
                                       | (0x7fffffffU 
                                          & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int 
                                             >> 1U)))
                                    : (0x7fffffffU 
                                       & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int 
                                          >> 1U))) : 
                               ((0x80000000U & vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int)
                                 ? (0x80000000U | (0x7fffffffU 
                                                   & (vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int 
                                                      >> 1U)))
                                 : (0x7fffffffU & (vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int 
                                                   >> 1U))));
                        __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int 
                            = (0x1fU & ((IData)(1U) 
                                        + (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int)));
                    }
                }
            }
            if (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int) 
                 >= ((0x1fU & vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int) 
                     - (IData)(1U)))) {
                vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_end = 1U;
                vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_busy_int = 0U;
                __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int = 0U;
            }
        } else {
            vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_busy_int = 0U;
            __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int = 0U;
            vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_end = 0U;
        }
    } else {
        __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int = 0U;
        vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_busy_int = 0U;
        __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int = 0U;
        vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_end = 0U;
    }
    if (vlTOPp->rstn_i) {
        if ((0U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state))) {
            if (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int) 
                 & (~ (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                       >> 9U)))) {
                vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_busy_int = 1U;
                vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_req_int = 1U;
                vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_addr_int 
                    = vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int;
                vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_strb_int 
                    = ((0U == (3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                     >> 0xaU))) ? 0xfU
                        : ((1U == (3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                         >> 0xaU)))
                            ? 3U : ((2U == (3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                                  >> 0xaU)))
                                     ? 1U : 0U)));
                __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state = 1U;
            }
        } else {
            if ((1U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state))) {
                if (vlTOPp->rdata_ready_i) {
                    vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_req_int = 0U;
                    __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state = 2U;
                }
            } else {
                if ((2U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state))) {
                    if (vlTOPp->rdata_valid_i) {
                        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_busy_int = 0U;
                        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_result_int 
                            = vlTOPp->rdata_data_i;
                        __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state = 0U;
                    }
                } else {
                    __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state = 0U;
                }
            }
        }
    } else {
        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_addr_int = 0U;
        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_strb_int = 0U;
        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_req_int = 0U;
        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_busy_int = 0U;
        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_result_int = 0U;
        __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state = 0U;
    }
    if (vlTOPp->rstn_i) {
        if ((0U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state))) {
            if (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int) 
                 & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                    >> 9U))) {
                vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_busy_int = 1U;
                vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_req_int = 1U;
                vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_data_int 
                    = vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int;
                vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_addr_int 
                    = (vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int 
                       + ((0x800U & (IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int))
                           ? (0xfffff000U | (IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int))
                           : (IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int)));
                vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_strb_int 
                    = ((0U == (3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                     >> 0xaU))) ? 0xfU
                        : ((1U == (3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                         >> 0xaU)))
                            ? 3U : ((2U == (3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                                  >> 0xaU)))
                                     ? 1U : 0U)));
                __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state = 1U;
            }
        } else {
            if ((1U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state))) {
                if (vlTOPp->wdata_ready_i) {
                    vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_req_int = 0U;
                    __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state = 2U;
                }
            } else {
                if ((2U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state))) {
                    if (vlTOPp->wdata_valid_i) {
                        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_busy_int = 0U;
                        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_result_int = 0U;
                        __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state = 0U;
                    }
                } else {
                    __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state = 0U;
                }
            }
        }
    } else {
        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_data_int = 0U;
        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_addr_int = 0U;
        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_strb_int = 0U;
        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_req_int = 0U;
        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_busy_int = 0U;
        vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_result_int = 0U;
        __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state = 0U;
    }
    vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int 
        = __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int;
    vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int 
        = __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int;
    vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int 
        = __Vdly__beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int;
    vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state 
        = __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state;
    vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state 
        = __Vdly__beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state;
    vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int 
        = __Vdly__beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int;
    if (vlTOPp->rstn_i) {
        if ((((IData)(vlTOPp->beta_top__DOT__reg_wr_en_int) 
              | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int)) 
             & (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int))) {
            vlTOPp->beta_top__DOT__if_stage__DOT__curr_pc_int 
                = vlTOPp->beta_top__DOT__exe_stage__DOT__exe_next_pc_int;
        }
    } else {
        vlTOPp->beta_top__DOT__if_stage__DOT__curr_pc_int = 0U;
    }
    if ((1U & ((~ (IData)(vlTOPp->rstn_i)) | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_flush_int)))) {
        vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int = 0U;
    } else {
        if ((1U & (~ (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_stall_int)))) {
            vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int 
                = ((0U == (3U & (vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                 >> 0x16U))) ? vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int
                   [(0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                              >> 0xfU))] : ((1U == 
                                             (3U & 
                                              (vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                               >> 0x16U)))
                                             ? (vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm20_int 
                                                << 0xcU)
                                             : 0U));
        }
    }
    vlTOPp->rdata_req_o = vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_req_int;
    vlTOPp->rdata_addr_o = vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_addr_int;
    vlTOPp->rdata_strb_o = vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_strb_int;
    vlTOPp->wdata_req_o = vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_req_int;
    vlTOPp->wdata_data_o = vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_data_int;
    vlTOPp->wdata_addr_o = vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_addr_int;
    vlTOPp->wdata_strb_o = vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_strb_int;
    if ((1U & ((~ (IData)(vlTOPp->rstn_i)) | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_flush_int)))) {
        vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int = 0U;
    } else {
        if ((1U & (~ (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_stall_int)))) {
            vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int 
                = vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int;
        }
    }
    if ((1U & ((~ (IData)(vlTOPp->rstn_i)) | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_flush_int)))) {
        vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int = 0U;
    } else {
        if ((1U & (~ (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_stall_int)))) {
            vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                = vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int;
        }
    }
    if ((1U & ((~ (IData)(vlTOPp->rstn_i)) | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_flush_int)))) {
        vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int = 0U;
    } else {
        if ((1U & (~ (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_stall_int)))) {
            vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int 
                = ((0x200000U & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int)
                    ? ((0x100000U & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int)
                        ? 0U : vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm20_int)
                    : ((0x100000U & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int)
                        ? ((0x80000U & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int)
                            ? (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int)
                            : ((0x800U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int))
                                ? (0xfffff000U | (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int))
                                : (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int)))
                        : vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int
                       [(0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                  >> 0x14U))]));
        }
    }
    if (__Vdlyvset__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v0) {
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[__Vdlyvdim0__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v0] 
            = __Vdlyvval__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v0;
    }
    if (__Vdlyvset__beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int__v1) {
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[1U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[2U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[3U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[4U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[5U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[6U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[7U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[8U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[9U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0xaU] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0xbU] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0xcU] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0xdU] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0xeU] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0xfU] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x10U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x11U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x12U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x13U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x14U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x15U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x16U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x17U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x18U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x19U] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x1aU] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x1bU] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x1cU] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x1dU] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x1eU] = 0U;
        vlTOPp->beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[0x1fU] = 0U;
    }
    vlTOPp->instr_addr_o = vlTOPp->beta_top__DOT__if_stage__DOT__curr_pc_int;
    vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int 
        = ((0x1cU & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                     >> 1U)) | (3U & vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int));
    vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_alu_op_int 
        = ((0x10U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                     >> 0xdU)) | (0xfU & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                          >> 0xcU)));
    vlTOPp->beta_top__DOT__exe_stage__DOT__shu_size_int 
        = (((IData)((0U != (0xfU & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int 
                                    >> 1U)))) << 1U) 
           | (1U & vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int));
    if ((1U & ((~ (IData)(vlTOPp->rstn_i)) | (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip0_flush_int)))) {
        vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int = 0U;
    } else {
        if ((1U & (~ (IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip0_stall_int)))) {
            vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                = vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__instr_int;
        }
    }
    vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int 
        = ((8U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_alu_op_int))
            ? (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int 
               + vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int)
            : ((4U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_alu_op_int))
                ? ((IData)(1U) + (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int 
                                  + (~ vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int)))
                : ((1U == (3U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_alu_op_int)))
                    ? (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int 
                       & vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int)
                    : ((2U == (3U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_alu_op_int)))
                        ? (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int 
                           | vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int)
                        : ((3U == (3U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_alu_op_int)))
                            ? (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int 
                               ^ vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int)
                            : vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int)))));
    vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__status_comp_data 
        = ((IData)(1U) + (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int 
                          + (~ vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int)));
    if ((0U == vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__status_comp_data)) {
        vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
            = (4U | (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
        vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
            = (6U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
        vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
            = (5U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
    } else {
        if ((0x10U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_alu_op_int))) {
            if ((0x10U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_alu_op_int))) {
                if ((1U & ((((vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__status_comp_data 
                              & vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int) 
                             >> 0x1fU) | ((vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__status_comp_data 
                                           >> 0x1fU) 
                                          & (~ (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int 
                                                >> 0x1fU)))) 
                           | ((~ (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int 
                                  >> 0x1fU)) & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_b_int 
                                                >> 0x1fU))))) {
                    vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                        = (3U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
                    vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                        = (6U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
                    vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                        = (2U | (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
                } else {
                    vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                        = (3U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
                    vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                        = (6U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
                    vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                        = (5U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
                }
            } else {
                vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                    = (3U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
                vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                    = (6U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
                vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                    = (5U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
            }
        } else {
            if ((0x80000000U & vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__status_comp_data)) {
                vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                    = (3U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
                vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                    = (6U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
                vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                    = (2U | (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
            } else {
                vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                    = (3U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
                vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                    = (6U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
                vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int 
                    = (5U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int));
            }
        }
    }
    vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_exe_stage_busy_int 
        = (1U & ((~ (((0U == (3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                    >> 6U))) | (1U 
                                                >= (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu_size_int))) 
                     | (2U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_latch)))) 
                 | (~ ((~ (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                           >> 8U)) | (2U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_latch))))));
    if ((2U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int))) {
        vlTOPp->beta_top__DOT__exe_stage__DOT__bju__DOT__bju_branch_taken_int = 0U;
    } else {
        if ((1U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int))) {
            vlTOPp->beta_top__DOT__exe_stage__DOT__bju__DOT__bju_branch_taken_int 
                = (((2U >= (3U & ((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int) 
                                  >> 3U))) & ((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int) 
                                              >> (3U 
                                                  & ((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int) 
                                                     >> 3U)))) 
                   == (1U & (~ ((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int) 
                                >> 2U))));
        }
    }
    if ((2U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int))) {
        vlTOPp->beta_top__DOT__exe_stage__DOT__exe_result_int 
            = ((IData)(4U) + vlTOPp->beta_top__DOT__pipe1__DOT__pip_next_pc_int);
    } else {
        if ((1U & ((vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                    >> 8U) & (~ (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                 >> 9U))))) {
            vlTOPp->beta_top__DOT__exe_stage__DOT__exe_result_int 
                = vlTOPp->beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_result_int;
        } else {
            if ((4U & vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int)) {
                vlTOPp->beta_top__DOT__exe_stage__DOT__exe_result_int 
                    = (vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int 
                       + vlTOPp->beta_top__DOT__pipe1__DOT__pip_next_pc_int);
            } else {
                if ((1U & (~ ((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int) 
                              >> 1U)))) {
                    if ((0U != (3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                      >> 6U)))) {
                        if ((0U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu_size_int))) {
                            vlTOPp->beta_top__DOT__exe_stage__DOT__exe_result_int 
                                = vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int;
                        } else {
                            if ((1U == (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__shu_size_int))) {
                                if ((1U == (3U & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                                  >> 6U)))) {
                                    vlTOPp->beta_top__DOT__exe_stage__DOT__exe_result_int 
                                        = (0xfffffffeU 
                                           & (vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int 
                                              << 1U));
                                } else {
                                    if ((2U == (3U 
                                                & (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                                   >> 6U)))) {
                                        vlTOPp->beta_top__DOT__exe_stage__DOT__exe_result_int 
                                            = (0x7fffffffU 
                                               & (vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int 
                                                  >> 1U));
                                    } else {
                                        if ((3U == 
                                             (3U & 
                                              (vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                               >> 6U)))) {
                                            vlTOPp->beta_top__DOT__exe_stage__DOT__exe_result_int 
                                                = (
                                                   (0x80000000U 
                                                    & vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int)
                                                    ? 
                                                   (0x80000000U 
                                                    | (0x7fffffffU 
                                                       & (vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int 
                                                          >> 1U)))
                                                    : 
                                                   (0x7fffffffU 
                                                    & (vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int 
                                                       >> 1U)));
                                        }
                                    }
                                }
                            } else {
                                vlTOPp->beta_top__DOT__exe_stage__DOT__exe_result_int 
                                    = vlTOPp->beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int;
                            }
                        }
                    } else {
                        vlTOPp->beta_top__DOT__exe_stage__DOT__exe_result_int 
                            = ((0x10000U & vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int)
                                ? (1U & ((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int) 
                                         >> 1U)) : vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int);
                    }
                }
            }
        }
    }
    vlTOPp->beta_top__DOT__exe_stage__DOT__bju__DOT__bju_selected_data_int 
        = ((2U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int))
            ? ((1U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int))
                ? ((0x80000U & vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset20_int)
                    ? ((0xfffff000U | (IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int)) 
                       + vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int)
                    : ((IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int) 
                       + vlTOPp->beta_top__DOT__pipe1__DOT__pip_operand_a_int))
                : ((0x80000U & vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset20_int)
                    ? (0xffe00000U | (vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset20_int 
                                      << 1U)) : (vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset20_int 
                                                 << 1U)))
            : ((1U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int))
                ? ((((2U >= (3U & ((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int) 
                                   >> 3U))) & ((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int) 
                                               >> (3U 
                                                   & ((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int) 
                                                      >> 3U)))) 
                    == (1U & (~ ((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int) 
                                 >> 2U)))) ? ((0x800U 
                                               & (IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int))
                                               ? (0xffffe000U 
                                                  | ((IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int) 
                                                     << 1U))
                                               : ((IData)(vlTOPp->beta_top__DOT__pipe1__DOT__pip_offset12_int) 
                                                  << 1U))
                    : 4U) : 0U));
    vlTOPp->beta_top__DOT__reg_wr_en_int = (1U & ((vlTOPp->beta_top__DOT__pipe1__DOT__pip_control_word_int 
                                                   >> 0x12U) 
                                                  & (~ (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_exe_stage_busy_int))));
    if (((((((((4U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                >> 2U))) | (0xdU == 
                                            (0x1fU 
                                             & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                >> 2U)))) 
              | (5U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                 >> 2U)))) | (0xcU 
                                              == (0x1fU 
                                                  & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                     >> 2U)))) 
            | (0x1bU == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                  >> 2U)))) | (0x19U 
                                               == (0x1fU 
                                                   & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                      >> 2U)))) 
          | (0x18U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                >> 2U)))) | (0U == 
                                             (0x1fU 
                                              & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                 >> 2U))))) {
        vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int 
            = (0xfffU & ((4U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                          >> 2U))) ? 
                         (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                          >> 0x14U) : ((0xdU == (0x1fU 
                                                 & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                    >> 2U)))
                                        ? 0U : ((5U 
                                                 == 
                                                 (0x1fU 
                                                  & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                     >> 2U)))
                                                 ? 0U
                                                 : 
                                                ((0xcU 
                                                  == 
                                                  (0x1fU 
                                                   & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                      >> 2U)))
                                                  ? 0U
                                                  : 
                                                 ((0x1bU 
                                                   == 
                                                   (0x1fU 
                                                    & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                       >> 2U)))
                                                   ? 0U
                                                   : 
                                                  ((0x19U 
                                                    == 
                                                    (0x1fU 
                                                     & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                        >> 2U)))
                                                    ? 
                                                   (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                    >> 0x14U)
                                                    : 
                                                   ((0x18U 
                                                     == 
                                                     (0x1fU 
                                                      & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                         >> 2U)))
                                                     ? 
                                                    ((0x800U 
                                                      & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                         >> 0x14U)) 
                                                     | ((0x400U 
                                                         & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                            << 3U)) 
                                                        | ((0x3f0U 
                                                            & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                               >> 0x15U)) 
                                                           | (0xfU 
                                                              & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                                 >> 8U)))))
                                                     : 
                                                    (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                     >> 0x14U)))))))));
        vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm20_int 
            = ((4U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                >> 2U))) ? 0U : (0xfffffU 
                                                 & ((0xdU 
                                                     == 
                                                     (0x1fU 
                                                      & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                         >> 2U)))
                                                     ? 
                                                    (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                     >> 0xcU)
                                                     : 
                                                    ((5U 
                                                      == 
                                                      (0x1fU 
                                                       & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                          >> 2U)))
                                                      ? 
                                                     (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                      >> 0xcU)
                                                      : 
                                                     ((0xcU 
                                                       == 
                                                       (0x1fU 
                                                        & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                           >> 2U)))
                                                       ? 0U
                                                       : 
                                                      ((0x1bU 
                                                        == 
                                                        (0x1fU 
                                                         & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                            >> 2U)))
                                                        ? 
                                                       ((0x80000U 
                                                         & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                            >> 0xcU)) 
                                                        | ((0x7f800U 
                                                            & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                               >> 1U)) 
                                                           | ((0x400U 
                                                               & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                                  >> 0xaU)) 
                                                              | (0x3ffU 
                                                                 & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                                    >> 0x15U)))))
                                                        : 0U))))));
    } else {
        vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int 
            = (0xfffU & ((8U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                          >> 2U))) ? 
                         ((0xfe0U & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                     >> 0x14U)) | (0x1fU 
                                                   & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                      >> 7U)))
                          : 0U));
        vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__imm20_int = 0U;
    }
    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__invalid_opcode_int 
        = ((~ ((((((((4U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                      >> 2U))) | (0xdU 
                                                  == 
                                                  (0x1fU 
                                                   & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                      >> 2U)))) 
                    | (5U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                       >> 2U)))) | 
                   (0xcU == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                      >> 2U)))) | (0x1bU 
                                                   == 
                                                   (0x1fU 
                                                    & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                       >> 2U)))) 
                 | (0x19U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                       >> 2U)))) | 
                (0x18U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                    >> 2U)))) | (0U 
                                                 == 
                                                 (0x1fU 
                                                  & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                     >> 2U))))) 
           & ((8U != (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                               >> 2U))) & ((0x1dU != 
                                            (0x1fU 
                                             & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                >> 2U))) 
                                           & (0x1cU 
                                              != (0x1fU 
                                                  & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                     >> 2U))))));
    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__invalid_instr_int 
        = ((3U != (3U & vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int)) 
           | (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__invalid_opcode_int));
    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int = 0U;
    if (((((((((4U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                >> 2U))) | (0xdU == 
                                            (0x1fU 
                                             & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                >> 2U)))) 
              | (5U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                 >> 2U)))) | (0xcU 
                                              == (0x1fU 
                                                  & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                     >> 2U)))) 
            | (0x1bU == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                  >> 2U)))) | (0x19U 
                                               == (0x1fU 
                                                   & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                      >> 2U)))) 
          | (0x18U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                >> 2U)))) | (0U == 
                                             (0x1fU 
                                              & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                 >> 2U))))) {
        if ((4U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                             >> 2U)))) {
            vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int 
                = ((0x20U == (0x7fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                       >> 0x19U))) 
                   & (5U == (7U & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                   >> 0xcU))));
        } else {
            if ((0xdU == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                   >> 2U)))) {
                vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int = 1U;
                vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int = 0U;
            } else {
                if ((5U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                     >> 2U)))) {
                    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int = 1U;
                    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int = 0U;
                } else {
                    if ((0xcU == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                           >> 2U)))) {
                        vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int = 0U;
                        vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int = 1U;
                    } else {
                        if ((0x1bU == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                >> 2U)))) {
                            vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int = 1U;
                            vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int = 0U;
                        } else {
                            if ((0x19U == (0x1fU & 
                                           (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                            >> 2U)))) {
                                vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int = 1U;
                                vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int = 0U;
                            } else {
                                if ((0x18U == (0x1fU 
                                               & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                                  >> 2U)))) {
                                    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int = 0U;
                                    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int = 0U;
                                } else {
                                    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int = 0U;
                                    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int = 0U;
                                }
                            }
                        }
                    }
                }
            }
        }
    } else {
        if ((8U == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                             >> 2U)))) {
            vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int = 0U;
            vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int = 0U;
        } else {
            if ((0x1dU == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                    >> 2U)))) {
                vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int = 0U;
                vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int = 0U;
            } else {
                if ((0x1cU == (0x1fU & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                                        >> 2U)))) {
                    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int = 0U;
                    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int = 0U;
                } else {
                    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int = 0U;
                    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int = 0U;
                }
            }
        }
    }
    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__cu_addr_int 
        = ((0x1feU & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__cu_addr_int)) 
           | ((IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int) 
              & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                 >> 0x1eU)));
    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__cu_addr_int 
        = ((0x1f1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__cu_addr_int)) 
           | (((IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int)
                ? 0U : (7U & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                              >> 0xcU))) << 1U));
    vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__cu_addr_int 
        = ((0xfU & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__cu_addr_int)) 
           | (0x1f0U & (vlTOPp->beta_top__DOT__pipe0__DOT__pip_instr_int 
                        << 2U)));
    __Vtableidx2 = (((IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_stall_int) 
                     << 4U) | (((IData)(vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip0_stall_int) 
                                << 3U) | (((IData)(vlTOPp->beta_top__DOT__pcu__DOT__ifs_triggered_int) 
                                           << 2U) | 
                                          (((IData)(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__if_stage_busy_int) 
                                            << 1U) 
                                           | (IData)(vlTOPp->rstn_i)))));
    if ((1U & vlTOPp->__Vtablechg2[__Vtableidx2])) {
        vlTOPp->beta_top__DOT__pcu__DOT__ifs_triggered_int 
            = vlTOPp->__Vtable2_beta_top__DOT__pcu__DOT__ifs_triggered_int
            [__Vtableidx2];
    }
    __Vdly__beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int 
        = vlTOPp->__Vtable2_beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int
        [__Vtableidx2];
    if ((4U & vlTOPp->__Vtablechg2[__Vtableidx2])) {
        vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip0_flush_int 
            = vlTOPp->__Vtable2_beta_top__DOT__pcu__DOT__pcu_pip0_flush_int
            [__Vtableidx2];
    }
    if ((8U & vlTOPp->__Vtablechg2[__Vtableidx2])) {
        vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_flush_int 
            = vlTOPp->__Vtable2_beta_top__DOT__pcu__DOT__pcu_pip1_flush_int
            [__Vtableidx2];
    }
    vlTOPp->result_o = vlTOPp->beta_top__DOT__exe_stage__DOT__exe_result_int;
    if ((1U & (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int) 
                >> 1U) | (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int)))) {
        if ((1U & (((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int) 
                    >> 1U) | (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int)))) {
            vlTOPp->beta_top__DOT__exe_stage__DOT__exe_next_pc_int 
                = ((3U == (3U & (IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int)))
                    ? vlTOPp->beta_top__DOT__exe_stage__DOT__bju__DOT__bju_selected_data_int
                    : (vlTOPp->beta_top__DOT__pipe1__DOT__pip_next_pc_int 
                       + vlTOPp->beta_top__DOT__exe_stage__DOT__bju__DOT__bju_selected_data_int));
        }
    } else {
        vlTOPp->beta_top__DOT__exe_stage__DOT__exe_next_pc_int 
            = ((IData)(4U) + vlTOPp->beta_top__DOT__pipe1__DOT__pip_next_pc_int);
    }
    vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int 
        = ((IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__invalid_instr_int)
            ? 0x1ffU : (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__decoder__DOT__cu_addr_int));
    vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip1_stall_int 
        = ((IData)(vlTOPp->beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_exe_stage_busy_int) 
           & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__new_instruction_latch));
    vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
    if ((0x100U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
        if ((0x80U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
            if ((0x40U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
            } else {
                if ((0x20U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                    if ((0x10U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                        if ((8U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                            vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                        } else {
                            if ((4U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                            } else {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x200000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (2U | 
                                               (0x1fffffcU 
                                                & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            }
                        }
                    } else {
                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                    }
                } else {
                    if ((0x10U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                        if ((8U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                            vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                        } else {
                            if ((4U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                            } else {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (3U | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            }
                        }
                    } else {
                        if ((8U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                            if ((4U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (1U | 
                                               (0x1fffffcU 
                                                & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x10U 
                                               | (0x1ffffcfU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (8U | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x20000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (1U | 
                                               (0x1fffffcU 
                                                & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x10U 
                                               | (0x1ffffcfU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fffff7U 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x20000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            } else {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (1U | 
                                               (0x1fffffcU 
                                                & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x10U 
                                               | (0x1ffffcfU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (8U | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fdffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (1U | 
                                               (0x1fffffcU 
                                                & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x10U 
                                               | (0x1ffffcfU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fffff7U 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fdffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            }
                        } else {
                            if ((4U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                            } else {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (1U | 
                                               (0x1fffffcU 
                                                & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x20U 
                                               | (0x1ffffcfU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (8U | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fdffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (1U | 
                                               (0x1fffffcU 
                                                & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x20U 
                                               | (0x1ffffcfU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fffff7U 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fdffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
        }
    } else {
        if ((0x80U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
            if ((0x40U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                if ((0x20U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                    vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                } else {
                    if ((0x10U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                        if ((8U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                            vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                        } else {
                            if ((4U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                            } else {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x400000U 
                                               | (0x13fffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x300000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1ffff3fU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fffffbU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            }
                        }
                    } else {
                        if ((8U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                            if ((4U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1000U 
                                               | (0x1ffcfffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x2000U 
                                               | (0x1ffcfffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            } else {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0xc0U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x80U 
                                               | (0x1ffff3fU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x3000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            }
                        } else {
                            if ((4U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x10U 
                                               | (0x1ffffcfU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fffff7U 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x20000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x10000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x80000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x10U 
                                               | (0x1ffffcfU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fffff7U 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fdffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x10000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            } else {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40U 
                                               | (0x1ffff3fU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x4000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x8000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                if ((0x20U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                    vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                } else {
                    if ((0x10U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                    } else {
                        if ((8U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                            vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                        } else {
                            if ((4U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fff3ffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x200U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            } else {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x400U 
                                               | (0x1fff3ffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x200U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1cfffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x800U 
                                               | (0x1fff3ffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x200U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            if ((0x40U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                if ((0x20U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                    vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                } else {
                    if ((0x10U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                        if ((8U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                            vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                        } else {
                            if ((4U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                            } else {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x400000U 
                                               | (0x13fffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x300000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1ffff3fU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (4U | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            }
                        }
                    } else {
                        if ((8U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                            if ((4U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1000U 
                                               | (0x1ffcfffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x2000U 
                                               | (0x1ffcfffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            } else {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0xc0U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x80U 
                                               | (0x1ffff3fU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x3000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            }
                        } else {
                            if ((4U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x10U 
                                               | (0x1ffffcfU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fffff7U 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x20000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x10000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x80000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x10U 
                                               | (0x1ffffcfU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fffff7U 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fdffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x10000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            } else {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40U 
                                               | (0x1ffff3fU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x8000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                if ((0x20U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                    vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                } else {
                    if ((0x10U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                    } else {
                        if ((8U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                            if ((4U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                            } else {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x8000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x80000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x400U 
                                               | (0x1fff3ffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fffdffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x8000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x80000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x800U 
                                               | (0x1fff3ffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fffdffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            }
                        } else {
                            if ((4U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x8000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fff3ffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fffdffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            } else {
                                if ((2U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x8000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x400U 
                                               | (0x1fff3ffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fffdffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                } else {
                                    if ((1U & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__cu_address_int))) {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int = 0U;
                                    } else {
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x13fffffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100000U 
                                               | (0x1cfffffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x8000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x40000U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x800U 
                                               | (0x1fff3ffU 
                                                  & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int));
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x1fffdffU 
                                               & vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                        vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int 
                                            = (0x100U 
                                               | vlTOPp->beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    if (vlTOPp->rstn_i) {
        if ((0U == (IData)(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int))) {
            if (vlTOPp->beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int) {
                vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__if_stage_busy_int = 1U;
                vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__instr_req_int = 1U;
                __Vdly__beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int = 1U;
            }
            vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__new_instr_int = 0U;
        } else {
            if ((1U == (IData)(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int))) {
                if (vlTOPp->instr_ready_i) {
                    vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__instr_req_int = 0U;
                    __Vdly__beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int = 2U;
                }
            } else {
                if ((2U == (IData)(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int))) {
                    if (vlTOPp->instr_valid_i) {
                        vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__if_stage_busy_int = 0U;
                        vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__instr_int 
                            = vlTOPp->instr_rdata_i;
                        vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__new_instr_int = 1U;
                        __Vdly__beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int = 0U;
                    }
                } else {
                    __Vdly__beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int = 0U;
                }
            }
        }
    } else {
        vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__instr_int = 0U;
        vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__if_stage_busy_int = 0U;
        vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__new_instr_int = 0U;
        __Vdly__beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int = 0U;
    }
    vlTOPp->beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int 
        = __Vdly__beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int;
    vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int 
        = __Vdly__beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int;
    vlTOPp->instr_req_o = vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__instr_req_int;
    vlTOPp->beta_top__DOT__pcu__DOT__pcu_pip0_stall_int 
        = (((IData)(vlTOPp->beta_top__DOT__pcu__DOT__ifs_triggered_int) 
            & (IData)(vlTOPp->beta_top__DOT__if_stage__DOT__fu__DOT__if_stage_busy_int)) 
           & (IData)(vlTOPp->beta_top__DOT__dec_stage__DOT__new_instruction_latch));
}

void Vbeta_top::_eval(Vbeta_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbeta_top::_eval\n"); );
    Vbeta_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if (((IData)(vlTOPp->clk_i) & (~ (IData)(vlTOPp->__Vclklast__TOP__clk_i)))) {
        vlTOPp->_sequent__TOP__3(vlSymsp);
        vlTOPp->__Vm_traceActivity[1U] = 1U;
    }
    // Final
    vlTOPp->__Vclklast__TOP__clk_i = vlTOPp->clk_i;
}

VL_INLINE_OPT QData Vbeta_top::_change_request(Vbeta_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbeta_top::_change_request\n"); );
    Vbeta_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    return (vlTOPp->_change_request_1(vlSymsp));
}

VL_INLINE_OPT QData Vbeta_top::_change_request_1(Vbeta_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbeta_top::_change_request_1\n"); );
    Vbeta_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vbeta_top::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbeta_top::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((clk_i & 0xfeU))) {
        Verilated::overWidthError("clk_i");}
    if (VL_UNLIKELY((rstn_i & 0xfeU))) {
        Verilated::overWidthError("rstn_i");}
    if (VL_UNLIKELY((instr_ready_i & 0xfeU))) {
        Verilated::overWidthError("instr_ready_i");}
    if (VL_UNLIKELY((instr_valid_i & 0xfeU))) {
        Verilated::overWidthError("instr_valid_i");}
    if (VL_UNLIKELY((rdata_ready_i & 0xfeU))) {
        Verilated::overWidthError("rdata_ready_i");}
    if (VL_UNLIKELY((rdata_valid_i & 0xfeU))) {
        Verilated::overWidthError("rdata_valid_i");}
    if (VL_UNLIKELY((wdata_ready_i & 0xfeU))) {
        Verilated::overWidthError("wdata_ready_i");}
    if (VL_UNLIKELY((wdata_valid_i & 0xfeU))) {
        Verilated::overWidthError("wdata_valid_i");}
}
#endif  // VL_DEBUG
