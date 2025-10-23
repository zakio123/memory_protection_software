// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vmem_combMem.h for the primary calling header

#include "Vmem_combMem__pch.h"
#include "Vmem_combMem__Syms.h"
#include "Vmem_combMem_dpi_mem_pkg.h"

extern "C" void dpi_mem_init_words(unsigned long long words);

VL_INLINE_OPT void Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_init_words_TOP__dpi_mem_pkg(const VerilatedScope* __Vscopep, const char* __Vfilenamep, IData/*31:0*/ __Vlineno, QData/*63:0*/ words) {
    VL_DEBUG_IF(VL_DBG_MSGF("+        Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_init_words_TOP__dpi_mem_pkg\n"); );
    // Body
    unsigned long long words__Vcvt;
    for (size_t words__Vidx = 0; words__Vidx < 1; ++words__Vidx) words__Vcvt = words;
    Verilated::dpiContext(__Vscopep, __Vfilenamep, __Vlineno);
    dpi_mem_init_words(words__Vcvt);
}

extern "C" unsigned long long dpi_mem_read64_idx(unsigned int idx);

VL_INLINE_OPT void Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_read64_idx_TOP__dpi_mem_pkg(const VerilatedScope* __Vscopep, const char* __Vfilenamep, IData/*31:0*/ __Vlineno, IData/*31:0*/ idx, QData/*63:0*/ &dpi_mem_read64_idx__Vfuncrtn) {
    VL_DEBUG_IF(VL_DBG_MSGF("+        Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_read64_idx_TOP__dpi_mem_pkg\n"); );
    // Body
    unsigned int idx__Vcvt;
    for (size_t idx__Vidx = 0; idx__Vidx < 1; ++idx__Vidx) idx__Vcvt = idx;
    Verilated::dpiContext(__Vscopep, __Vfilenamep, __Vlineno);
    unsigned long long dpi_mem_read64_idx__Vfuncrtn__Vcvt;
    dpi_mem_read64_idx__Vfuncrtn__Vcvt = dpi_mem_read64_idx(idx__Vcvt);
    dpi_mem_read64_idx__Vfuncrtn = dpi_mem_read64_idx__Vfuncrtn__Vcvt;
}

extern "C" void dpi_mem_write64_mask_idx(unsigned int idx, unsigned long long data, char mask);

VL_INLINE_OPT void Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_write64_mask_idx_TOP__dpi_mem_pkg(const VerilatedScope* __Vscopep, const char* __Vfilenamep, IData/*31:0*/ __Vlineno, IData/*31:0*/ idx, QData/*63:0*/ data, CData/*7:0*/ mask) {
    VL_DEBUG_IF(VL_DBG_MSGF("+        Vmem_combMem_dpi_mem_pkg____Vdpiimwrap_dpi_mem_write64_mask_idx_TOP__dpi_mem_pkg\n"); );
    // Body
    unsigned int idx__Vcvt;
    for (size_t idx__Vidx = 0; idx__Vidx < 1; ++idx__Vidx) idx__Vcvt = idx;
    unsigned long long data__Vcvt;
    for (size_t data__Vidx = 0; data__Vidx < 1; ++data__Vidx) data__Vcvt = data;
    char mask__Vcvt;
    for (size_t mask__Vidx = 0; mask__Vidx < 1; ++mask__Vidx) mask__Vcvt = mask;
    Verilated::dpiContext(__Vscopep, __Vfilenamep, __Vlineno);
    dpi_mem_write64_mask_idx(idx__Vcvt, data__Vcvt, mask__Vcvt);
}
