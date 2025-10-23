// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vmem_combMem.h for the primary calling header

#include "Vmem_combMem__pch.h"
#include "Vmem_combMem__Syms.h"
#include "Vmem_combMem___024root.h"

void Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_init_words_TOP__dpi_mem_pkg(const VerilatedScope* __Vscopep, const char* __Vfilenamep, IData/*31:0*/ __Vlineno, QData/*63:0*/ words);

VL_ATTR_COLD void Vmem_combMem___024root___eval_initial__TOP(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_initial__TOP\n"); );
    // Body
    vlSelf->mem_combMem__DOT__unnamedblk1__DOT__words = 0x2000000ULL;
    Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_init_words_TOP__dpi_mem_pkg(
                                                                               (&(vlSymsp->__Vscope_mem_combMem)), 
                                                                               "mem_combMem.sv", 0x17U, 0x2000000ULL);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmem_combMem___024root___dump_triggers__stl(Vmem_combMem___024root* vlSelf);
#endif  // VL_DEBUG

VL_ATTR_COLD void Vmem_combMem___024root___eval_triggers__stl(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___eval_triggers__stl\n"); );
    // Body
    vlSelf->__VstlTriggered.set(0U, (IData)(vlSelf->__VstlFirstIteration));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vmem_combMem___024root___dump_triggers__stl(vlSelf);
    }
#endif
}

void Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_read64_idx_TOP__dpi_mem_pkg(const VerilatedScope* __Vscopep, const char* __Vfilenamep, IData/*31:0*/ __Vlineno, IData/*31:0*/ idx, QData/*63:0*/ &dpi_mem_read64_idx__Vfuncrtn);

VL_ATTR_COLD void Vmem_combMem___024root___stl_sequent__TOP__0(Vmem_combMem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root___stl_sequent__TOP__0\n"); );
    // Body
    vlSelf->R0_data = ((IData)(vlSelf->mem_combMem__DOT___GEN)
                        ? ([&]() {
                Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_read64_idx_TOP__dpi_mem_pkg(
                                                                                (&(vlSymsp->__Vscope_mem_combMem)), 
                                                                                "mem_combMem.sv", 0x20U, vlSelf->mem_combMem__DOT___GEN_0, vlSelf->__Vfunc_dpi_mem_read64_idx__1__Vfuncout);
            }(), vlSelf->__Vfunc_dpi_mem_read64_idx__1__Vfuncout)
                        : 0ULL);
}
