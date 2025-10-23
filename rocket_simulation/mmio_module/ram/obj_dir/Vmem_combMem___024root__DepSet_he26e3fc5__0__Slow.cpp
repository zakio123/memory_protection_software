// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vmem_combMem.h for the primary calling header

#include "Vmem_combMem__pch.h"
#include "Vmem_combMem___024root.h"

VL_ATTR_COLD void Vmem_combMem___024root___eval_static(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vmem_combMem___024root___eval_initial__TOP(Vmem_combMem___024root* vlSelf);

VL_ATTR_COLD void Vmem_combMem___024root___eval_initial(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_initial\n"); );
    // Body
    Vmem_combMem___024root___eval_initial__TOP(vlSelf);
    vlSelf->__Vm_traceActivity[0U] = 1U;
    vlSelf->__Vtrigprevexpr___TOP__R0_clk__0 = vlSelf->R0_clk;
    vlSelf->__Vtrigprevexpr___TOP__W0_clk__0 = vlSelf->W0_clk;
}

VL_ATTR_COLD void Vmem_combMem___024root___eval_final(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_final\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmem_combMem___024root___dump_triggers__stl(Vmem_combMem___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vmem_combMem___024root___eval_phase__stl(Vmem_combMem___024root* vlSelf);

VL_ATTR_COLD void Vmem_combMem___024root___eval_settle(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_settle\n"); );
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelf->__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY((0x64U < __VstlIterCount))) {
#ifdef VL_DEBUG
            Vmem_combMem___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("mem_combMem.sv", 3, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vmem_combMem___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelf->__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmem_combMem___024root___dump_triggers__stl(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vmem_combMem___024root___stl_sequent__TOP__0(Vmem_combMem___024root* vlSelf);

VL_ATTR_COLD void Vmem_combMem___024root___eval_stl(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_stl\n"); );
    // Body
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        Vmem_combMem___024root___stl_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD void Vmem_combMem___024root___eval_triggers__stl(Vmem_combMem___024root* vlSelf);

VL_ATTR_COLD bool Vmem_combMem___024root___eval_phase__stl(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_phase__stl\n"); );
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vmem_combMem___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelf->__VstlTriggered.any();
    if (__VstlExecute) {
        Vmem_combMem___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmem_combMem___024root___dump_triggers__act(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge R0_clk)\n");
    }
    if ((2ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(posedge W0_clk)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmem_combMem___024root___dump_triggers__nba(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge R0_clk)\n");
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(posedge W0_clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vmem_combMem___024root___ctor_var_reset(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->R0_addr = VL_RAND_RESET_I(25);
    vlSelf->R0_en = VL_RAND_RESET_I(1);
    vlSelf->R0_clk = VL_RAND_RESET_I(1);
    vlSelf->W0_addr = VL_RAND_RESET_I(25);
    vlSelf->W0_en = VL_RAND_RESET_I(1);
    vlSelf->W0_clk = VL_RAND_RESET_I(1);
    vlSelf->W0_data = VL_RAND_RESET_Q(64);
    vlSelf->W0_mask = VL_RAND_RESET_I(8);
    vlSelf->R0_data = VL_RAND_RESET_Q(64);
    vlSelf->mem_combMem__DOT___GEN = VL_RAND_RESET_I(1);
    vlSelf->mem_combMem__DOT___GEN_0 = VL_RAND_RESET_I(25);
    vlSelf->mem_combMem__DOT__unnamedblk1__DOT__words = 0;
    vlSelf->__Vfunc_dpi_mem_read64_idx__1__Vfuncout = 0;
    vlSelf->__Vtrigprevexpr___TOP__R0_clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__W0_clk__0 = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
