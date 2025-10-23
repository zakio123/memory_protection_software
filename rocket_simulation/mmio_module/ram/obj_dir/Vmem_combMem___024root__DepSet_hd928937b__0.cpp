// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vmem_combMem.h for the primary calling header

#include "Vmem_combMem__pch.h"
#include "Vmem_combMem__Syms.h"
#include "Vmem_combMem___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmem_combMem___024root___dump_triggers__act(Vmem_combMem___024root* vlSelf);
#endif  // VL_DEBUG

void Vmem_combMem___024root___eval_triggers__act(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.set(0U, ((IData)(vlSelf->R0_clk) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__R0_clk__0))));
    vlSelf->__VactTriggered.set(1U, ((IData)(vlSelf->W0_clk) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__W0_clk__0))));
    vlSelf->__Vtrigprevexpr___TOP__R0_clk__0 = vlSelf->R0_clk;
    vlSelf->__Vtrigprevexpr___TOP__W0_clk__0 = vlSelf->W0_clk;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vmem_combMem___024root___dump_triggers__act(vlSelf);
    }
#endif
}

void Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_write64_mask_idx_TOP__dpi_mem_pkg(const VerilatedScope* __Vscopep, const char* __Vfilenamep, IData/*31:0*/ __Vlineno, IData/*31:0*/ idx, QData/*63:0*/ data, CData/*7:0*/ mask);

VL_INLINE_OPT void Vmem_combMem___024root___nba_sequent__TOP__0(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___nba_sequent__TOP__0\n"); );
    // Body
    if (vlSelf->W0_en) {
        Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_write64_mask_idx_TOP__dpi_mem_pkg(
                                                                                (&(vlSymsp->__Vscope_mem_combMem)), 
                                                                                "mem_combMem.sv", 0x24U, vlSelf->W0_addr, vlSelf->W0_data, (IData)(vlSelf->W0_mask));
    }
}

void Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_read64_idx_TOP__dpi_mem_pkg(const VerilatedScope* __Vscopep, const char* __Vfilenamep, IData/*31:0*/ __Vlineno, IData/*31:0*/ idx, QData/*63:0*/ &dpi_mem_read64_idx__Vfuncrtn);

VL_INLINE_OPT void Vmem_combMem___024root___nba_sequent__TOP__1(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___nba_sequent__TOP__1\n"); );
    // Body
    vlSelf->mem_combMem__DOT___GEN_0 = vlSelf->R0_addr;
    vlSelf->mem_combMem__DOT___GEN = vlSelf->R0_en;
    vlSelf->R0_data = ((IData)(vlSelf->mem_combMem__DOT___GEN)
                        ? ([&]() {
                Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_read64_idx_TOP__dpi_mem_pkg(
                                                                                (&(vlSymsp->__Vscope_mem_combMem)), 
                                                                                "mem_combMem.sv", 0x20U, vlSelf->mem_combMem__DOT___GEN_0, vlSelf->__Vfunc_dpi_mem_read64_idx__1__Vfuncout);
            }(), vlSelf->__Vfunc_dpi_mem_read64_idx__1__Vfuncout)
                        : 0ULL);
}
