// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vmem_combMem.h for the primary calling header

#ifndef VERILATED_VMEM_COMBMEM___024ROOT_H_
#define VERILATED_VMEM_COMBMEM___024ROOT_H_  // guard

#include "verilated.h"
class Vmem_combMem_dpi_mem_pkg;


class Vmem_combMem__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vmem_combMem___024root final : public VerilatedModule {
  public:
    // CELLS
    Vmem_combMem_dpi_mem_pkg* __PVT__dpi_mem_pkg;

    // DESIGN SPECIFIC STATE
    VL_IN8(R0_clk,0,0);
    VL_IN8(W0_clk,0,0);
    VL_IN8(R0_en,0,0);
    VL_IN8(W0_en,0,0);
    VL_IN8(W0_mask,7,0);
    CData/*0:0*/ mem_combMem__DOT___GEN;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__R0_clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__W0_clk__0;
    CData/*0:0*/ __VactContinue;
    VL_IN(R0_addr,24,0);
    VL_IN(W0_addr,24,0);
    IData/*24:0*/ mem_combMem__DOT___GEN_0;
    IData/*31:0*/ __VactIterCount;
    VL_IN64(W0_data,63,0);
    VL_OUT64(R0_data,63,0);
    QData/*63:0*/ mem_combMem__DOT__unnamedblk1__DOT__words;
    QData/*63:0*/ __Vfunc_dpi_mem_read64_idx__1__Vfuncout;
    VlUnpacked<CData/*0:0*/, 1> __Vm_traceActivity;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vmem_combMem__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vmem_combMem___024root(Vmem_combMem__Syms* symsp, const char* v__name);
    ~Vmem_combMem___024root();
    VL_UNCOPYABLE(Vmem_combMem___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
