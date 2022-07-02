// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _VBETA_TOP_H_
#define _VBETA_TOP_H_  // guard

#include "verilated.h"

//==========

class Vbeta_top__Syms;
class Vbeta_top_VerilatedVcd;


//----------

VL_MODULE(Vbeta_top) {
  public:
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    VL_IN8(clk_i,0,0);
    VL_IN8(rstn_i,0,0);
    VL_IN8(instr_ready_i,0,0);
    VL_IN8(instr_valid_i,0,0);
    VL_OUT8(instr_req_o,0,0);
    VL_IN8(rdata_ready_i,0,0);
    VL_IN8(rdata_valid_i,0,0);
    VL_OUT8(rdata_strb_o,3,0);
    VL_OUT8(rdata_req_o,0,0);
    VL_IN8(wdata_ready_i,0,0);
    VL_IN8(wdata_valid_i,0,0);
    VL_OUT8(wdata_strb_o,3,0);
    VL_OUT8(wdata_req_o,0,0);
    VL_OUT8(alu_op_end_o,0,0);
    VL_IN(instr_rdata_i,31,0);
    VL_OUT(instr_addr_o,31,0);
    VL_IN(rdata_data_i,31,0);
    VL_OUT(rdata_addr_o,31,0);
    VL_OUT(wdata_data_o,31,0);
    VL_OUT(wdata_addr_o,31,0);
    VL_OUT(result_o,31,0);
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        CData/*0:0*/ beta_top__DOT__reg_wr_en_int;
        CData/*0:0*/ beta_top__DOT__first_reset;
        CData/*0:0*/ beta_top__DOT__if_stage__DOT__fu__DOT__if_stage_busy_int;
        CData/*0:0*/ beta_top__DOT__if_stage__DOT__fu__DOT__instr_req_int;
        CData/*0:0*/ beta_top__DOT__if_stage__DOT__fu__DOT__new_instr_int;
        CData/*1:0*/ beta_top__DOT__if_stage__DOT__fu__DOT__imem_state_int;
        CData/*0:0*/ beta_top__DOT__pipe0__DOT__pip_new_instr_int;
        CData/*0:0*/ beta_top__DOT__dec_stage__DOT__new_instruction_latch;
        CData/*0:0*/ beta_top__DOT__dec_stage__DOT__decoder__DOT__invalid_instr_int;
        CData/*0:0*/ beta_top__DOT__dec_stage__DOT__decoder__DOT__funct7_mask_bit_int;
        CData/*0:0*/ beta_top__DOT__dec_stage__DOT__decoder__DOT__funct3_mask_bit_int;
        CData/*0:0*/ beta_top__DOT__dec_stage__DOT__decoder__DOT__invalid_opcode_int;
        CData/*4:0*/ beta_top__DOT__pipe1__DOT__pip_rd_addr_int;
        CData/*0:0*/ beta_top__DOT__pipe1__DOT__pip_new_instr_int;
        CData/*1:0*/ beta_top__DOT__exe_stage__DOT__shu_size_int;
        CData/*4:0*/ beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_alu_op_int;
        CData/*4:0*/ beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_bju_op_int;
        CData/*0:0*/ beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_shu_en_int;
        CData/*0:0*/ beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_exe_stage_busy_int;
        CData/*0:0*/ beta_top__DOT__exe_stage__DOT__exe_cu__DOT__execu_lsu_en_int;
        CData/*1:0*/ beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_fsm;
        CData/*1:0*/ beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_fsm;
        CData/*0:0*/ beta_top__DOT__exe_stage__DOT__exe_cu__DOT__event_latch;
        CData/*1:0*/ beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_latch;
        CData/*1:0*/ beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_latch;
        CData/*0:0*/ beta_top__DOT__exe_stage__DOT__alu__DOT__status_flag_int;
        CData/*2:0*/ beta_top__DOT__exe_stage__DOT__alu__DOT__alu_stat_int;
        CData/*0:0*/ beta_top__DOT__exe_stage__DOT__shu__DOT__shu_busy_int;
        CData/*4:0*/ beta_top__DOT__exe_stage__DOT__shu__DOT__shiftreg_cnt_int;
        CData/*0:0*/ beta_top__DOT__exe_stage__DOT__shu__DOT__shu_end;
        CData/*0:0*/ beta_top__DOT__exe_stage__DOT__bju__DOT__bju_branch_taken_int;
        CData/*3:0*/ beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_strb_int;
        CData/*0:0*/ beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_req_int;
        CData/*3:0*/ beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_strb_int;
        CData/*0:0*/ beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_req_int;
        CData/*0:0*/ beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_busy_int;
        CData/*1:0*/ beta_top__DOT__exe_stage__DOT__lsu__DOT__rdmem_state;
        CData/*1:0*/ beta_top__DOT__exe_stage__DOT__lsu__DOT__wdmem_state;
        CData/*0:0*/ beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int;
        CData/*0:0*/ beta_top__DOT__pcu__DOT__pcu_pip0_stall_int;
        CData/*0:0*/ beta_top__DOT__pcu__DOT__pcu_pip0_flush_int;
        CData/*0:0*/ beta_top__DOT__pcu__DOT__pcu_pip1_stall_int;
        CData/*0:0*/ beta_top__DOT__pcu__DOT__pcu_pip1_flush_int;
        CData/*0:0*/ beta_top__DOT__pcu__DOT__ifs_triggered_int;
        CData/*0:0*/ beta_top__DOT__pcu__DOT__decs_triggered_int;
        CData/*0:0*/ beta_top__DOT__pcu__DOT__exes_triggered_int;
        CData/*0:0*/ beta_top__DOT__pcu__DOT__ifs_halt_int;
        CData/*0:0*/ beta_top__DOT__pcu__DOT__decs_halt_int;
        CData/*0:0*/ beta_top__DOT__pcu__DOT__exes_halt_int;
        SData/*8:0*/ beta_top__DOT__dec_stage__DOT__cu_address_int;
        SData/*11:0*/ beta_top__DOT__dec_stage__DOT__decoder__DOT__imm12_int;
        SData/*8:0*/ beta_top__DOT__dec_stage__DOT__decoder__DOT__cu_addr_int;
        SData/*11:0*/ beta_top__DOT__pipe1__DOT__pip_offset12_int;
        IData/*31:0*/ beta_top__DOT__if_stage__DOT__curr_pc_int;
        IData/*31:0*/ beta_top__DOT__if_stage__DOT__fu__DOT__instr_int;
        IData/*31:0*/ beta_top__DOT__pipe0__DOT__pip_instr_int;
        IData/*31:0*/ beta_top__DOT__pipe0__DOT__pip_next_pc_int;
        IData/*19:0*/ beta_top__DOT__dec_stage__DOT__decoder__DOT__imm20_int;
        IData/*31:0*/ beta_top__DOT__dec_stage__DOT__regfile__DOT__write_proc__DOT__unnamedblk1__DOT__i;
        IData/*24:0*/ beta_top__DOT__dec_stage__DOT__control_unit__DOT__cw_int;
        IData/*19:0*/ beta_top__DOT__pipe1__DOT__pip_offset20_int;
        IData/*31:0*/ beta_top__DOT__pipe1__DOT__pip_operand_a_int;
        IData/*31:0*/ beta_top__DOT__pipe1__DOT__pip_operand_b_int;
        IData/*24:0*/ beta_top__DOT__pipe1__DOT__pip_control_word_int;
    };
    struct {
        IData/*31:0*/ beta_top__DOT__pipe1__DOT__pip_next_pc_int;
        IData/*31:0*/ beta_top__DOT__exe_stage__DOT__exe_next_pc_int;
        IData/*31:0*/ beta_top__DOT__exe_stage__DOT__exe_result_int;
        IData/*31:0*/ beta_top__DOT__exe_stage__DOT__alu__DOT__op_result_int;
        IData/*31:0*/ beta_top__DOT__exe_stage__DOT__alu__DOT__status_comp_data;
        IData/*31:0*/ beta_top__DOT__exe_stage__DOT__shu__DOT__shu_result_int;
        IData/*31:0*/ beta_top__DOT__exe_stage__DOT__bju__DOT__bju_selected_data_int;
        IData/*31:0*/ beta_top__DOT__exe_stage__DOT__lsu__DOT__rdata_addr_int;
        IData/*31:0*/ beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_data_int;
        IData/*31:0*/ beta_top__DOT__exe_stage__DOT__lsu__DOT__wdata_addr_int;
        IData/*31:0*/ beta_top__DOT__exe_stage__DOT__lsu__DOT__lsu_result_int;
        IData/*31:0*/ beta_top__DOT__dec_stage__DOT__regfile__DOT__regfile_data_int[32];
    };
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    CData/*0:0*/ __Vclklast__TOP__clk_i;
    CData/*2:0*/ __Vtablechg1[128];
    CData/*3:0*/ __Vtablechg2[32];
    CData/*0:0*/ __Vm_traceActivity[2];
    static CData/*0:0*/ __Vtable1_beta_top__DOT__exe_stage__DOT__exe_cu__DOT__event_latch[128];
    static CData/*1:0*/ __Vtable1_beta_top__DOT__exe_stage__DOT__exe_cu__DOT__shift_latch[128];
    static CData/*1:0*/ __Vtable1_beta_top__DOT__exe_stage__DOT__exe_cu__DOT__lsu_latch[128];
    static CData/*0:0*/ __Vtable2_beta_top__DOT__pcu__DOT__ifs_triggered_int[32];
    static CData/*0:0*/ __Vtable2_beta_top__DOT__pcu__DOT__pcu_ifs_fetch_en_int[32];
    static CData/*0:0*/ __Vtable2_beta_top__DOT__pcu__DOT__pcu_pip0_flush_int[32];
    static CData/*0:0*/ __Vtable2_beta_top__DOT__pcu__DOT__pcu_pip1_flush_int[32];
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    Vbeta_top__Syms* __VlSymsp;  // Symbol table
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vbeta_top);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible with respect to DPI scope names.
    Vbeta_top(const char* name = "TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~Vbeta_top();
    /// Trace signals in the model; called by application code
    void trace(VerilatedVcdC* tfp, int levels, int options = 0);
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval() { eval_step(); }
    /// Evaluate when calling multiple units/models per time step.
    void eval_step();
    /// Evaluate at end of a timestep for tracing, when using eval_step().
    /// Application must call after all eval() and before time changes.
    void eval_end_step() {}
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(Vbeta_top__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(Vbeta_top__Syms* symsp, bool first);
  private:
    static QData _change_request(Vbeta_top__Syms* __restrict vlSymsp);
    static QData _change_request_1(Vbeta_top__Syms* __restrict vlSymsp);
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(Vbeta_top__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif  // VL_DEBUG
  public:
    static void _eval_initial(Vbeta_top__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(Vbeta_top__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _initial__TOP__2(Vbeta_top__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _sequent__TOP__3(Vbeta_top__Syms* __restrict vlSymsp);
    static void _settle__TOP__1(Vbeta_top__Syms* __restrict vlSymsp) VL_ATTR_COLD;
  private:
    static void traceChgSub0(void* userp, VerilatedVcd* tracep);
    static void traceChgTop0(void* userp, VerilatedVcd* tracep);
    static void traceCleanup(void* userp, VerilatedVcd* /*unused*/);
    static void traceFullSub0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceFullTop0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInitSub0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInitTop(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    void traceRegister(VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) VL_ATTR_COLD;
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
