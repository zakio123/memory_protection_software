// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vmem_combMem__pch.h"
#include "Vmem_combMem.h"
#include "Vmem_combMem___024root.h"
#include "Vmem_combMem_dpi_mem_pkg.h"

// FUNCTIONS
Vmem_combMem__Syms::~Vmem_combMem__Syms()
{
}

Vmem_combMem__Syms::Vmem_combMem__Syms(VerilatedContext* contextp, const char* namep, Vmem_combMem* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
    , TOP__dpi_mem_pkg{this, Verilated::catName(namep, "dpi_mem_pkg")}
{
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-12);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    TOP.__PVT__dpi_mem_pkg = &TOP__dpi_mem_pkg;
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
    TOP__dpi_mem_pkg.__Vconfigure(true);
    // Setup scopes
    __Vscope_mem_combMem.configure(this, name(), "mem_combMem", "mem_combMem", -12, VerilatedScope::SCOPE_OTHER);
    __Vscope_mem_combMem__unnamedblk1.configure(this, name(), "mem_combMem.unnamedblk1", "unnamedblk1", -12, VerilatedScope::SCOPE_OTHER);
    // Setup export functions
    for (int __Vfinal = 0; __Vfinal < 2; ++__Vfinal) {
    }
}
