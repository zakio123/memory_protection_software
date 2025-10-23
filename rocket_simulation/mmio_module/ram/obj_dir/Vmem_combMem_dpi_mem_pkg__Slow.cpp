// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vmem_combMem.h for the primary calling header

#include "Vmem_combMem__pch.h"
#include "Vmem_combMem__Syms.h"
#include "Vmem_combMem_dpi_mem_pkg.h"

void Vmem_combMem_dpi_mem_pkg___ctor_var_reset(Vmem_combMem_dpi_mem_pkg* vlSelf);

Vmem_combMem_dpi_mem_pkg::Vmem_combMem_dpi_mem_pkg(Vmem_combMem__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vmem_combMem_dpi_mem_pkg___ctor_var_reset(this);
}

void Vmem_combMem_dpi_mem_pkg::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vmem_combMem_dpi_mem_pkg::~Vmem_combMem_dpi_mem_pkg() {
}
