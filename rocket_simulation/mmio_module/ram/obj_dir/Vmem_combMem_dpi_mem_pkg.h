// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vmem_combMem.h for the primary calling header

#ifndef VERILATED_VMEM_COMBMEM_DPI_MEM_PKG_H_
#define VERILATED_VMEM_COMBMEM_DPI_MEM_PKG_H_  // guard

#include "verilated.h"


class Vmem_combMem__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vmem_combMem_dpi_mem_pkg final : public VerilatedModule {
  public:

    // INTERNAL VARIABLES
    Vmem_combMem__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vmem_combMem_dpi_mem_pkg(Vmem_combMem__Syms* symsp, const char* v__name);
    ~Vmem_combMem_dpi_mem_pkg();
    VL_UNCOPYABLE(Vmem_combMem_dpi_mem_pkg);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
