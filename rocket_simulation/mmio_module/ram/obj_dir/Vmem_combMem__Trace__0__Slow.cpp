// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vmem_combMem__Syms.h"


VL_ATTR_COLD void Vmem_combMem___024root__trace_init_sub__TOP__0(Vmem_combMem___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBus(c+3,0,"R0_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 24,0);
    tracep->declBit(c+4,0,"R0_en",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+5,0,"R0_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+6,0,"W0_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 24,0);
    tracep->declBit(c+7,0,"W0_en",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+8,0,"W0_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declQuad(c+9,0,"W0_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+11,0,"W0_mask",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declQuad(c+12,0,"R0_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->pushPrefix("mem_combMem", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+3,0,"R0_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 24,0);
    tracep->declBit(c+4,0,"R0_en",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+5,0,"R0_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+6,0,"W0_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 24,0);
    tracep->declBit(c+7,0,"W0_en",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+8,0,"W0_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declQuad(c+9,0,"W0_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+11,0,"W0_mask",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declQuad(c+12,0,"R0_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->pushPrefix("unnamedblk1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declQuad(c+1,0,"words",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LONGINT, false,-1, 63,0);
    tracep->popPrefix();
    tracep->popPrefix();
}

VL_ATTR_COLD void Vmem_combMem___024root__trace_init_top(Vmem_combMem___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root__trace_init_top\n"); );
    // Body
    Vmem_combMem___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vmem_combMem___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vmem_combMem___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vmem_combMem___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vmem_combMem___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vmem_combMem___024root__trace_register(Vmem_combMem___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root__trace_register\n"); );
    // Body
    tracep->addConstCb(&Vmem_combMem___024root__trace_const_0, 0U, vlSelf);
    tracep->addFullCb(&Vmem_combMem___024root__trace_full_0, 0U, vlSelf);
    tracep->addChgCb(&Vmem_combMem___024root__trace_chg_0, 0U, vlSelf);
    tracep->addCleanupCb(&Vmem_combMem___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vmem_combMem___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root__trace_const_0\n"); );
    // Init
    Vmem_combMem___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vmem_combMem___024root*>(voidSelf);
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
}

VL_ATTR_COLD void Vmem_combMem___024root__trace_full_0_sub_0(Vmem_combMem___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vmem_combMem___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root__trace_full_0\n"); );
    // Init
    Vmem_combMem___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vmem_combMem___024root*>(voidSelf);
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vmem_combMem___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vmem_combMem___024root__trace_full_0_sub_0(Vmem_combMem___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmem_combMem___024root__trace_full_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullQData(oldp+1,(vlSelf->mem_combMem__DOT__unnamedblk1__DOT__words),64);
    bufp->fullIData(oldp+3,(vlSelf->R0_addr),25);
    bufp->fullBit(oldp+4,(vlSelf->R0_en));
    bufp->fullBit(oldp+5,(vlSelf->R0_clk));
    bufp->fullIData(oldp+6,(vlSelf->W0_addr),25);
    bufp->fullBit(oldp+7,(vlSelf->W0_en));
    bufp->fullBit(oldp+8,(vlSelf->W0_clk));
    bufp->fullQData(oldp+9,(vlSelf->W0_data),64);
    bufp->fullCData(oldp+11,(vlSelf->W0_mask),8);
    bufp->fullQData(oldp+12,(vlSelf->R0_data),64);
}
