// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vmem_combMem__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vmem_combMem::Vmem_combMem(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vmem_combMem__Syms(contextp(), _vcname__, this)}
    , R0_clk{vlSymsp->TOP.R0_clk}
    , W0_clk{vlSymsp->TOP.W0_clk}
    , R0_en{vlSymsp->TOP.R0_en}
    , W0_en{vlSymsp->TOP.W0_en}
    , W0_mask{vlSymsp->TOP.W0_mask}
    , R0_addr{vlSymsp->TOP.R0_addr}
    , W0_addr{vlSymsp->TOP.W0_addr}
    , W0_data{vlSymsp->TOP.W0_data}
    , R0_data{vlSymsp->TOP.R0_data}
    , __PVT__dpi_mem_pkg{vlSymsp->TOP.__PVT__dpi_mem_pkg}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vmem_combMem::Vmem_combMem(const char* _vcname__)
    : Vmem_combMem(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vmem_combMem::~Vmem_combMem() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vmem_combMem___024root___eval_debug_assertions(Vmem_combMem___024root* vlSelf);
#endif  // VL_DEBUG
void Vmem_combMem___024root___eval_static(Vmem_combMem___024root* vlSelf);
void Vmem_combMem___024root___eval_initial(Vmem_combMem___024root* vlSelf);
void Vmem_combMem___024root___eval_settle(Vmem_combMem___024root* vlSelf);
void Vmem_combMem___024root___eval(Vmem_combMem___024root* vlSelf);

void Vmem_combMem::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vmem_combMem::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vmem_combMem___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vmem_combMem___024root___eval_static(&(vlSymsp->TOP));
        Vmem_combMem___024root___eval_initial(&(vlSymsp->TOP));
        Vmem_combMem___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vmem_combMem___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vmem_combMem::eventsPending() { return false; }

uint64_t Vmem_combMem::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vmem_combMem::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vmem_combMem___024root___eval_final(Vmem_combMem___024root* vlSelf);

VL_ATTR_COLD void Vmem_combMem::final() {
    Vmem_combMem___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vmem_combMem::hierName() const { return vlSymsp->name(); }
const char* Vmem_combMem::modelName() const { return "Vmem_combMem"; }
unsigned Vmem_combMem::threads() const { return 1; }
void Vmem_combMem::prepareClone() const { contextp()->prepareClone(); }
void Vmem_combMem::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vmem_combMem::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vmem_combMem___024root__trace_decl_types(VerilatedVcd* tracep);

void Vmem_combMem___024root__trace_init_top(Vmem_combMem___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vmem_combMem___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vmem_combMem___024root*>(voidSelf);
    Vmem_combMem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(std::string{vlSymsp->name()}, VerilatedTracePrefixType::SCOPE_MODULE);
    Vmem_combMem___024root__trace_decl_types(tracep);
    Vmem_combMem___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vmem_combMem___024root__trace_register(Vmem_combMem___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vmem_combMem::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (tfp->isOpen()) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vmem_combMem::trace()' shall not be called after 'VerilatedVcdC::open()'.");
    }
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vmem_combMem___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}
