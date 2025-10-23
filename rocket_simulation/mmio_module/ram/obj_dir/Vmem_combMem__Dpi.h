// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Prototypes for DPI import and export functions.
//
// Verilator includes this file in all generated .cpp files that use DPI functions.
// Manually include this file where DPI .c import functions are declared to ensure
// the C functions match the expectations of the DPI imports.

#ifndef VERILATED_VMEM_COMBMEM__DPI_H_
#define VERILATED_VMEM_COMBMEM__DPI_H_  // guard

#include "svdpi.h"

#ifdef __cplusplus
extern "C" {
#endif


    // DPI IMPORTS
    // DPI import at dpi_mem_pkg.sv:3:40
    extern void dpi_mem_init_words(unsigned long long words);
    // DPI import at dpi_mem_pkg.sv:6:52
    extern unsigned long long dpi_mem_read64_idx(unsigned int idx);
    // DPI import at dpi_mem_pkg.sv:9:40
    extern void dpi_mem_write64_mask_idx(unsigned int idx, unsigned long long data, char mask);

#ifdef __cplusplus
}
#endif

#endif  // guard
