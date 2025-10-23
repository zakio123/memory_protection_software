// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vmem_combMem__Syms.h"


void Vmem_combMem___024root__trace_chg_0_sub_0(Vmem_combMem___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vmem_combMem___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root__trace_chg_0\n"); );
    // Init
    Vmem_combMem___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vmem_combMem___024root*>(voidSelf);
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vmem_combMem___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vmem_combMem___024root__trace_chg_0_sub_0(Vmem_combMem___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root__trace_chg_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[0U])) {
        bufp->chgQData(oldp+0,(vlSelf->mem_combMem__DOT__unnamedblk1__DOT__words),64);
    }
    bufp->chgIData(oldp+2,(vlSelf->R0_addr),25);
    bufp->chgBit(oldp+3,(vlSelf->R0_en));
    bufp->chgBit(oldp+4,(vlSelf->R0_clk));
    bufp->chgIData(oldp+5,(vlSelf->W0_addr),25);
    bufp->chgBit(oldp+6,(vlSelf->W0_en));
    bufp->chgBit(oldp+7,(vlSelf->W0_clk));
    bufp->chgQData(oldp+8,(vlSelf->W0_data),64);
    bufp->chgCData(oldp+10,(vlSelf->W0_mask),8);
    bufp->chgQData(oldp+11,(vlSelf->R0_data),64);
}

void Vmem_combMem___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root__trace_cleanup\n"); );
    // Init
    Vmem_combMem___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vmem_combMem___024root*>(voidSelf);
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
}
