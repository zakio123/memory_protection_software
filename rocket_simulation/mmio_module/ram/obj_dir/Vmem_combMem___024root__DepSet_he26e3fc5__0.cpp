// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vmem_combMem.h for the primary calling header

#include "Vmem_combMem__pch.h"
#include "Vmem_combMem___024root.h"

void Vmem_combMem___024root___eval_act(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_act\n"); );
}

void Vmem_combMem___024root___nba_sequent__TOP__0(Vmem_combMem___024root* vlSelf);
void Vmem_combMem___024root___nba_sequent__TOP__1(Vmem_combMem___024root* vlSelf);

void Vmem_combMem___024root___eval_nba(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_nba\n"); );
    // Body
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vmem_combMem___024root___nba_sequent__TOP__0(vlSelf);
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vmem_combMem___024root___nba_sequent__TOP__1(vlSelf);
    }
}

void Vmem_combMem___024root___eval_triggers__act(Vmem_combMem___024root* vlSelf);

bool Vmem_combMem___024root___eval_phase__act(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<2> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vmem_combMem___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vmem_combMem___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vmem_combMem___024root___eval_phase__nba(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vmem_combMem___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmem_combMem___024root___dump_triggers__nba(Vmem_combMem___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vmem_combMem___024root___dump_triggers__act(Vmem_combMem___024root* vlSelf);
#endif  // VL_DEBUG

void Vmem_combMem___024root___eval(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vmem_combMem___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("mem_combMem.sv", 3, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vmem_combMem___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("mem_combMem.sv", 3, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vmem_combMem___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vmem_combMem___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vmem_combMem___024root___eval_debug_assertions(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->R0_addr & 0xfe000000U))) {
        Verilated::overWidthError("R0_addr");}
    if (VL_UNLIKELY((vlSelf->R0_en & 0xfeU))) {
        Verilated::overWidthError("R0_en");}
    if (VL_UNLIKELY((vlSelf->R0_clk & 0xfeU))) {
        Verilated::overWidthError("R0_clk");}
    if (VL_UNLIKELY((vlSelf->W0_addr & 0xfe000000U))) {
        Verilated::overWidthError("W0_addr");}
    if (VL_UNLIKELY((vlSelf->W0_en & 0xfeU))) {
        Verilated::overWidthError("W0_en");}
    if (VL_UNLIKELY((vlSelf->W0_clk & 0xfeU))) {
        Verilated::overWidthError("W0_clk");}
}
#endif  // VL_DEBUG
