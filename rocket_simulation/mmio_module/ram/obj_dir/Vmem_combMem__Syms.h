// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VMEM_COMBMEM__SYMS_H_
#define VERILATED_VMEM_COMBMEM__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vmem_combMem.h"

// INCLUDE MODULE CLASSES
#include "Vmem_combMem___024root.h"
#include "Vmem_combMem_dpi_mem_pkg.h"

// DPI TYPES for DPI Export callbacks (Internal use)

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vmem_combMem__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vmem_combMem* const __Vm_modelp;
    bool __Vm_activity = false;  ///< Used by trace routines to determine change occurred
    uint32_t __Vm_baseCode = 0;  ///< Used by trace routines when tracing multiple models
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vmem_combMem___024root         TOP;
    Vmem_combMem_dpi_mem_pkg       TOP__dpi_mem_pkg;

    // SCOPE NAMES
    VerilatedScope __Vscope_mem_combMem;
    VerilatedScope __Vscope_mem_combMem__unnamedblk1;

    // CONSTRUCTORS
    Vmem_combMem__Syms(VerilatedContext* contextp, const char* namep, Vmem_combMem* modelp);
    ~Vmem_combMem__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
