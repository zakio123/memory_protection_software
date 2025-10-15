// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtop__Syms.h"


void Vtop___024root__trace_chg_0_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtop___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_chg_0\n"); );
    // Init
    Vtop___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtop___024root*>(voidSelf);
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vtop___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vtop___024root__trace_chg_0_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_chg_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    VlWide<4>/*127:0*/ __Vtemp_1;
    VlWide<4>/*127:0*/ __Vtemp_2;
    VlWide<4>/*127:0*/ __Vtemp_3;
    VlWide<5>/*159:0*/ __Vtemp_6;
    VlWide<5>/*159:0*/ __Vtemp_9;
    VlWide<5>/*159:0*/ __Vtemp_12;
    VlWide<5>/*159:0*/ __Vtemp_15;
    VlWide<5>/*159:0*/ __Vtemp_18;
    VlWide<5>/*159:0*/ __Vtemp_21;
    VlWide<4>/*127:0*/ __Vtemp_24;
    VlWide<4>/*127:0*/ __Vtemp_32;
    VlWide<4>/*127:0*/ __Vtemp_40;
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[0U])) {
        bufp->chgQData(oldp+0,(vlSelf->top__DOT__read_spm_data_102),64);
        bufp->chgWData(oldp+2,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__RK[0]),128);
        bufp->chgWData(oldp+6,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__RK[1]),128);
        bufp->chgWData(oldp+10,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__RK[2]),128);
        bufp->chgWData(oldp+14,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__RK[3]),128);
        bufp->chgWData(oldp+18,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__RK[4]),128);
        bufp->chgWData(oldp+22,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__RK[5]),128);
        bufp->chgWData(oldp+26,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__RK[6]),128);
        bufp->chgWData(oldp+30,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__RK[7]),128);
        bufp->chgWData(oldp+34,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__RK[8]),128);
        bufp->chgWData(oldp+38,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__RK[9]),128);
        bufp->chgWData(oldp+42,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__RK[10]),128);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[1U])) {
        bufp->chgIData(oldp+46,(vlSelf->top__DOT__axi_m_bridge_awaddr),32);
        bufp->chgCData(oldp+47,(vlSelf->top__DOT__axi_m_bridge_awlen),8);
        bufp->chgBit(oldp+48,(vlSelf->top__DOT__axi_m_bridge_awvalid));
        bufp->chgBit(oldp+49,(vlSelf->top__DOT__axi_s_bridge_awready));
        bufp->chgQData(oldp+50,((((QData)((IData)(vlSelf->top__DOT___sb_axi_m_bridge_writedata_data_6[1U])) 
                                  << 0x20U) | (QData)((IData)(
                                                              vlSelf->top__DOT___sb_axi_m_bridge_writedata_data_6[0U])))),64);
        bufp->chgCData(oldp+52,((0xffU & vlSelf->top__DOT___sb_axi_m_bridge_writedata_data_6[2U])),8);
        bufp->chgBit(oldp+53,((1U & (vlSelf->top__DOT___sb_axi_m_bridge_writedata_data_6[2U] 
                                     >> 8U))));
        bufp->chgBit(oldp+54,(vlSelf->top__DOT___sb_axi_m_bridge_writedata_valid_7));
        bufp->chgBit(oldp+55,((0xc9U == vlSelf->top__DOT__uut__DOT__fsm)));
        bufp->chgCData(oldp+56,(vlSelf->top__DOT__axi_s_bridge_bid),4);
        bufp->chgBit(oldp+57,(vlSelf->top__DOT__axi_s_bridge_bvalid));
        bufp->chgIData(oldp+58,(vlSelf->top__DOT__axi_m_bridge_araddr),32);
        bufp->chgCData(oldp+59,(vlSelf->top__DOT__axi_m_bridge_arlen),8);
        bufp->chgBit(oldp+60,(vlSelf->top__DOT__axi_m_bridge_arvalid));
        bufp->chgBit(oldp+61,(vlSelf->top__DOT__axi_s_bridge_arready));
        bufp->chgCData(oldp+62,(vlSelf->top__DOT__axi_s_bridge_rid),4);
        bufp->chgQData(oldp+63,(vlSelf->top__DOT__axi_s_bridge_rdata),64);
        bufp->chgBit(oldp+65,(vlSelf->top__DOT__axi_s_bridge_rlast));
        bufp->chgBit(oldp+66,(vlSelf->top__DOT__axi_s_bridge_rvalid));
        bufp->chgBit(oldp+67,((1U & (~ (IData)(vlSelf->top__DOT___sb_axi_m_bridge_readdata_tmp_valid_25)))));
        bufp->chgIData(oldp+68,(vlSelf->top__DOT__axi_m_dram_awaddr),32);
        bufp->chgCData(oldp+69,(vlSelf->top__DOT__axi_m_dram_awlen),8);
        bufp->chgBit(oldp+70,(vlSelf->top__DOT__axi_m_dram_awvalid));
        bufp->chgBit(oldp+71,(vlSelf->top__DOT__v_memory_awready));
        __Vtemp_1[0U] = vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___sb_axi_m_dram_writedata_data_15[0U];
        __Vtemp_1[1U] = vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___sb_axi_m_dram_writedata_data_15[1U];
        __Vtemp_1[2U] = vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___sb_axi_m_dram_writedata_data_15[2U];
        __Vtemp_1[3U] = vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___sb_axi_m_dram_writedata_data_15[3U];
        bufp->chgWData(oldp+72,(__Vtemp_1),128);
        bufp->chgSData(oldp+76,((0xffffU & vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___sb_axi_m_dram_writedata_data_15[4U])),16);
        bufp->chgBit(oldp+77,((1U & (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___sb_axi_m_dram_writedata_data_15[4U] 
                                     >> 0x10U))));
        bufp->chgBit(oldp+78,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___sb_axi_m_dram_writedata_valid_16));
        bufp->chgBit(oldp+79,((1U & (~ (IData)(vlSelf->top__DOT___v_memory_wdata_fifo_almost_full)))));
        bufp->chgBit(oldp+80,(vlSelf->top__DOT__v_memory_bvalid));
        bufp->chgIData(oldp+81,(vlSelf->top__DOT__axi_m_dram_araddr),32);
        bufp->chgCData(oldp+82,(vlSelf->top__DOT__axi_m_dram_arlen),8);
        bufp->chgBit(oldp+83,(vlSelf->top__DOT__axi_m_dram_arvalid));
        bufp->chgBit(oldp+84,(vlSelf->top__DOT__v_memory_arready));
        bufp->chgWData(oldp+85,(vlSelf->top__DOT__v_memory_rdata),128);
        bufp->chgBit(oldp+89,(vlSelf->top__DOT__v_memory_rlast));
        bufp->chgBit(oldp+90,(vlSelf->top__DOT__v_memory_rvalid));
        bufp->chgBit(oldp+91,((1U & (~ (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___sb_axi_m_dram_readdata_tmp_valid_34)))));
        bufp->chgIData(oldp+92,(vlSelf->top__DOT__llc_requester_awaddr),32);
        bufp->chgCData(oldp+93,(vlSelf->top__DOT__llc_requester_awlen),8);
        bufp->chgBit(oldp+94,(vlSelf->top__DOT__llc_requester_awvalid));
        bufp->chgBit(oldp+95,(vlSelf->top__DOT__axi_s_llc_awready));
        __Vtemp_2[0U] = vlSelf->top__DOT___sb_llc_requester_writedata_data_222[0U];
        __Vtemp_2[1U] = vlSelf->top__DOT___sb_llc_requester_writedata_data_222[1U];
        __Vtemp_2[2U] = vlSelf->top__DOT___sb_llc_requester_writedata_data_222[2U];
        __Vtemp_2[3U] = vlSelf->top__DOT___sb_llc_requester_writedata_data_222[3U];
        bufp->chgWData(oldp+96,(__Vtemp_2),128);
        bufp->chgSData(oldp+100,((0xffffU & vlSelf->top__DOT___sb_llc_requester_writedata_data_222[4U])),16);
        bufp->chgBit(oldp+101,((1U & (vlSelf->top__DOT___sb_llc_requester_writedata_data_222[4U] 
                                      >> 0x10U))));
        bufp->chgBit(oldp+102,(vlSelf->top__DOT___sb_llc_requester_writedata_valid_223));
        bufp->chgBit(oldp+103,((0xc9U == vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__fsm)));
        bufp->chgBit(oldp+104,(vlSelf->top__DOT__axi_s_llc_bvalid));
        bufp->chgIData(oldp+105,(vlSelf->top__DOT__llc_requester_araddr),32);
        bufp->chgCData(oldp+106,(vlSelf->top__DOT__llc_requester_arlen),8);
        bufp->chgBit(oldp+107,(vlSelf->top__DOT__llc_requester_arvalid));
        bufp->chgBit(oldp+108,(vlSelf->top__DOT__axi_s_llc_arready));
        bufp->chgWData(oldp+109,(vlSelf->top__DOT__axi_s_llc_rdata),128);
        bufp->chgBit(oldp+113,(vlSelf->top__DOT__axi_s_llc_rlast));
        bufp->chgBit(oldp+114,(vlSelf->top__DOT__axi_s_llc_rvalid));
        bufp->chgBit(oldp+115,((1U & (~ (IData)(vlSelf->top__DOT___sb_llc_requester_readdata_tmp_valid_241)))));
        bufp->chgCData(oldp+116,(vlSelf->top__DOT__count___05Faxi_m_bridge_read_req_fifo),4);
        bufp->chgCData(oldp+117,((0xffU & (vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__mem
                                           [vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__tail][4U] 
                                           >> 1U))),8);
        bufp->chgIData(oldp+118,(((vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__mem
                                   [vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__tail][4U] 
                                   << 0x1fU) | (vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__mem
                                                [vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__tail][3U] 
                                                >> 1U))),32);
        bufp->chgIData(oldp+119,(((vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__mem
                                   [vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__tail][3U] 
                                   << 0x1fU) | (vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__mem
                                                [vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__tail][2U] 
                                                >> 1U))),32);
        bufp->chgQData(oldp+120,((0x1ffffffffULL & 
                                  (((QData)((IData)(
                                                    vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__mem
                                                    [vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__tail][2U])) 
                                    << 0x20U) | (QData)((IData)(
                                                                vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__mem
                                                                [vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__tail][1U]))))),33);
        bufp->chgIData(oldp+122,(vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__mem
                                 [vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__tail][0U]),32);
        bufp->chgCData(oldp+123,(vlSelf->top__DOT__count___05Faxi_m_bridge_write_req_fifo),4);
        bufp->chgCData(oldp+124,((0xffU & (vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__mem
                                           [vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__tail][4U] 
                                           >> 1U))),8);
        bufp->chgIData(oldp+125,(((vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__mem
                                   [vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__tail][4U] 
                                   << 0x1fU) | (vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__mem
                                                [vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__tail][3U] 
                                                >> 1U))),32);
        bufp->chgIData(oldp+126,(((vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__mem
                                   [vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__tail][3U] 
                                   << 0x1fU) | (vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__mem
                                                [vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__tail][2U] 
                                                >> 1U))),32);
        bufp->chgQData(oldp+127,((0x1ffffffffULL & 
                                  (((QData)((IData)(
                                                    vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__mem
                                                    [vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__tail][2U])) 
                                    << 0x20U) | (QData)((IData)(
                                                                vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__mem
                                                                [vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__tail][1U]))))),33);
        bufp->chgIData(oldp+129,(vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__mem
                                 [vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__tail][0U]),32);
        bufp->chgCData(oldp+130,(vlSelf->top__DOT__count___05Fv_memory_wreq_fifo),4);
        bufp->chgCData(oldp+131,(vlSelf->top__DOT__count___05Fv_memory_rreq_fifo),4);
        bufp->chgCData(oldp+132,(vlSelf->top__DOT__count___05Fv_memory_wdata_fifo),4);
        bufp->chgWData(oldp+133,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___sb_axi_m_dram_writedata_data_15),145);
        bufp->chgSData(oldp+138,((0x1ffU & ((IData)(1U) 
                                            + (IData)(vlSelf->top__DOT__axi_m_dram_awlen)))),9);
        bufp->chgQData(oldp+139,((((QData)((IData)(vlSelf->top__DOT__axi_m_dram_awaddr)) 
                                   << 9U) | (QData)((IData)(
                                                            (0x1ffU 
                                                             & ((IData)(1U) 
                                                                + (IData)(vlSelf->top__DOT__axi_m_dram_awlen))))))),41);
        bufp->chgIData(oldp+141,((IData)((vlSelf->top__DOT___v_memory_wreq_fifo_rdata 
                                          >> 9U))),32);
        bufp->chgSData(oldp+142,((0x1ffU & (IData)(vlSelf->top__DOT___v_memory_wreq_fifo_rdata))),9);
        __Vtemp_3[0U] = vlSelf->top__DOT___v_memory_wdata_fifo_rdata[0U];
        __Vtemp_3[1U] = vlSelf->top__DOT___v_memory_wdata_fifo_rdata[1U];
        __Vtemp_3[2U] = vlSelf->top__DOT___v_memory_wdata_fifo_rdata[2U];
        __Vtemp_3[3U] = vlSelf->top__DOT___v_memory_wdata_fifo_rdata[3U];
        bufp->chgWData(oldp+143,(__Vtemp_3),128);
        bufp->chgSData(oldp+147,((0xffffU & vlSelf->top__DOT___v_memory_wdata_fifo_rdata[4U])),16);
        bufp->chgBit(oldp+148,((1U & (vlSelf->top__DOT___v_memory_wdata_fifo_rdata[4U] 
                                      >> 0x10U))));
        bufp->chgBit(oldp+149,((1U & (~ (IData)(vlSelf->top__DOT___v_memory_wdata_fifo_empty)))));
        bufp->chgBit(oldp+150,(vlSelf->top__DOT__write_data_wready_85));
        bufp->chgSData(oldp+151,((0x1ffU & ((IData)(1U) 
                                            + (IData)(vlSelf->top__DOT__axi_m_dram_arlen)))),9);
        bufp->chgQData(oldp+152,((((QData)((IData)(vlSelf->top__DOT__axi_m_dram_araddr)) 
                                   << 9U) | (QData)((IData)(
                                                            (0x1ffU 
                                                             & ((IData)(1U) 
                                                                + (IData)(vlSelf->top__DOT__axi_m_dram_arlen))))))),41);
        bufp->chgIData(oldp+154,((IData)((vlSelf->top__DOT___v_memory_rreq_fifo_rdata 
                                          >> 9U))),32);
        bufp->chgSData(oldp+155,((0x1ffU & (IData)(vlSelf->top__DOT___v_memory_rreq_fifo_rdata))),9);
        bufp->chgQData(oldp+156,(vlSelf->top__DOT__tmp),64);
        bufp->chgQData(oldp+158,(vlSelf->top__DOT__req_addr_103),64);
        bufp->chgBit(oldp+160,(vlSelf->top__DOT__is_write_104));
        bufp->chgQData(oldp+161,(vlSelf->top__DOT__tag_105),64);
        bufp->chgQData(oldp+163,(vlSelf->top__DOT__expected_tag_106),64);
        bufp->chgQData(oldp+165,(vlSelf->top__DOT__tag_blockaddr_107),64);
        bufp->chgQData(oldp+167,(vlSelf->top__DOT__tag_spm_addr_108),64);
        bufp->chgQData(oldp+169,(vlSelf->top__DOT__line_info_109),64);
        bufp->chgQData(oldp+171,(vlSelf->top__DOT__current_block_addr_110),64);
        bufp->chgBit(oldp+173,(vlSelf->top__DOT__valid_111));
        bufp->chgBit(oldp+174,(vlSelf->top__DOT__dirty_112));
        bufp->chgQData(oldp+175,(vlSelf->top__DOT__seed_low_113),64);
        bufp->chgQData(oldp+177,(vlSelf->top__DOT__seed_high_114),64);
        bufp->chgQData(oldp+179,(vlSelf->top__DOT__counter_blockaddr_115),64);
        bufp->chgQData(oldp+181,(vlSelf->top__DOT__major_counter_116),64);
        bufp->chgQData(oldp+183,(vlSelf->top__DOT__minor_counters_117),64);
        bufp->chgQData(oldp+185,(vlSelf->top__DOT__minor_counter_118),64);
        bufp->chgQData(oldp+187,(vlSelf->top__DOT__minor_counter_bitoffset_119),64);
        bufp->chgQData(oldp+189,(vlSelf->top__DOT__counter_index_120),64);
        bufp->chgQData(oldp+191,(vlSelf->top__DOT__height_121),64);
        bufp->chgQData(oldp+193,(vlSelf->top__DOT__spm_dram_addr_122),64);
        bufp->chgQData(oldp+195,(vlSelf->top__DOT__spm_local_addr_123),64);
        bufp->chgQData(oldp+197,(vlSelf->top__DOT__spm_manage_addr_124),64);
        bufp->chgQData(oldp+199,(vlSelf->top__DOT__tmp_addr_125),64);
        bufp->chgIData(oldp+201,(vlSelf->top__DOT__ctrl_thread),32);
        bufp->chgQData(oldp+202,(vlSelf->top__DOT__axim_rdata_126),64);
        bufp->chgQData(oldp+204,(vlSelf->top__DOT__axim_rdata_127),64);
        bufp->chgQData(oldp+206,(vlSelf->top__DOT__axim_rdata_128),64);
        bufp->chgQData(oldp+208,(vlSelf->top__DOT__axim_rdata_129),64);
        bufp->chgQData(oldp+210,(vlSelf->top__DOT__axim_rdata_130),64);
        bufp->chgQData(oldp+212,(vlSelf->top__DOT__axim_rdata_131),64);
        bufp->chgQData(oldp+214,(vlSelf->top__DOT__axim_rdata_132),64);
        bufp->chgQData(oldp+216,(vlSelf->top__DOT__axim_rdata_133),64);
        bufp->chgQData(oldp+218,(vlSelf->top__DOT__axim_rdata_134),64);
        bufp->chgQData(oldp+220,(vlSelf->top__DOT__axim_rdata_135),64);
        bufp->chgQData(oldp+222,(vlSelf->top__DOT__axim_rdata_136),64);
        bufp->chgQData(oldp+224,(vlSelf->top__DOT__axim_rdata_137),64);
        bufp->chgQData(oldp+226,(vlSelf->top__DOT__axim_rdata_138),64);
        bufp->chgQData(oldp+228,(vlSelf->top__DOT__axim_rdata_139),64);
        bufp->chgQData(oldp+230,(vlSelf->top__DOT__axim_rdata_140),64);
        bufp->chgQData(oldp+232,(vlSelf->top__DOT__axim_rdata_141),64);
        bufp->chgQData(oldp+234,(vlSelf->top__DOT__axim_rdata_142),64);
        bufp->chgQData(oldp+236,(vlSelf->top__DOT__axim_rdata_143),64);
        bufp->chgQData(oldp+238,(vlSelf->top__DOT__axim_rdata_144),64);
        bufp->chgQData(oldp+240,(vlSelf->top__DOT__axim_rdata_145),64);
        bufp->chgQData(oldp+242,(vlSelf->top__DOT__axim_rdata_146),64);
        bufp->chgQData(oldp+244,(vlSelf->top__DOT__axim_rdata_147),64);
        bufp->chgQData(oldp+246,(vlSelf->top__DOT__axim_rdata_148),64);
        bufp->chgQData(oldp+248,(vlSelf->top__DOT__axim_rdata_149),64);
        bufp->chgQData(oldp+250,(vlSelf->top__DOT__axim_rdata_150),64);
        bufp->chgQData(oldp+252,(vlSelf->top__DOT__axim_rdata_151),64);
        bufp->chgQData(oldp+254,(vlSelf->top__DOT__axim_rdata_152),64);
        bufp->chgQData(oldp+256,(vlSelf->top__DOT__axim_rdata_153),64);
        bufp->chgQData(oldp+258,(vlSelf->top__DOT__axim_rdata_154),64);
        bufp->chgQData(oldp+260,(vlSelf->top__DOT__axim_rdata_155),64);
        bufp->chgQData(oldp+262,(vlSelf->top__DOT__axim_rdata_156),64);
        bufp->chgQData(oldp+264,(vlSelf->top__DOT__axim_rdata_157),64);
        bufp->chgQData(oldp+266,(vlSelf->top__DOT__axim_rdata_158),64);
        bufp->chgQData(oldp+268,(vlSelf->top__DOT__axim_rdata_159),64);
        bufp->chgQData(oldp+270,(vlSelf->top__DOT__axim_rdata_160),64);
        bufp->chgQData(oldp+272,(vlSelf->top__DOT__axim_rdata_161),64);
        bufp->chgQData(oldp+274,(vlSelf->top__DOT__axim_rdata_162),64);
        bufp->chgQData(oldp+276,(vlSelf->top__DOT__axim_rdata_163),64);
        bufp->chgQData(oldp+278,(vlSelf->top__DOT__axim_rdata_164),64);
        bufp->chgQData(oldp+280,(vlSelf->top__DOT__axim_rdata_165),64);
        bufp->chgQData(oldp+282,(vlSelf->top__DOT__axim_rdata_166),64);
        bufp->chgQData(oldp+284,(vlSelf->top__DOT__axim_rdata_167),64);
        bufp->chgQData(oldp+286,(vlSelf->top__DOT__axim_rdata_168),64);
        bufp->chgQData(oldp+288,(vlSelf->top__DOT__axim_rdata_169),64);
        bufp->chgQData(oldp+290,(vlSelf->top__DOT__axim_rdata_170),64);
        bufp->chgQData(oldp+292,(vlSelf->top__DOT__axim_rdata_171),64);
        bufp->chgQData(oldp+294,(vlSelf->top__DOT__axim_rdata_172),64);
        bufp->chgQData(oldp+296,(vlSelf->top__DOT__axim_rdata_173),64);
        bufp->chgQData(oldp+298,(vlSelf->top__DOT__axim_rdata_174),64);
        bufp->chgQData(oldp+300,(vlSelf->top__DOT__axim_rdata_175),64);
        bufp->chgQData(oldp+302,(vlSelf->top__DOT__axim_rdata_176),64);
        bufp->chgQData(oldp+304,(vlSelf->top__DOT__axim_rdata_177),64);
        bufp->chgQData(oldp+306,(vlSelf->top__DOT__axim_rdata_178),64);
        bufp->chgQData(oldp+308,(vlSelf->top__DOT__axim_rdata_179),64);
        bufp->chgQData(oldp+310,(vlSelf->top__DOT__axim_rdata_180),64);
        bufp->chgQData(oldp+312,(vlSelf->top__DOT__axim_rdata_181),64);
        bufp->chgQData(oldp+314,(vlSelf->top__DOT__axim_rdata_182),64);
        bufp->chgQData(oldp+316,(vlSelf->top__DOT__axim_rdata_183),64);
        bufp->chgQData(oldp+318,(vlSelf->top__DOT__axim_rdata_184),64);
        bufp->chgQData(oldp+320,(vlSelf->top__DOT__axim_rdata_185),64);
        bufp->chgQData(oldp+322,(vlSelf->top__DOT__axim_rdata_186),64);
        bufp->chgQData(oldp+324,(vlSelf->top__DOT__axim_rdata_187),64);
        bufp->chgQData(oldp+326,(vlSelf->top__DOT__axim_rdata_188),64);
        bufp->chgQData(oldp+328,(vlSelf->top__DOT__axim_rdata_189),64);
        bufp->chgQData(oldp+330,(vlSelf->top__DOT__axim_rdata_190),64);
        bufp->chgQData(oldp+332,(vlSelf->top__DOT__axim_rdata_191),64);
        bufp->chgQData(oldp+334,(vlSelf->top__DOT__axim_rdata_192),64);
        bufp->chgQData(oldp+336,(vlSelf->top__DOT__axim_rdata_193),64);
        bufp->chgQData(oldp+338,(vlSelf->top__DOT__axim_rdata_194),64);
        bufp->chgQData(oldp+340,(vlSelf->top__DOT__axim_rdata_195),64);
        bufp->chgQData(oldp+342,(vlSelf->top__DOT__axim_rdata_196),64);
        bufp->chgQData(oldp+344,(vlSelf->top__DOT__axim_rdata_197),64);
        bufp->chgQData(oldp+346,(vlSelf->top__DOT__axim_rdata_198),64);
        bufp->chgQData(oldp+348,(vlSelf->top__DOT__axim_rdata_199),64);
        bufp->chgQData(oldp+350,(vlSelf->top__DOT__axim_rdata_200),64);
        bufp->chgQData(oldp+352,(vlSelf->top__DOT__axim_rdata_201),64);
        bufp->chgQData(oldp+354,(vlSelf->top__DOT__axim_rdata_202),64);
        bufp->chgQData(oldp+356,(vlSelf->top__DOT__axim_rdata_203),64);
        bufp->chgQData(oldp+358,(vlSelf->top__DOT__axim_rdata_204),64);
        bufp->chgQData(oldp+360,(vlSelf->top__DOT__axim_rdata_205),64);
        bufp->chgQData(oldp+362,(vlSelf->top__DOT__axim_rdata_206),64);
        bufp->chgQData(oldp+364,(vlSelf->top__DOT__axim_rdata_207),64);
        bufp->chgQData(oldp+366,(vlSelf->top__DOT__axim_rdata_208),64);
        bufp->chgQData(oldp+368,(vlSelf->top__DOT__axim_rdata_209),64);
        bufp->chgQData(oldp+370,(vlSelf->top__DOT__axim_rdata_210),64);
        bufp->chgQData(oldp+372,(vlSelf->top__DOT__axim_rdata_211),64);
        bufp->chgQData(oldp+374,(vlSelf->top__DOT__axim_rdata_212),64);
        bufp->chgQData(oldp+376,(vlSelf->top__DOT__axim_rdata_213),64);
        bufp->chgQData(oldp+378,(vlSelf->top__DOT__axim_rdata_214),64);
        bufp->chgQData(oldp+380,(vlSelf->top__DOT__axim_rdata_215),64);
        bufp->chgCData(oldp+382,(vlSelf->top__DOT__count___05Fllc_requester_read_req_fifo),4);
        bufp->chgCData(oldp+383,((0xffU & (vlSelf->top__DOT___llc_requester_read_req_fifo_rdata[4U] 
                                           >> 1U))),8);
        bufp->chgIData(oldp+384,(((vlSelf->top__DOT___llc_requester_read_req_fifo_rdata[4U] 
                                   << 0x1fU) | (vlSelf->top__DOT___llc_requester_read_req_fifo_rdata[3U] 
                                                >> 1U))),32);
        bufp->chgIData(oldp+385,(((vlSelf->top__DOT___llc_requester_read_req_fifo_rdata[3U] 
                                   << 0x1fU) | (vlSelf->top__DOT___llc_requester_read_req_fifo_rdata[2U] 
                                                >> 1U))),32);
        bufp->chgQData(oldp+386,((0x1ffffffffULL & 
                                  (((QData)((IData)(
                                                    vlSelf->top__DOT___llc_requester_read_req_fifo_rdata[2U])) 
                                    << 0x20U) | (QData)((IData)(
                                                                vlSelf->top__DOT___llc_requester_read_req_fifo_rdata[1U]))))),33);
        bufp->chgIData(oldp+388,(vlSelf->top__DOT___llc_requester_read_req_fifo_rdata[0U]),32);
        bufp->chgCData(oldp+389,(vlSelf->top__DOT__count___05Fllc_requester_write_req_fifo),4);
        bufp->chgCData(oldp+390,((0xffU & (vlSelf->top__DOT___llc_requester_write_req_fifo_rdata[4U] 
                                           >> 1U))),8);
        bufp->chgIData(oldp+391,(((vlSelf->top__DOT___llc_requester_write_req_fifo_rdata[4U] 
                                   << 0x1fU) | (vlSelf->top__DOT___llc_requester_write_req_fifo_rdata[3U] 
                                                >> 1U))),32);
        bufp->chgIData(oldp+392,(((vlSelf->top__DOT___llc_requester_write_req_fifo_rdata[3U] 
                                   << 0x1fU) | (vlSelf->top__DOT___llc_requester_write_req_fifo_rdata[2U] 
                                                >> 1U))),32);
        bufp->chgQData(oldp+393,((0x1ffffffffULL & 
                                  (((QData)((IData)(
                                                    vlSelf->top__DOT___llc_requester_write_req_fifo_rdata[2U])) 
                                    << 0x20U) | (QData)((IData)(
                                                                vlSelf->top__DOT___llc_requester_write_req_fifo_rdata[1U]))))),33);
        bufp->chgIData(oldp+395,(vlSelf->top__DOT___llc_requester_write_req_fifo_rdata[0U]),32);
        bufp->chgIData(oldp+396,(vlSelf->top__DOT__request_ram_0_addr),20);
        bufp->chgWData(oldp+397,(vlSelf->top__DOT__inst_request_ram__DOT__request_ram_0_rdata_out),128);
        bufp->chgWData(oldp+401,(vlSelf->top__DOT__request_ram_0_wdata),128);
        bufp->chgBit(oldp+405,((4U == vlSelf->top__DOT__request_thread)));
        bufp->chgBit(oldp+406,(vlSelf->top__DOT__request_ram_0_enable));
        bufp->chgIData(oldp+407,(vlSelf->top__DOT__receive_ram_0_addr),20);
        bufp->chgWData(oldp+408,(vlSelf->top__DOT__inst_receive_ram__DOT__receive_ram_0_rdata_out),128);
        bufp->chgWData(oldp+412,(vlSelf->top__DOT__receive_ram_0_wdata),128);
        bufp->chgBit(oldp+416,(vlSelf->top__DOT__receive_ram_0_wenable));
        bufp->chgBit(oldp+417,(vlSelf->top__DOT__receive_ram_0_enable));
        bufp->chgWData(oldp+418,(vlSelf->top__DOT__read_llc_data_282),128);
        bufp->chgQData(oldp+422,(vlSelf->top__DOT__a_283),64);
        bufp->chgQData(oldp+424,(vlSelf->top__DOT__c_284),64);
        bufp->chgQData(oldp+426,(vlSelf->top__DOT__N_285),64);
        bufp->chgQData(oldp+428,(vlSelf->top__DOT__x_286),64);
        bufp->chgQData(oldp+430,(vlSelf->top__DOT__y_287),64);
        bufp->chgIData(oldp+432,(vlSelf->top__DOT__request_thread),32);
        bufp->chgIData(oldp+433,((0xffffffcU & VL_SHIFTL_III(32,32,32, vlSelf->top__DOT___request_thread_i_122, 2U))),32);
        bufp->chgIData(oldp+434,((0xffffffc0U & VL_SHIFTL_III(32,32,32, vlSelf->top__DOT___request_thread_i_122, 6U))),32);
        bufp->chgCData(oldp+435,(vlSelf->top__DOT___llc_requester_write_op_sel),8);
        bufp->chgIData(oldp+436,(vlSelf->top__DOT___llc_requester_write_local_addr),32);
        bufp->chgIData(oldp+437,(vlSelf->top__DOT___llc_requester_write_local_stride),32);
        bufp->chgQData(oldp+438,(vlSelf->top__DOT___llc_requester_write_local_size),33);
        bufp->chgIData(oldp+440,(vlSelf->top__DOT___llc_requester_write_local_blocksize),32);
        __Vtemp_6[0U] = vlSelf->top__DOT___llc_requester_write_local_blocksize;
        __Vtemp_6[1U] = (IData)(vlSelf->top__DOT___llc_requester_write_local_size);
        __Vtemp_6[2U] = (((IData)((((QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_addr)) 
                                    << 0x20U) | (QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_stride)))) 
                          << 1U) | (IData)((vlSelf->top__DOT___llc_requester_write_local_size 
                                            >> 0x20U)));
        __Vtemp_6[3U] = (((IData)((((QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_addr)) 
                                    << 0x20U) | (QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_stride)))) 
                          >> 0x1fU) | ((IData)(((((QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_addr)) 
                                                  << 0x20U) 
                                                 | (QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_stride))) 
                                                >> 0x20U)) 
                                       << 1U));
        __Vtemp_6[4U] = (((IData)(vlSelf->top__DOT___llc_requester_write_op_sel) 
                          << 1U) | ((IData)(((((QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_addr)) 
                                               << 0x20U) 
                                              | (QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_stride))) 
                                             >> 0x20U)) 
                                    >> 0x1fU));
        bufp->chgWData(oldp+441,(__Vtemp_6),137);
        bufp->chgIData(oldp+446,(VL_SHIFTR_III(32,32,32, vlSelf->top__DOT___llc_requester_write_global_addr, 4U)),32);
        bufp->chgIData(oldp+447,((0xfffffff0U & vlSelf->top__DOT___llc_requester_write_global_addr)),32);
        bufp->chgQData(oldp+448,(vlSelf->top__DOT___llc_requester_write_cur_global_size),33);
        __Vtemp_9[0U] = vlSelf->top__DOT___llc_requester_write_local_blocksize;
        __Vtemp_9[1U] = (IData)(vlSelf->top__DOT___llc_requester_write_cur_global_size);
        __Vtemp_9[2U] = (((IData)((((QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_addr)) 
                                    << 0x20U) | (QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_stride)))) 
                          << 1U) | (IData)((vlSelf->top__DOT___llc_requester_write_cur_global_size 
                                            >> 0x20U)));
        __Vtemp_9[3U] = (((IData)((((QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_addr)) 
                                    << 0x20U) | (QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_stride)))) 
                          >> 0x1fU) | ((IData)(((((QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_addr)) 
                                                  << 0x20U) 
                                                 | (QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_stride))) 
                                                >> 0x20U)) 
                                       << 1U));
        __Vtemp_9[4U] = (((IData)(vlSelf->top__DOT___llc_requester_write_op_sel) 
                          << 1U) | ((IData)(((((QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_addr)) 
                                               << 0x20U) 
                                              | (QData)((IData)(vlSelf->top__DOT___llc_requester_write_local_stride))) 
                                             >> 0x20U)) 
                                    >> 0x1fU));
        bufp->chgWData(oldp+450,(__Vtemp_9),137);
        bufp->chgIData(oldp+455,(vlSelf->top__DOT__read_burst_fsm_0),32);
        bufp->chgIData(oldp+456,(vlSelf->top__DOT__read_burst_addr_318),20);
        bufp->chgIData(oldp+457,(vlSelf->top__DOT__read_burst_stride_319),20);
        bufp->chgQData(oldp+458,(vlSelf->top__DOT__read_burst_length_320),33);
        bufp->chgBit(oldp+460,(vlSelf->top__DOT__read_burst_rvalid_321));
        bufp->chgBit(oldp+461,(vlSelf->top__DOT__read_burst_rlast_322));
        bufp->chgIData(oldp+462,((0xfffffffcU & VL_SHIFTL_III(32,32,32, (IData)(vlSelf->top__DOT__y_287), 2U))),32);
        bufp->chgIData(oldp+463,((0xffffffc0U & VL_SHIFTL_III(32,32,32, (IData)(vlSelf->top__DOT__y_287), 6U))),32);
        bufp->chgCData(oldp+464,(vlSelf->top__DOT___llc_requester_read_op_sel),8);
        bufp->chgIData(oldp+465,(vlSelf->top__DOT___llc_requester_read_local_addr),32);
        bufp->chgIData(oldp+466,(vlSelf->top__DOT___llc_requester_read_local_stride),32);
        bufp->chgQData(oldp+467,(vlSelf->top__DOT___llc_requester_read_local_size),33);
        bufp->chgIData(oldp+469,(vlSelf->top__DOT___llc_requester_read_local_blocksize),32);
        __Vtemp_12[0U] = vlSelf->top__DOT___llc_requester_read_local_blocksize;
        __Vtemp_12[1U] = (IData)(vlSelf->top__DOT___llc_requester_read_local_size);
        __Vtemp_12[2U] = (((IData)((((QData)((IData)(vlSelf->top__DOT___llc_requester_read_local_addr)) 
                                     << 0x20U) | (QData)((IData)(vlSelf->top__DOT___llc_requester_read_local_stride)))) 
                           << 1U) | (IData)((vlSelf->top__DOT___llc_requester_read_local_size 
                                             >> 0x20U)));
        __Vtemp_12[3U] = (((IData)((((QData)((IData)(vlSelf->top__DOT___llc_requester_read_local_addr)) 
                                     << 0x20U) | (QData)((IData)(vlSelf->top__DOT___llc_requester_read_local_stride)))) 
                           >> 0x1fU) | ((IData)(((((QData)((IData)(vlSelf->top__DOT___llc_requester_read_local_addr)) 
                                                   << 0x20U) 
                                                  | (QData)((IData)(vlSelf->top__DOT___llc_requester_read_local_stride))) 
                                                 >> 0x20U)) 
                                        << 1U));
        __Vtemp_12[4U] = (((IData)(vlSelf->top__DOT___llc_requester_read_op_sel) 
                           << 1U) | ((IData)(((((QData)((IData)(vlSelf->top__DOT___llc_requester_read_local_addr)) 
                                                << 0x20U) 
                                               | (QData)((IData)(vlSelf->top__DOT___llc_requester_read_local_stride))) 
                                              >> 0x20U)) 
                                     >> 0x1fU));
        bufp->chgWData(oldp+470,(__Vtemp_12),137);
        bufp->chgIData(oldp+475,(VL_SHIFTR_III(32,32,32, vlSelf->top__DOT___llc_requester_read_global_addr, 4U)),32);
        bufp->chgIData(oldp+476,((0xfffffff0U & vlSelf->top__DOT___llc_requester_read_global_addr)),32);
        bufp->chgIData(oldp+477,(vlSelf->top__DOT__write_burst_fsm_1),32);
        bufp->chgIData(oldp+478,(vlSelf->top__DOT__write_burst_addr_348),20);
        bufp->chgIData(oldp+479,(vlSelf->top__DOT__write_burst_stride_349),20);
        bufp->chgQData(oldp+480,(vlSelf->top__DOT__write_burst_length_350),33);
        bufp->chgBit(oldp+482,(vlSelf->top__DOT__write_burst_done_351));
        bufp->chgWData(oldp+483,(vlSelf->top__DOT__read_rdata_354),128);
        bufp->chgCData(oldp+487,(vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+488,(vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+489,(vlSelf->top__DOT___axi_m_bridge_read_req_fifo_empty));
        bufp->chgBit(oldp+490,(((IData)(vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__head) 
                                == (7U & ((IData)(1U) 
                                          + (IData)(vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+491,(((7U & ((IData)(1U) 
                                       + (IData)(vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__head))) 
                                == (IData)(vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__tail))));
        bufp->chgBit(oldp+492,(((7U & ((IData)(2U) 
                                       + (IData)(vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__head))) 
                                == (IData)(vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+493,(vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__mem
                                 [vlSelf->top__DOT__inst___05Faxi_m_bridge_read_req_fifo__DOT__tail]),137);
        bufp->chgCData(oldp+498,(vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+499,(vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+500,(vlSelf->top__DOT___axi_m_bridge_write_req_fifo_empty));
        bufp->chgBit(oldp+501,(((IData)(vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__head) 
                                == (7U & ((IData)(1U) 
                                          + (IData)(vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+502,(((7U & ((IData)(1U) 
                                       + (IData)(vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__head))) 
                                == (IData)(vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__tail))));
        bufp->chgBit(oldp+503,(((7U & ((IData)(2U) 
                                       + (IData)(vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__head))) 
                                == (IData)(vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+504,(vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__mem
                                 [vlSelf->top__DOT__inst___05Faxi_m_bridge_write_req_fifo__DOT__tail]),137);
        bufp->chgWData(oldp+509,(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__mem[0]),137);
        bufp->chgWData(oldp+514,(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__mem[1]),137);
        bufp->chgWData(oldp+519,(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__mem[2]),137);
        bufp->chgWData(oldp+524,(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__mem[3]),137);
        bufp->chgWData(oldp+529,(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__mem[4]),137);
        bufp->chgWData(oldp+534,(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__mem[5]),137);
        bufp->chgWData(oldp+539,(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__mem[6]),137);
        bufp->chgWData(oldp+544,(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__mem[7]),137);
        bufp->chgCData(oldp+549,(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+550,(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+551,(vlSelf->top__DOT___llc_requester_read_req_fifo_empty));
        bufp->chgBit(oldp+552,(((IData)(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__head) 
                                == (7U & ((IData)(1U) 
                                          + (IData)(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+553,(vlSelf->top__DOT___llc_requester_read_req_fifo_full));
        bufp->chgBit(oldp+554,(((7U & ((IData)(2U) 
                                       + (IData)(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__head))) 
                                == (IData)(vlSelf->top__DOT__inst___05Fllc_requester_read_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+555,(vlSelf->top__DOT___llc_requester_read_req_fifo_rdata),137);
        bufp->chgWData(oldp+560,(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__mem[0]),137);
        bufp->chgWData(oldp+565,(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__mem[1]),137);
        bufp->chgWData(oldp+570,(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__mem[2]),137);
        bufp->chgWData(oldp+575,(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__mem[3]),137);
        bufp->chgWData(oldp+580,(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__mem[4]),137);
        bufp->chgWData(oldp+585,(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__mem[5]),137);
        bufp->chgWData(oldp+590,(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__mem[6]),137);
        bufp->chgWData(oldp+595,(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__mem[7]),137);
        bufp->chgCData(oldp+600,(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+601,(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+602,(vlSelf->top__DOT___llc_requester_write_req_fifo_empty));
        bufp->chgBit(oldp+603,(((IData)(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__head) 
                                == (7U & ((IData)(1U) 
                                          + (IData)(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+604,(vlSelf->top__DOT___llc_requester_write_req_fifo_full));
        bufp->chgBit(oldp+605,(((7U & ((IData)(2U) 
                                       + (IData)(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__head))) 
                                == (IData)(vlSelf->top__DOT__inst___05Fllc_requester_write_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+606,(vlSelf->top__DOT___llc_requester_write_req_fifo_rdata),137);
        bufp->chgQData(oldp+611,(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__mem[0]),41);
        bufp->chgQData(oldp+613,(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__mem[1]),41);
        bufp->chgQData(oldp+615,(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__mem[2]),41);
        bufp->chgQData(oldp+617,(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__mem[3]),41);
        bufp->chgQData(oldp+619,(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__mem[4]),41);
        bufp->chgQData(oldp+621,(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__mem[5]),41);
        bufp->chgQData(oldp+623,(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__mem[6]),41);
        bufp->chgQData(oldp+625,(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__mem[7]),41);
        bufp->chgCData(oldp+627,(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__head),3);
        bufp->chgCData(oldp+628,(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__tail),3);
        bufp->chgBit(oldp+629,(vlSelf->top__DOT___v_memory_rreq_fifo_empty));
        bufp->chgBit(oldp+630,(((IData)(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__head) 
                                == (7U & ((IData)(1U) 
                                          + (IData)(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__tail))))));
        bufp->chgBit(oldp+631,(vlSelf->top__DOT___v_memory_rreq_fifo_full));
        bufp->chgBit(oldp+632,(((7U & ((IData)(2U) 
                                       + (IData)(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__head))) 
                                == (IData)(vlSelf->top__DOT__inst___05Fv_memory_rreq_fifo__DOT__tail))));
        bufp->chgQData(oldp+633,(vlSelf->top__DOT___v_memory_rreq_fifo_rdata),41);
        bufp->chgWData(oldp+635,(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__mem[0]),145);
        bufp->chgWData(oldp+640,(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__mem[1]),145);
        bufp->chgWData(oldp+645,(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__mem[2]),145);
        bufp->chgWData(oldp+650,(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__mem[3]),145);
        bufp->chgWData(oldp+655,(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__mem[4]),145);
        bufp->chgWData(oldp+660,(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__mem[5]),145);
        bufp->chgWData(oldp+665,(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__mem[6]),145);
        bufp->chgWData(oldp+670,(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__mem[7]),145);
        bufp->chgCData(oldp+675,(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__head),3);
        bufp->chgCData(oldp+676,(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__tail),3);
        bufp->chgBit(oldp+677,(vlSelf->top__DOT___v_memory_wdata_fifo_empty));
        bufp->chgBit(oldp+678,(((IData)(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__head) 
                                == (7U & ((IData)(1U) 
                                          + (IData)(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__tail))))));
        bufp->chgBit(oldp+679,(vlSelf->top__DOT___v_memory_wdata_fifo_full));
        bufp->chgBit(oldp+680,(((7U & ((IData)(2U) 
                                       + (IData)(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__head))) 
                                == (IData)(vlSelf->top__DOT__inst___05Fv_memory_wdata_fifo__DOT__tail))));
        bufp->chgWData(oldp+681,(vlSelf->top__DOT___v_memory_wdata_fifo_rdata),145);
        bufp->chgQData(oldp+686,(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__mem[0]),41);
        bufp->chgQData(oldp+688,(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__mem[1]),41);
        bufp->chgQData(oldp+690,(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__mem[2]),41);
        bufp->chgQData(oldp+692,(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__mem[3]),41);
        bufp->chgQData(oldp+694,(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__mem[4]),41);
        bufp->chgQData(oldp+696,(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__mem[5]),41);
        bufp->chgQData(oldp+698,(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__mem[6]),41);
        bufp->chgQData(oldp+700,(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__mem[7]),41);
        bufp->chgCData(oldp+702,(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__head),3);
        bufp->chgCData(oldp+703,(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__tail),3);
        bufp->chgBit(oldp+704,(vlSelf->top__DOT___v_memory_wreq_fifo_empty));
        bufp->chgBit(oldp+705,(((IData)(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__head) 
                                == (7U & ((IData)(1U) 
                                          + (IData)(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__tail))))));
        bufp->chgBit(oldp+706,(vlSelf->top__DOT___v_memory_wreq_fifo_full));
        bufp->chgBit(oldp+707,(((7U & ((IData)(2U) 
                                       + (IData)(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__head))) 
                                == (IData)(vlSelf->top__DOT__inst___05Fv_memory_wreq_fifo__DOT__tail))));
        bufp->chgQData(oldp+708,(vlSelf->top__DOT___v_memory_wreq_fifo_rdata),41);
        bufp->chgIData(oldp+710,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_spm_awaddr),32);
        bufp->chgBit(oldp+711,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_spm_awvalid));
        bufp->chgBit(oldp+712,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_spm_awready));
        bufp->chgQData(oldp+713,((((QData)((IData)(
                                                   vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_spm_writedata_data_5[1U])) 
                                   << 0x20U) | (QData)((IData)(
                                                               vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_spm_writedata_data_5[0U])))),64);
        bufp->chgCData(oldp+715,((0xffU & vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_spm_writedata_data_5[2U])),8);
        bufp->chgBit(oldp+716,(vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_spm_writedata_valid_6));
        bufp->chgBit(oldp+717,((3U == vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_s_ctrl_spm_register_fsm)));
        bufp->chgBit(oldp+718,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_spm_bvalid));
        bufp->chgIData(oldp+719,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_spm_araddr),32);
        bufp->chgBit(oldp+720,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_spm_arvalid));
        bufp->chgBit(oldp+721,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_spm_arready));
        bufp->chgQData(oldp+722,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_spm_rdata),64);
        bufp->chgBit(oldp+724,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_spm_rvalid));
        bufp->chgBit(oldp+725,((1U & (~ (IData)(vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_spm_readdata_tmp_valid_22)))));
        bufp->chgIData(oldp+726,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_mac_awaddr),32);
        bufp->chgBit(oldp+727,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_mac_awvalid));
        bufp->chgBit(oldp+728,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_mac_awready));
        bufp->chgQData(oldp+729,((((QData)((IData)(
                                                   vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_mac_writedata_data_83[1U])) 
                                   << 0x20U) | (QData)((IData)(
                                                               vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_mac_writedata_data_83[0U])))),64);
        bufp->chgCData(oldp+731,((0xffU & vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_mac_writedata_data_83[2U])),8);
        bufp->chgBit(oldp+732,(vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_mac_writedata_valid_84));
        bufp->chgBit(oldp+733,((3U == vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT___axi_s_ctrl_mac_register_fsm)));
        bufp->chgBit(oldp+734,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_mac_bvalid));
        bufp->chgIData(oldp+735,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_mac_araddr),32);
        bufp->chgBit(oldp+736,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_mac_arvalid));
        bufp->chgBit(oldp+737,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_mac_arready));
        bufp->chgQData(oldp+738,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_mac_rdata),64);
        bufp->chgBit(oldp+740,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_mac_rvalid));
        bufp->chgBit(oldp+741,((1U & (~ (IData)(vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_mac_readdata_tmp_valid_100)))));
        bufp->chgIData(oldp+742,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_xor_awaddr),32);
        bufp->chgBit(oldp+743,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_xor_awvalid));
        bufp->chgBit(oldp+744,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_xor_awready));
        bufp->chgQData(oldp+745,((((QData)((IData)(
                                                   vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_xor_writedata_data_122[1U])) 
                                   << 0x20U) | (QData)((IData)(
                                                               vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_xor_writedata_data_122[0U])))),64);
        bufp->chgCData(oldp+747,((0xffU & vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_xor_writedata_data_122[2U])),8);
        bufp->chgBit(oldp+748,(vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_xor_writedata_valid_123));
        bufp->chgBit(oldp+749,((3U == vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axi_s_ctrl_xored_register_fsm)));
        bufp->chgBit(oldp+750,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_xor_bvalid));
        bufp->chgIData(oldp+751,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_xor_araddr),32);
        bufp->chgBit(oldp+752,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_xor_arvalid));
        bufp->chgBit(oldp+753,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_xor_arready));
        bufp->chgQData(oldp+754,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_xor_rdata),64);
        bufp->chgBit(oldp+756,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_xor_rvalid));
        bufp->chgBit(oldp+757,((1U & (~ (IData)(vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_xor_readdata_tmp_valid_139)))));
        bufp->chgIData(oldp+758,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_aes_awaddr),32);
        bufp->chgBit(oldp+759,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_aes_awvalid));
        bufp->chgBit(oldp+760,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_aes_awready));
        bufp->chgQData(oldp+761,((((QData)((IData)(
                                                   vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_aes_writedata_data_161[1U])) 
                                   << 0x20U) | (QData)((IData)(
                                                               vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_aes_writedata_data_161[0U])))),64);
        bufp->chgCData(oldp+763,((0xffU & vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_aes_writedata_data_161[2U])),8);
        bufp->chgBit(oldp+764,(vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_aes_writedata_valid_162));
        bufp->chgBit(oldp+765,((3U == vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axi_s_ctrl_aes_register_fsm)));
        bufp->chgBit(oldp+766,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_aes_bvalid));
        bufp->chgIData(oldp+767,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_aes_araddr),32);
        bufp->chgBit(oldp+768,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_aes_arvalid));
        bufp->chgBit(oldp+769,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_aes_arready));
        bufp->chgQData(oldp+770,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_aes_rdata),64);
        bufp->chgBit(oldp+772,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_aes_rvalid));
        bufp->chgBit(oldp+773,((1U & (~ (IData)(vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_aes_readdata_tmp_valid_178)))));
        bufp->chgIData(oldp+774,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_axim_awaddr),32);
        bufp->chgBit(oldp+775,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_axim_awvalid));
        bufp->chgBit(oldp+776,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_axim_awready));
        bufp->chgQData(oldp+777,((((QData)((IData)(
                                                   vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_axim_writedata_data_200[1U])) 
                                   << 0x20U) | (QData)((IData)(
                                                               vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_axim_writedata_data_200[0U])))),64);
        bufp->chgCData(oldp+779,((0xffU & vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_axim_writedata_data_200[2U])),8);
        bufp->chgBit(oldp+780,(vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_axim_writedata_valid_201));
        bufp->chgBit(oldp+781,((3U == vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT___axi_s_ctrl_axim_register_fsm)));
        bufp->chgBit(oldp+782,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_axim_bvalid));
        bufp->chgIData(oldp+783,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_axim_araddr),32);
        bufp->chgBit(oldp+784,(vlSelf->top__DOT__uut__DOT__axi_m_ctrl_axim_arvalid));
        bufp->chgBit(oldp+785,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_axim_arready));
        bufp->chgQData(oldp+786,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_axim_rdata),64);
        bufp->chgBit(oldp+788,(vlSelf->top__DOT__uut__DOT__axi_s_ctrl_axim_rvalid));
        bufp->chgBit(oldp+789,((1U & (~ (IData)(vlSelf->top__DOT__uut__DOT___sb_axi_m_ctrl_axim_readdata_tmp_valid_217)))));
        bufp->chgIData(oldp+790,(vlSelf->top__DOT__uut__DOT__axi_m_spm_data_awaddr),32);
        bufp->chgBit(oldp+791,(vlSelf->top__DOT__uut__DOT__axi_m_spm_data_awvalid));
        bufp->chgBit(oldp+792,(vlSelf->top__DOT__uut__DOT__axi_s_spm_data_awready));
        bufp->chgQData(oldp+793,((((QData)((IData)(
                                                   vlSelf->top__DOT__uut__DOT___sb_axi_m_spm_data_writedata_data_44[1U])) 
                                   << 0x20U) | (QData)((IData)(
                                                               vlSelf->top__DOT__uut__DOT___sb_axi_m_spm_data_writedata_data_44[0U])))),64);
        bufp->chgCData(oldp+795,((0xffU & vlSelf->top__DOT__uut__DOT___sb_axi_m_spm_data_writedata_data_44[2U])),8);
        bufp->chgBit(oldp+796,(vlSelf->top__DOT__uut__DOT___sb_axi_m_spm_data_writedata_valid_45));
        bufp->chgBit(oldp+797,((0xc8U == vlSelf->top__DOT__uut__DOT__uut__DOT__inst_wrapper__DOT__fsm)));
        bufp->chgBit(oldp+798,(vlSelf->top__DOT__uut__DOT__axi_s_spm_data_bvalid));
        bufp->chgIData(oldp+799,(vlSelf->top__DOT__uut__DOT__axi_m_spm_data_araddr),32);
        bufp->chgBit(oldp+800,(vlSelf->top__DOT__uut__DOT__axi_m_spm_data_arvalid));
        bufp->chgBit(oldp+801,(vlSelf->top__DOT__uut__DOT__axi_s_spm_data_arready));
        bufp->chgQData(oldp+802,(vlSelf->top__DOT__uut__DOT__axi_s_spm_data_rdata),64);
        bufp->chgBit(oldp+804,(vlSelf->top__DOT__uut__DOT__axi_s_spm_data_rvalid));
        bufp->chgBit(oldp+805,((1U & (~ (IData)(vlSelf->top__DOT__uut__DOT___sb_axi_m_spm_data_readdata_tmp_valid_61)))));
        bufp->chgQData(oldp+806,(vlSelf->top__DOT__uut__DOT__addr_reg),64);
        bufp->chgBit(oldp+808,(vlSelf->top__DOT__uut__DOT__is_write));
        bufp->chgBit(oldp+809,(vlSelf->top__DOT__uut__DOT__request_valid));
        bufp->chgQData(oldp+810,(vlSelf->top__DOT__uut__DOT__write_data),64);
        bufp->chgQData(oldp+812,(vlSelf->top__DOT__uut__DOT__read_data),64);
        bufp->chgQData(oldp+814,(vlSelf->top__DOT__uut__DOT__status_234),64);
        bufp->chgBit(oldp+816,(vlSelf->top__DOT__uut__DOT__request_complete_235));
        bufp->chgIData(oldp+817,(vlSelf->top__DOT__uut__DOT__bridge_thread),32);
        bufp->chgQData(oldp+818,(vlSelf->top__DOT__uut__DOT__axim_rdata_236),64);
        bufp->chgQData(oldp+820,(vlSelf->top__DOT__uut__DOT__axim_rdata_237),64);
        bufp->chgQData(oldp+822,(vlSelf->top__DOT__uut__DOT__axim_rdata_238),64);
        bufp->chgQData(oldp+824,(vlSelf->top__DOT__uut__DOT__axim_rdata_239),64);
        bufp->chgQData(oldp+826,(vlSelf->top__DOT__uut__DOT__axim_rdata_240),64);
        bufp->chgQData(oldp+828,(vlSelf->top__DOT__uut__DOT__axim_rdata_241),64);
        bufp->chgIData(oldp+830,(vlSelf->top__DOT__uut__DOT__fsm),32);
        bufp->chgIData(oldp+831,(vlSelf->top__DOT__uut__DOT__addr_242),32);
        bufp->chgSData(oldp+832,(vlSelf->top__DOT__uut__DOT__length_243),9);
        bufp->chgBit(oldp+833,(vlSelf->top__DOT__uut__DOT__writevalid_244));
        bufp->chgBit(oldp+834,(vlSelf->top__DOT__uut__DOT__readvalid_245));
        bufp->chgBit(oldp+835,(vlSelf->top__DOT__uut__DOT__prev_awvalid_246));
        bufp->chgBit(oldp+836,(vlSelf->top__DOT__uut__DOT__prev_arvalid_247));
        bufp->chgWData(oldp+837,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_in_mac_tdata),128);
        bufp->chgBit(oldp+841,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_in_mac_tvalid));
        bufp->chgBit(oldp+842,((5U == vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__mac_buffer_thread)));
        bufp->chgBit(oldp+843,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_in_mac_tlast));
        bufp->chgWData(oldp+844,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_in_aes_tdata),128);
        bufp->chgBit(oldp+848,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_in_aes_tvalid));
        bufp->chgBit(oldp+849,((0xbU == vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__mac_buffer_thread)));
        bufp->chgBit(oldp+850,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_in_aes_tlast));
        bufp->chgWData(oldp+851,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_out_xoreddata_tdata),128);
        bufp->chgBit(oldp+855,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_out_xoreddata_tvalid));
        bufp->chgBit(oldp+856,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_out_xoreddata_tready));
        bufp->chgBit(oldp+857,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_out_xoreddata_tlast));
        bufp->chgWData(oldp+858,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_in_xordata_tdata),128);
        bufp->chgBit(oldp+862,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_in_xordata_tvalid));
        bufp->chgBit(oldp+863,((8U == vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__mac_buffer_thread)));
        bufp->chgBit(oldp+864,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_in_xordata_tlast));
        bufp->chgWData(oldp+865,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_out_axim_tdata),128);
        bufp->chgBit(oldp+869,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_out_axim_tvalid));
        bufp->chgBit(oldp+870,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_out_axim_tready));
        bufp->chgBit(oldp+871,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_out_axim_tlast));
        bufp->chgWData(oldp+872,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_in_axim_tdata),128);
        bufp->chgBit(oldp+876,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_in_axim_tvalid));
        bufp->chgBit(oldp+877,((0x1eU == vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__spm_thread)));
        bufp->chgBit(oldp+878,(vlSelf->top__DOT__uut__DOT__uut__DOT__axis_in_axim_tlast));
        bufp->chgQData(oldp+879,(vlSelf->top__DOT__uut__DOT__uut__DOT__ram_spm_1_wdata),64);
        bufp->chgQData(oldp+881,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst_ram_spm__DOT__ram_spm_1_rdata_out),64);
        bufp->chgQData(oldp+883,(vlSelf->top__DOT__uut__DOT__uut__DOT__ram_spm_1_addr),64);
        bufp->chgBit(oldp+885,(vlSelf->top__DOT__uut__DOT__uut__DOT__ram_spm_1_wenable));
        bufp->chgBit(oldp+886,(vlSelf->top__DOT__uut__DOT__uut__DOT__ram_spm_1_enable));
        bufp->chgIData(oldp+887,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__addr_0),32);
        bufp->chgBit(oldp+888,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__writevalid_1));
        bufp->chgBit(oldp+889,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__readvalid_2));
        bufp->chgBit(oldp+890,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__prev_awvalid_3));
        bufp->chgBit(oldp+891,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__prev_arvalid_4));
        bufp->chgCData(oldp+892,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__axis_maskaddr_5),4);
        bufp->chgQData(oldp+893,(((0U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__axis_maskaddr_5))
                                   ? vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axi_s_ctrl_aes_register_0
                                   : ((1U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__axis_maskaddr_5))
                                       ? vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axi_s_ctrl_aes_register_1
                                       : ((2U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__axis_maskaddr_5))
                                           ? vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axi_s_ctrl_aes_register_2
                                           : ((3U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__axis_maskaddr_5))
                                               ? vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axi_s_ctrl_aes_register_3
                                               : ((4U 
                                                   == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__axis_maskaddr_5))
                                                   ? vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axi_s_ctrl_aes_register_4
                                                   : 
                                                  ((5U 
                                                    == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__axis_maskaddr_5))
                                                    ? vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axi_s_ctrl_aes_register_5
                                                    : 
                                                   ((6U 
                                                     == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__axis_maskaddr_5))
                                                     ? vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axi_s_ctrl_aes_register_6
                                                     : 
                                                    ((7U 
                                                      == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__axis_maskaddr_5))
                                                      ? vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axi_s_ctrl_aes_register_7
                                                      : 
                                                     ((8U 
                                                       == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__axis_maskaddr_5))
                                                       ? vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axi_s_ctrl_aes_register_8
                                                       : vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT____Vxrand_h7d28236b__0)))))))))),64);
        bufp->chgBit(oldp+895,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__axislite_flag_7));
        bufp->chgQData(oldp+896,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__axislite_resetval_8),64);
        bufp->chgCData(oldp+898,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__count___05Faxis_out_aes_write_req_fifo),4);
        bufp->chgCData(oldp+899,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axis_out_aes_write_req_fifo_rdata[3U] 
                                           >> 1U))),8);
        bufp->chgIData(oldp+900,(((vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axis_out_aes_write_req_fifo_rdata[3U] 
                                   << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axis_out_aes_write_req_fifo_rdata[2U] 
                                                >> 1U))),32);
        bufp->chgIData(oldp+901,(((vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axis_out_aes_write_req_fifo_rdata[2U] 
                                   << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axis_out_aes_write_req_fifo_rdata[1U] 
                                                >> 1U))),32);
        bufp->chgQData(oldp+902,((0x1ffffffffULL & 
                                  (((QData)((IData)(
                                                    vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axis_out_aes_write_req_fifo_rdata[1U])) 
                                    << 0x20U) | (QData)((IData)(
                                                                vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axis_out_aes_write_req_fifo_rdata[0U]))))),33);
        bufp->chgQData(oldp+904,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__data_13),64);
        bufp->chgQData(oldp+906,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__data_14),64);
        bufp->chgWData(oldp+908,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__otp_data_16),128);
        bufp->chgCData(oldp+912,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_ram_0_addr),2);
        bufp->chgWData(oldp+913,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst_aes_ram__DOT__aes_ram_0_rdata_out),128);
        bufp->chgWData(oldp+917,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_ram_0_wdata),128);
        bufp->chgBit(oldp+921,((0xfU == vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_thread)));
        bufp->chgBit(oldp+922,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_ram_0_enable));
        bufp->chgIData(oldp+923,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_thread),32);
        bufp->chgIData(oldp+924,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__read_burst_fsm_0),32);
        bufp->chgCData(oldp+925,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__read_burst_addr_24),2);
        bufp->chgCData(oldp+926,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__read_burst_stride_25),2);
        bufp->chgQData(oldp+927,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__read_burst_length_26),33);
        bufp->chgBit(oldp+929,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__read_burst_rvalid_27));
        bufp->chgBit(oldp+930,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__read_burst_rlast_28));
        bufp->chgWData(oldp+931,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__mem[0]),105);
        bufp->chgWData(oldp+935,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__mem[1]),105);
        bufp->chgWData(oldp+939,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__mem[2]),105);
        bufp->chgWData(oldp+943,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__mem[3]),105);
        bufp->chgWData(oldp+947,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__mem[4]),105);
        bufp->chgWData(oldp+951,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__mem[5]),105);
        bufp->chgWData(oldp+955,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__mem[6]),105);
        bufp->chgWData(oldp+959,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__mem[7]),105);
        bufp->chgCData(oldp+963,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+964,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+965,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axis_out_aes_write_req_fifo_empty));
        bufp->chgBit(oldp+966,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__head) 
                                == (7U & ((IData)(1U) 
                                          + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+967,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axis_out_aes_write_req_fifo_full));
        bufp->chgBit(oldp+968,(((7U & ((IData)(2U) 
                                       + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__head))) 
                                == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst___05Faxis_out_aes_write_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+969,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT___axis_out_aes_write_req_fifo_rdata),105);
        bufp->chgWData(oldp+973,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst_aes_ram__DOT__mem[0]),128);
        bufp->chgWData(oldp+977,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst_aes_ram__DOT__mem[1]),128);
        bufp->chgWData(oldp+981,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst_aes_ram__DOT__mem[2]),128);
        bufp->chgWData(oldp+985,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__inst_aes_ram__DOT__mem[3]),128);
        bufp->chgIData(oldp+989,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__addr_0),32);
        bufp->chgBit(oldp+990,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__writevalid_1));
        bufp->chgBit(oldp+991,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__readvalid_2));
        bufp->chgBit(oldp+992,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__prev_awvalid_3));
        bufp->chgBit(oldp+993,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__prev_arvalid_4));
        bufp->chgCData(oldp+994,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__axis_maskaddr_5),3);
        bufp->chgQData(oldp+995,(((0U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__axis_maskaddr_5))
                                   ? vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT___axi_s_ctrl_axim_register_0
                                   : ((1U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__axis_maskaddr_5))
                                       ? vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT___axi_s_ctrl_axim_register_1
                                       : ((2U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__axis_maskaddr_5))
                                           ? vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT___axi_s_ctrl_axim_register_2
                                           : ((3U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__axis_maskaddr_5))
                                               ? vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT___axi_s_ctrl_axim_register_3
                                               : ((4U 
                                                   == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__axis_maskaddr_5))
                                                   ? vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT___axi_s_ctrl_axim_register_4
                                                   : 
                                                  ((5U 
                                                    == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__axis_maskaddr_5))
                                                    ? vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT___axi_s_ctrl_axim_register_5
                                                    : vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT____Vxrand_h7d28236b__0))))))),64);
        bufp->chgBit(oldp+997,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__axislite_flag_7));
        bufp->chgQData(oldp+998,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__axislite_resetval_8),64);
        bufp->chgCData(oldp+1000,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__count___05Faxis_in_axim_read_req_fifo),4);
        bufp->chgCData(oldp+1001,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__mem
                                            [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__tail][3U] 
                                            >> 1U))),8);
        bufp->chgIData(oldp+1002,(((vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__mem
                                    [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__tail][3U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__mem
                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__tail][2U] 
                                                 >> 1U))),32);
        bufp->chgIData(oldp+1003,(((vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__mem
                                    [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__tail][2U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__mem
                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__tail][1U] 
                                                 >> 1U))),32);
        bufp->chgQData(oldp+1004,((0x1ffffffffULL & 
                                   (((QData)((IData)(
                                                     vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__mem
                                                     [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__tail][1U])) 
                                     << 0x20U) | (QData)((IData)(
                                                                 vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__mem
                                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__tail][0U]))))),33);
        bufp->chgCData(oldp+1006,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__count___05Faxis_out_axim_write_req_fifo),4);
        bufp->chgCData(oldp+1007,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__mem
                                            [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__tail][3U] 
                                            >> 1U))),8);
        bufp->chgIData(oldp+1008,(((vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__mem
                                    [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__tail][3U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__mem
                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__tail][2U] 
                                                 >> 1U))),32);
        bufp->chgIData(oldp+1009,(((vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__mem
                                    [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__tail][2U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__mem
                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__tail][1U] 
                                                 >> 1U))),32);
        bufp->chgQData(oldp+1010,((0x1ffffffffULL & 
                                   (((QData)((IData)(
                                                     vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__mem
                                                     [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__tail][1U])) 
                                     << 0x20U) | (QData)((IData)(
                                                                 vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__mem
                                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__tail][0U]))))),33);
        bufp->chgQData(oldp+1012,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__req_addr),64);
        bufp->chgQData(oldp+1014,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__req_id),64);
        bufp->chgQData(oldp+1016,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__req_accept),64);
        bufp->chgQData(oldp+1018,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__is_write),64);
        bufp->chgQData(oldp+1020,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__req_complete),64);
        bufp->chgWData(oldp+1022,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__write_data[0]),128);
        bufp->chgWData(oldp+1026,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__write_data[1]),128);
        bufp->chgWData(oldp+1030,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__write_data[2]),128);
        bufp->chgWData(oldp+1034,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__write_data[3]),128);
        bufp->chgWData(oldp+1038,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__read_data[0]),128);
        bufp->chgWData(oldp+1042,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__read_data[1]),128);
        bufp->chgWData(oldp+1046,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__read_data[2]),128);
        bufp->chgWData(oldp+1050,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__read_data[3]),128);
        bufp->chgQData(oldp+1054,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__counter),64);
        bufp->chgQData(oldp+1056,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__status_17),64);
        bufp->chgQData(oldp+1058,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__th_status_18),64);
        bufp->chgIData(oldp+1060,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__spm_thread),32);
        bufp->chgWData(oldp+1061,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__axistreamin_tdata_20),128);
        bufp->chgBit(oldp+1065,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__axistreamin_tlast_21));
        bufp->chgIData(oldp+1066,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__fsm),32);
        bufp->chgIData(oldp+1067,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__addr_22),32);
        bufp->chgSData(oldp+1068,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__length_23),9);
        bufp->chgBit(oldp+1069,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__writevalid_24));
        bufp->chgBit(oldp+1070,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__readvalid_25));
        bufp->chgBit(oldp+1071,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__prev_awvalid_26));
        bufp->chgBit(oldp+1072,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__prev_arvalid_27));
        bufp->chgCData(oldp+1073,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+1074,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+1075,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT___axis_in_axim_read_req_fifo_empty));
        bufp->chgBit(oldp+1076,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__head) 
                                 == (7U & ((IData)(1U) 
                                           + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+1077,(((7U & ((IData)(1U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__tail))));
        bufp->chgBit(oldp+1078,(((7U & ((IData)(2U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+1079,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__mem
                                  [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_in_axim_read_req_fifo__DOT__tail]),105);
        bufp->chgCData(oldp+1083,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+1084,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+1085,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT___axis_out_axim_write_req_fifo_empty));
        bufp->chgBit(oldp+1086,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__head) 
                                 == (7U & ((IData)(1U) 
                                           + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+1087,(((7U & ((IData)(1U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__tail))));
        bufp->chgBit(oldp+1088,(((7U & ((IData)(2U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+1089,(vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__mem
                                  [vlSelf->top__DOT__uut__DOT__uut__DOT__axim_inst__DOT__inst___05Faxis_out_axim_write_req_fifo__DOT__tail]),105);
        bufp->chgQData(oldp+1093,(vlSelf->top__DOT__uut__DOT__uut__DOT__inst_wrapper__DOT__rdata_reg),64);
        bufp->chgIData(oldp+1095,(vlSelf->top__DOT__uut__DOT__uut__DOT__inst_wrapper__DOT__fsm),32);
        bufp->chgIData(oldp+1096,(vlSelf->top__DOT__uut__DOT__uut__DOT__inst_wrapper__DOT__addr_0),32);
        bufp->chgBit(oldp+1097,(vlSelf->top__DOT__uut__DOT__uut__DOT__inst_wrapper__DOT__writevalid_1));
        bufp->chgBit(oldp+1098,(vlSelf->top__DOT__uut__DOT__uut__DOT__inst_wrapper__DOT__readvalid_2));
        bufp->chgBit(oldp+1099,(vlSelf->top__DOT__uut__DOT__uut__DOT__inst_wrapper__DOT__prev_awvalid_3));
        bufp->chgBit(oldp+1100,(vlSelf->top__DOT__uut__DOT__uut__DOT__inst_wrapper__DOT__prev_arvalid_4));
        bufp->chgIData(oldp+1101,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__addr_0),32);
        bufp->chgBit(oldp+1102,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__writevalid_1));
        bufp->chgBit(oldp+1103,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__readvalid_2));
        bufp->chgBit(oldp+1104,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__prev_awvalid_3));
        bufp->chgBit(oldp+1105,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__prev_arvalid_4));
        bufp->chgCData(oldp+1106,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__axis_maskaddr_5),3);
        bufp->chgQData(oldp+1107,(((0U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__axis_maskaddr_5))
                                    ? vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT___axi_s_ctrl_mac_register_0
                                    : ((1U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__axis_maskaddr_5))
                                        ? vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT___axi_s_ctrl_mac_register_1
                                        : ((2U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__axis_maskaddr_5))
                                            ? vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT___axi_s_ctrl_mac_register_2
                                            : ((3U 
                                                == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__axis_maskaddr_5))
                                                ? vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT___axi_s_ctrl_mac_register_3
                                                : (
                                                   (4U 
                                                    == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__axis_maskaddr_5))
                                                    ? vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT___axi_s_ctrl_mac_register_4
                                                    : 
                                                   ((5U 
                                                     == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__axis_maskaddr_5))
                                                     ? vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT___axi_s_ctrl_mac_register_5
                                                     : 
                                                    ((6U 
                                                      == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__axis_maskaddr_5))
                                                      ? vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT___axi_s_ctrl_mac_register_6
                                                      : vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT____Vxrand_h7d28236b__0)))))))),64);
        bufp->chgBit(oldp+1109,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__axislite_flag_7));
        bufp->chgQData(oldp+1110,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__axislite_resetval_8),64);
        bufp->chgCData(oldp+1112,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__count___05Faxis_in_mac_read_req_fifo),4);
        bufp->chgCData(oldp+1113,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__mem
                                            [vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__tail][3U] 
                                            >> 1U))),8);
        bufp->chgIData(oldp+1114,(((vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__mem
                                    [vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__tail][3U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__mem
                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__tail][2U] 
                                                 >> 1U))),32);
        bufp->chgIData(oldp+1115,(((vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__mem
                                    [vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__tail][2U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__mem
                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__tail][1U] 
                                                 >> 1U))),32);
        bufp->chgQData(oldp+1116,((0x1ffffffffULL & 
                                   (((QData)((IData)(
                                                     vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__mem
                                                     [vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__tail][1U])) 
                                     << 0x20U) | (QData)((IData)(
                                                                 vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__mem
                                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__tail][0U]))))),33);
        bufp->chgWData(oldp+1118,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__buffer_13),512);
        bufp->chgQData(oldp+1134,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__mac_result_14),64);
        bufp->chgWData(oldp+1136,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__data_15),128);
        bufp->chgQData(oldp+1140,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__start_bit_16),64);
        bufp->chgQData(oldp+1142,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__end_bit_17),64);
        bufp->chgWData(oldp+1144,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__mask_18),512);
        bufp->chgIData(oldp+1160,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__mac_buffer_thread),32);
        bufp->chgWData(oldp+1161,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__axistreamin_tdata_19),128);
        bufp->chgBit(oldp+1165,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__axistreamin_tlast_20));
        bufp->chgIData(oldp+1166,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__spm_thread),32);
        bufp->chgCData(oldp+1167,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+1168,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+1169,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT___axis_in_mac_read_req_fifo_empty));
        bufp->chgBit(oldp+1170,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__head) 
                                 == (7U & ((IData)(1U) 
                                           + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+1171,(((7U & ((IData)(1U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__tail))));
        bufp->chgBit(oldp+1172,(((7U & ((IData)(2U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+1173,(vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__mem
                                  [vlSelf->top__DOT__uut__DOT__uut__DOT__mac_inst__DOT__inst___05Faxis_in_mac_read_req_fifo__DOT__tail]),105);
        bufp->chgSData(oldp+1177,((0x1ffU & (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__ram_spm_1_addr))),9);
        bufp->chgIData(oldp+1178,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__addr_0),32);
        bufp->chgBit(oldp+1179,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__writevalid_1));
        bufp->chgBit(oldp+1180,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__readvalid_2));
        bufp->chgBit(oldp+1181,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__prev_awvalid_3));
        bufp->chgBit(oldp+1182,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__prev_arvalid_4));
        bufp->chgCData(oldp+1183,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__axis_maskaddr_5),3);
        bufp->chgQData(oldp+1184,(((0U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__axis_maskaddr_5))
                                    ? vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_s_ctrl_spm_register_0
                                    : ((1U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__axis_maskaddr_5))
                                        ? vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_s_ctrl_spm_register_1
                                        : ((2U == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__axis_maskaddr_5))
                                            ? vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_s_ctrl_spm_register_2
                                            : ((3U 
                                                == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__axis_maskaddr_5))
                                                ? vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_s_ctrl_spm_register_3
                                                : (
                                                   (4U 
                                                    == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__axis_maskaddr_5))
                                                    ? vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_s_ctrl_spm_register_4
                                                    : 
                                                   ((5U 
                                                     == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__axis_maskaddr_5))
                                                     ? vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_s_ctrl_spm_register_5
                                                     : 
                                                    ((6U 
                                                      == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__axis_maskaddr_5))
                                                      ? vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_s_ctrl_spm_register_6
                                                      : vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT____Vxrand_h7d28236b__0)))))))),64);
        bufp->chgBit(oldp+1186,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__axislite_flag_7));
        bufp->chgQData(oldp+1187,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__axislite_resetval_8),64);
        bufp->chgCData(oldp+1189,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__count___05Faxi_m_dram_read_req_fifo),4);
        bufp->chgCData(oldp+1190,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_req_fifo_rdata[4U] 
                                            >> 1U))),8);
        bufp->chgIData(oldp+1191,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_req_fifo_rdata[4U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_req_fifo_rdata[3U] 
                                                 >> 1U))),32);
        bufp->chgIData(oldp+1192,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_req_fifo_rdata[3U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_req_fifo_rdata[2U] 
                                                 >> 1U))),32);
        bufp->chgQData(oldp+1193,((0x1ffffffffULL & 
                                   (((QData)((IData)(
                                                     vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_req_fifo_rdata[2U])) 
                                     << 0x20U) | (QData)((IData)(
                                                                 vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_req_fifo_rdata[1U]))))),33);
        bufp->chgIData(oldp+1195,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_req_fifo_rdata[0U]),32);
        bufp->chgCData(oldp+1196,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__count___05Faxi_m_dram_write_req_fifo),4);
        bufp->chgCData(oldp+1197,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_req_fifo_rdata[4U] 
                                            >> 1U))),8);
        bufp->chgIData(oldp+1198,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_req_fifo_rdata[4U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_req_fifo_rdata[3U] 
                                                 >> 1U))),32);
        bufp->chgIData(oldp+1199,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_req_fifo_rdata[3U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_req_fifo_rdata[2U] 
                                                 >> 1U))),32);
        bufp->chgQData(oldp+1200,((0x1ffffffffULL & 
                                   (((QData)((IData)(
                                                     vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_req_fifo_rdata[2U])) 
                                     << 0x20U) | (QData)((IData)(
                                                                 vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_req_fifo_rdata[1U]))))),33);
        bufp->chgIData(oldp+1202,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_req_fifo_rdata[0U]),32);
        bufp->chgCData(oldp+1203,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__count___05Faxis_out_mac_spm_write_req_fifo),4);
        bufp->chgCData(oldp+1204,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_mac_spm_write_req_fifo_rdata[3U] 
                                            >> 1U))),8);
        bufp->chgIData(oldp+1205,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_mac_spm_write_req_fifo_rdata[3U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_mac_spm_write_req_fifo_rdata[2U] 
                                                 >> 1U))),32);
        bufp->chgIData(oldp+1206,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_mac_spm_write_req_fifo_rdata[2U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_mac_spm_write_req_fifo_rdata[1U] 
                                                 >> 1U))),32);
        bufp->chgQData(oldp+1207,((0x1ffffffffULL & 
                                   (((QData)((IData)(
                                                     vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_mac_spm_write_req_fifo_rdata[1U])) 
                                     << 0x20U) | (QData)((IData)(
                                                                 vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_mac_spm_write_req_fifo_rdata[0U]))))),33);
        bufp->chgCData(oldp+1209,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__count___05Faxis_out_axim_spm_write_req_fifo),4);
        bufp->chgCData(oldp+1210,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_axim_spm_write_req_fifo_rdata[3U] 
                                            >> 1U))),8);
        bufp->chgIData(oldp+1211,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_axim_spm_write_req_fifo_rdata[3U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_axim_spm_write_req_fifo_rdata[2U] 
                                                 >> 1U))),32);
        bufp->chgIData(oldp+1212,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_axim_spm_write_req_fifo_rdata[2U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_axim_spm_write_req_fifo_rdata[1U] 
                                                 >> 1U))),32);
        bufp->chgQData(oldp+1213,((0x1ffffffffULL & 
                                   (((QData)((IData)(
                                                     vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_axim_spm_write_req_fifo_rdata[1U])) 
                                     << 0x20U) | (QData)((IData)(
                                                                 vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_axim_spm_write_req_fifo_rdata[0U]))))),33);
        bufp->chgCData(oldp+1215,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__count___05Faxis_in_axim_spm_read_req_fifo),4);
        bufp->chgCData(oldp+1216,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_axim_spm_read_req_fifo_rdata[3U] 
                                            >> 1U))),8);
        bufp->chgIData(oldp+1217,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_axim_spm_read_req_fifo_rdata[3U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_axim_spm_read_req_fifo_rdata[2U] 
                                                 >> 1U))),32);
        bufp->chgIData(oldp+1218,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_axim_spm_read_req_fifo_rdata[2U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_axim_spm_read_req_fifo_rdata[1U] 
                                                 >> 1U))),32);
        bufp->chgQData(oldp+1219,((0x1ffffffffULL & 
                                   (((QData)((IData)(
                                                     vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_axim_spm_read_req_fifo_rdata[1U])) 
                                     << 0x20U) | (QData)((IData)(
                                                                 vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_axim_spm_read_req_fifo_rdata[0U]))))),33);
        bufp->chgCData(oldp+1221,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__count___05Faxis_out_xored_spm_write_req_fifo),4);
        bufp->chgCData(oldp+1222,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_xored_spm_write_req_fifo_rdata[3U] 
                                            >> 1U))),8);
        bufp->chgIData(oldp+1223,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_xored_spm_write_req_fifo_rdata[3U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_xored_spm_write_req_fifo_rdata[2U] 
                                                 >> 1U))),32);
        bufp->chgIData(oldp+1224,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_xored_spm_write_req_fifo_rdata[2U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_xored_spm_write_req_fifo_rdata[1U] 
                                                 >> 1U))),32);
        bufp->chgQData(oldp+1225,((0x1ffffffffULL & 
                                   (((QData)((IData)(
                                                     vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_xored_spm_write_req_fifo_rdata[1U])) 
                                     << 0x20U) | (QData)((IData)(
                                                                 vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_xored_spm_write_req_fifo_rdata[0U]))))),33);
        bufp->chgCData(oldp+1227,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__count___05Faxis_in_xored_spm_read_req_fifo),4);
        bufp->chgCData(oldp+1228,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_xored_spm_read_req_fifo_rdata[3U] 
                                            >> 1U))),8);
        bufp->chgIData(oldp+1229,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_xored_spm_read_req_fifo_rdata[3U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_xored_spm_read_req_fifo_rdata[2U] 
                                                 >> 1U))),32);
        bufp->chgIData(oldp+1230,(((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_xored_spm_read_req_fifo_rdata[2U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_xored_spm_read_req_fifo_rdata[1U] 
                                                 >> 1U))),32);
        bufp->chgQData(oldp+1231,((0x1ffffffffULL & 
                                   (((QData)((IData)(
                                                     vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_xored_spm_read_req_fifo_rdata[1U])) 
                                     << 0x20U) | (QData)((IData)(
                                                                 vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_xored_spm_read_req_fifo_rdata[0U]))))),33);
        bufp->chgSData(oldp+1233,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__ram_spm_0_addr),9);
        bufp->chgQData(oldp+1234,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst_ram_spm__DOT__ram_spm_0_rdata_out),64);
        bufp->chgQData(oldp+1236,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__ram_spm_0_wdata),64);
        bufp->chgBit(oldp+1238,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__ram_spm_0_wenable));
        bufp->chgBit(oldp+1239,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__ram_spm_0_enable));
        bufp->chgQData(oldp+1240,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__dram_addr_69),64);
        bufp->chgQData(oldp+1242,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__spm_addr_70),64);
        bufp->chgQData(oldp+1244,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__direction_71),64);
        bufp->chgQData(oldp+1246,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__destination_72),64);
        bufp->chgQData(oldp+1248,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__size_73),64);
        bufp->chgQData(oldp+1250,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__tmp_data_2_76),64);
        bufp->chgIData(oldp+1252,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__spm_thread),32);
        bufp->chgIData(oldp+1253,((IData)((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__dram_addr_69 
                                           >> 4U))),32);
        bufp->chgIData(oldp+1254,(VL_SHIFTL_III(32,32,32, (IData)(
                                                                  (vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__dram_addr_69 
                                                                   >> 4U)), 4U)),32);
        bufp->chgCData(oldp+1255,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_op_sel),8);
        bufp->chgIData(oldp+1256,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_addr),32);
        bufp->chgIData(oldp+1257,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_stride),32);
        bufp->chgQData(oldp+1258,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_size),33);
        bufp->chgIData(oldp+1260,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_blocksize),32);
        __Vtemp_15[0U] = vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_blocksize;
        __Vtemp_15[1U] = (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_size);
        __Vtemp_15[2U] = (((IData)((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_addr)) 
                                     << 0x20U) | (QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_stride)))) 
                           << 1U) | (IData)((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_size 
                                             >> 0x20U)));
        __Vtemp_15[3U] = (((IData)((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_addr)) 
                                     << 0x20U) | (QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_stride)))) 
                           >> 0x1fU) | ((IData)(((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_addr)) 
                                                   << 0x20U) 
                                                  | (QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_stride))) 
                                                 >> 0x20U)) 
                                        << 1U));
        __Vtemp_15[4U] = (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_op_sel) 
                           << 1U) | ((IData)(((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_addr)) 
                                                << 0x20U) 
                                               | (QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_local_stride))) 
                                              >> 0x20U)) 
                                     >> 0x1fU));
        bufp->chgWData(oldp+1261,(__Vtemp_15),137);
        bufp->chgIData(oldp+1266,(VL_SHIFTR_III(32,32,32, vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_global_addr, 4U)),32);
        bufp->chgIData(oldp+1267,((0xfffffff0U & vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_global_addr)),32);
        bufp->chgIData(oldp+1268,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_fsm_0),32);
        bufp->chgSData(oldp+1269,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_addr_102),9);
        bufp->chgSData(oldp+1270,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_stride_103),9);
        bufp->chgQData(oldp+1271,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_length_104),33);
        bufp->chgBit(oldp+1273,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_done_105));
        bufp->chgCData(oldp+1274,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_op_sel),8);
        bufp->chgIData(oldp+1275,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_addr),32);
        bufp->chgIData(oldp+1276,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_stride),32);
        bufp->chgQData(oldp+1277,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_size),33);
        bufp->chgIData(oldp+1279,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_blocksize),32);
        __Vtemp_18[0U] = vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_blocksize;
        __Vtemp_18[1U] = (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_size);
        __Vtemp_18[2U] = (((IData)((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_addr)) 
                                     << 0x20U) | (QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_stride)))) 
                           << 1U) | (IData)((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_size 
                                             >> 0x20U)));
        __Vtemp_18[3U] = (((IData)((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_addr)) 
                                     << 0x20U) | (QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_stride)))) 
                           >> 0x1fU) | ((IData)(((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_addr)) 
                                                   << 0x20U) 
                                                  | (QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_stride))) 
                                                 >> 0x20U)) 
                                        << 1U));
        __Vtemp_18[4U] = (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_op_sel) 
                           << 1U) | ((IData)(((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_addr)) 
                                                << 0x20U) 
                                               | (QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_stride))) 
                                              >> 0x20U)) 
                                     >> 0x1fU));
        bufp->chgWData(oldp+1280,(__Vtemp_18),137);
        bufp->chgIData(oldp+1285,(VL_SHIFTR_III(32,32,32, vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_global_addr, 4U)),32);
        bufp->chgIData(oldp+1286,((0xfffffff0U & vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_global_addr)),32);
        bufp->chgQData(oldp+1287,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_cur_global_size),33);
        __Vtemp_21[0U] = vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_blocksize;
        __Vtemp_21[1U] = (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_cur_global_size);
        __Vtemp_21[2U] = (((IData)((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_addr)) 
                                     << 0x20U) | (QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_stride)))) 
                           << 1U) | (IData)((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_cur_global_size 
                                             >> 0x20U)));
        __Vtemp_21[3U] = (((IData)((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_addr)) 
                                     << 0x20U) | (QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_stride)))) 
                           >> 0x1fU) | ((IData)(((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_addr)) 
                                                   << 0x20U) 
                                                  | (QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_stride))) 
                                                 >> 0x20U)) 
                                        << 1U));
        __Vtemp_21[4U] = (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_op_sel) 
                           << 1U) | ((IData)(((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_addr)) 
                                                << 0x20U) 
                                               | (QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_local_stride))) 
                                              >> 0x20U)) 
                                     >> 0x1fU));
        bufp->chgWData(oldp+1289,(__Vtemp_21),137);
        bufp->chgIData(oldp+1294,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_fsm_1),32);
        bufp->chgSData(oldp+1295,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_addr_137),9);
        bufp->chgSData(oldp+1296,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_stride_138),9);
        bufp->chgQData(oldp+1297,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_length_139),33);
        bufp->chgBit(oldp+1299,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_rvalid_140));
        bufp->chgBit(oldp+1300,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_rlast_141));
        bufp->chgIData(oldp+1301,((IData)((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__spm_addr_70 
                                           >> 3U))),32);
        __Vtemp_24[0U] = 8U;
        __Vtemp_24[1U] = 2U;
        __Vtemp_24[2U] = ((IData)((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__spm_addr_70 
                                   >> 3U)) << 1U);
        __Vtemp_24[3U] = (2U | ((IData)((vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__spm_addr_70 
                                         >> 3U)) >> 0x1fU));
        bufp->chgWData(oldp+1302,(__Vtemp_24),105);
        bufp->chgIData(oldp+1306,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_fsm_2),32);
        bufp->chgSData(oldp+1307,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_addr_154),9);
        bufp->chgSData(oldp+1308,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_stride_155),9);
        bufp->chgQData(oldp+1309,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_length_156),33);
        bufp->chgBit(oldp+1311,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_rvalid_157));
        bufp->chgBit(oldp+1312,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_rlast_158));
        bufp->chgQData(oldp+1313,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_rdata_165),64);
        bufp->chgIData(oldp+1315,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_fsm_3),32);
        bufp->chgSData(oldp+1316,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_addr_176),9);
        bufp->chgSData(oldp+1317,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_stride_177),9);
        bufp->chgQData(oldp+1318,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_length_178),33);
        bufp->chgBit(oldp+1320,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_done_179));
        bufp->chgIData(oldp+1321,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_fsm_4),32);
        bufp->chgSData(oldp+1322,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_addr_188),9);
        bufp->chgSData(oldp+1323,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_stride_189),9);
        bufp->chgQData(oldp+1324,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_length_190),33);
        bufp->chgBit(oldp+1326,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_rvalid_191));
        bufp->chgBit(oldp+1327,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_rlast_192));
        bufp->chgIData(oldp+1328,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_fsm_5),32);
        bufp->chgSData(oldp+1329,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_addr_207),9);
        bufp->chgSData(oldp+1330,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_stride_208),9);
        bufp->chgQData(oldp+1331,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_length_209),33);
        bufp->chgBit(oldp+1333,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__write_burst_done_210));
        bufp->chgIData(oldp+1334,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_fsm_6),32);
        bufp->chgSData(oldp+1335,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_addr_219),9);
        bufp->chgSData(oldp+1336,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_stride_220),9);
        bufp->chgQData(oldp+1337,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_length_221),33);
        bufp->chgBit(oldp+1339,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_rvalid_222));
        bufp->chgBit(oldp+1340,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__read_burst_rlast_223));
        bufp->chgWData(oldp+1341,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__mem[0]),137);
        bufp->chgWData(oldp+1346,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__mem[1]),137);
        bufp->chgWData(oldp+1351,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__mem[2]),137);
        bufp->chgWData(oldp+1356,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__mem[3]),137);
        bufp->chgWData(oldp+1361,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__mem[4]),137);
        bufp->chgWData(oldp+1366,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__mem[5]),137);
        bufp->chgWData(oldp+1371,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__mem[6]),137);
        bufp->chgWData(oldp+1376,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__mem[7]),137);
        bufp->chgCData(oldp+1381,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+1382,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+1383,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_req_fifo_empty));
        bufp->chgBit(oldp+1384,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__head) 
                                 == (7U & ((IData)(1U) 
                                           + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+1385,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_req_fifo_full));
        bufp->chgBit(oldp+1386,(((7U & ((IData)(2U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_read_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+1387,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_read_req_fifo_rdata),137);
        bufp->chgWData(oldp+1392,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__mem[0]),137);
        bufp->chgWData(oldp+1397,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__mem[1]),137);
        bufp->chgWData(oldp+1402,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__mem[2]),137);
        bufp->chgWData(oldp+1407,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__mem[3]),137);
        bufp->chgWData(oldp+1412,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__mem[4]),137);
        bufp->chgWData(oldp+1417,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__mem[5]),137);
        bufp->chgWData(oldp+1422,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__mem[6]),137);
        bufp->chgWData(oldp+1427,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__mem[7]),137);
        bufp->chgCData(oldp+1432,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+1433,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+1434,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_req_fifo_empty));
        bufp->chgBit(oldp+1435,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__head) 
                                 == (7U & ((IData)(1U) 
                                           + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+1436,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_req_fifo_full));
        bufp->chgBit(oldp+1437,(((7U & ((IData)(2U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxi_m_dram_write_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+1438,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axi_m_dram_write_req_fifo_rdata),137);
        bufp->chgWData(oldp+1443,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__mem[0]),105);
        bufp->chgWData(oldp+1447,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__mem[1]),105);
        bufp->chgWData(oldp+1451,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__mem[2]),105);
        bufp->chgWData(oldp+1455,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__mem[3]),105);
        bufp->chgWData(oldp+1459,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__mem[4]),105);
        bufp->chgWData(oldp+1463,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__mem[5]),105);
        bufp->chgWData(oldp+1467,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__mem[6]),105);
        bufp->chgWData(oldp+1471,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__mem[7]),105);
        bufp->chgCData(oldp+1475,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+1476,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+1477,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_axim_spm_read_req_fifo_empty));
        bufp->chgBit(oldp+1478,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__head) 
                                 == (7U & ((IData)(1U) 
                                           + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+1479,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_axim_spm_read_req_fifo_full));
        bufp->chgBit(oldp+1480,(((7U & ((IData)(2U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_axim_spm_read_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+1481,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_axim_spm_read_req_fifo_rdata),105);
        bufp->chgWData(oldp+1485,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__mem[0]),105);
        bufp->chgWData(oldp+1489,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__mem[1]),105);
        bufp->chgWData(oldp+1493,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__mem[2]),105);
        bufp->chgWData(oldp+1497,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__mem[3]),105);
        bufp->chgWData(oldp+1501,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__mem[4]),105);
        bufp->chgWData(oldp+1505,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__mem[5]),105);
        bufp->chgWData(oldp+1509,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__mem[6]),105);
        bufp->chgWData(oldp+1513,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__mem[7]),105);
        bufp->chgCData(oldp+1517,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+1518,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+1519,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_xored_spm_read_req_fifo_empty));
        bufp->chgBit(oldp+1520,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__head) 
                                 == (7U & ((IData)(1U) 
                                           + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+1521,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_xored_spm_read_req_fifo_full));
        bufp->chgBit(oldp+1522,(((7U & ((IData)(2U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_in_xored_spm_read_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+1523,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_in_xored_spm_read_req_fifo_rdata),105);
        bufp->chgWData(oldp+1527,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__mem[0]),105);
        bufp->chgWData(oldp+1531,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__mem[1]),105);
        bufp->chgWData(oldp+1535,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__mem[2]),105);
        bufp->chgWData(oldp+1539,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__mem[3]),105);
        bufp->chgWData(oldp+1543,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__mem[4]),105);
        bufp->chgWData(oldp+1547,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__mem[5]),105);
        bufp->chgWData(oldp+1551,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__mem[6]),105);
        bufp->chgWData(oldp+1555,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__mem[7]),105);
        bufp->chgCData(oldp+1559,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+1560,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+1561,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_axim_spm_write_req_fifo_empty));
        bufp->chgBit(oldp+1562,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__head) 
                                 == (7U & ((IData)(1U) 
                                           + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+1563,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_axim_spm_write_req_fifo_full));
        bufp->chgBit(oldp+1564,(((7U & ((IData)(2U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_axim_spm_write_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+1565,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_axim_spm_write_req_fifo_rdata),105);
        bufp->chgWData(oldp+1569,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__mem[0]),105);
        bufp->chgWData(oldp+1573,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__mem[1]),105);
        bufp->chgWData(oldp+1577,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__mem[2]),105);
        bufp->chgWData(oldp+1581,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__mem[3]),105);
        bufp->chgWData(oldp+1585,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__mem[4]),105);
        bufp->chgWData(oldp+1589,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__mem[5]),105);
        bufp->chgWData(oldp+1593,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__mem[6]),105);
        bufp->chgWData(oldp+1597,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__mem[7]),105);
        bufp->chgCData(oldp+1601,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+1602,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+1603,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_mac_spm_write_req_fifo_empty));
        bufp->chgBit(oldp+1604,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__head) 
                                 == (7U & ((IData)(1U) 
                                           + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+1605,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_mac_spm_write_req_fifo_full));
        bufp->chgBit(oldp+1606,(((7U & ((IData)(2U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_mac_spm_write_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+1607,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_mac_spm_write_req_fifo_rdata),105);
        bufp->chgWData(oldp+1611,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__mem[0]),105);
        bufp->chgWData(oldp+1615,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__mem[1]),105);
        bufp->chgWData(oldp+1619,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__mem[2]),105);
        bufp->chgWData(oldp+1623,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__mem[3]),105);
        bufp->chgWData(oldp+1627,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__mem[4]),105);
        bufp->chgWData(oldp+1631,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__mem[5]),105);
        bufp->chgWData(oldp+1635,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__mem[6]),105);
        bufp->chgWData(oldp+1639,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__mem[7]),105);
        bufp->chgCData(oldp+1643,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+1644,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+1645,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_xored_spm_write_req_fifo_empty));
        bufp->chgBit(oldp+1646,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__head) 
                                 == (7U & ((IData)(1U) 
                                           + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+1647,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_xored_spm_write_req_fifo_full));
        bufp->chgBit(oldp+1648,(((7U & ((IData)(2U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT__inst___05Faxis_out_xored_spm_write_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+1649,(vlSelf->top__DOT__uut__DOT__uut__DOT__spm_inst__DOT___axis_out_xored_spm_write_req_fifo_rdata),105);
        bufp->chgIData(oldp+1653,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__addr_0),32);
        bufp->chgBit(oldp+1654,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__writevalid_1));
        bufp->chgBit(oldp+1655,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__readvalid_2));
        bufp->chgBit(oldp+1656,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__prev_awvalid_3));
        bufp->chgBit(oldp+1657,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__prev_arvalid_4));
        bufp->chgBit(oldp+1658,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__axis_maskaddr_5));
        bufp->chgQData(oldp+1659,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__axis_maskaddr_5)
                                    ? ((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__axis_maskaddr_5)
                                        ? vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axi_s_ctrl_xored_register_1
                                        : vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT____Vxrand_h7d28236b__0)
                                    : vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axi_s_ctrl_xored_register_0)),64);
        bufp->chgBit(oldp+1661,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__axislite_flag_7));
        bufp->chgQData(oldp+1662,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__axislite_resetval_8),64);
        bufp->chgCData(oldp+1664,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__count___05Faxis_in_xordata_read_req_fifo),4);
        bufp->chgCData(oldp+1665,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__mem
                                            [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__tail][3U] 
                                            >> 1U))),8);
        bufp->chgIData(oldp+1666,(((vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__mem
                                    [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__tail][3U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__mem
                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__tail][2U] 
                                                 >> 1U))),32);
        bufp->chgIData(oldp+1667,(((vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__mem
                                    [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__tail][2U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__mem
                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__tail][1U] 
                                                 >> 1U))),32);
        bufp->chgQData(oldp+1668,((0x1ffffffffULL & 
                                   (((QData)((IData)(
                                                     vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__mem
                                                     [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__tail][1U])) 
                                     << 0x20U) | (QData)((IData)(
                                                                 vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__mem
                                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__tail][0U]))))),33);
        bufp->chgCData(oldp+1670,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__count___05Faxis_out_xoreddata_write_req_fifo),4);
        bufp->chgCData(oldp+1671,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axis_out_xoreddata_write_req_fifo_rdata[3U] 
                                            >> 1U))),8);
        bufp->chgIData(oldp+1672,(((vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axis_out_xoreddata_write_req_fifo_rdata[3U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axis_out_xoreddata_write_req_fifo_rdata[2U] 
                                                 >> 1U))),32);
        bufp->chgIData(oldp+1673,(((vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axis_out_xoreddata_write_req_fifo_rdata[2U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axis_out_xoreddata_write_req_fifo_rdata[1U] 
                                                 >> 1U))),32);
        bufp->chgQData(oldp+1674,((0x1ffffffffULL & 
                                   (((QData)((IData)(
                                                     vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axis_out_xoreddata_write_req_fifo_rdata[1U])) 
                                     << 0x20U) | (QData)((IData)(
                                                                 vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axis_out_xoreddata_write_req_fifo_rdata[0U]))))),33);
        bufp->chgCData(oldp+1676,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__count___05Faxis_in_aes_read_req_fifo),4);
        bufp->chgCData(oldp+1677,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__mem
                                            [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__tail][3U] 
                                            >> 1U))),8);
        bufp->chgIData(oldp+1678,(((vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__mem
                                    [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__tail][3U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__mem
                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__tail][2U] 
                                                 >> 1U))),32);
        bufp->chgIData(oldp+1679,(((vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__mem
                                    [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__tail][2U] 
                                    << 0x1fU) | (vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__mem
                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__tail][1U] 
                                                 >> 1U))),32);
        bufp->chgQData(oldp+1680,((0x1ffffffffULL & 
                                   (((QData)((IData)(
                                                     vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__mem
                                                     [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__tail][1U])) 
                                     << 0x20U) | (QData)((IData)(
                                                                 vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__mem
                                                                 [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__tail][0U]))))),33);
        bufp->chgWData(oldp+1682,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__data_21),128);
        bufp->chgWData(oldp+1686,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__otp_22),128);
        bufp->chgWData(oldp+1690,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__xored_23),128);
        bufp->chgCData(oldp+1694,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__xor_ram_0_addr),2);
        bufp->chgWData(oldp+1695,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst_xor_ram__DOT__xor_ram_0_rdata_out),128);
        bufp->chgWData(oldp+1699,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__xor_ram_0_wdata),128);
        bufp->chgBit(oldp+1703,((0xeU == vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__mac_buffer_thread)));
        bufp->chgBit(oldp+1704,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__xor_ram_0_enable));
        bufp->chgIData(oldp+1705,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__mac_buffer_thread),32);
        bufp->chgWData(oldp+1706,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__axistreamin_tdata_24),128);
        bufp->chgBit(oldp+1710,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__axistreamin_tlast_25));
        bufp->chgWData(oldp+1711,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__axistreamin_tdata_26),128);
        bufp->chgBit(oldp+1715,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__axistreamin_tlast_27));
        bufp->chgIData(oldp+1716,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__read_burst_fsm_0),32);
        bufp->chgCData(oldp+1717,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__read_burst_addr_35),2);
        bufp->chgCData(oldp+1718,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__read_burst_stride_36),2);
        bufp->chgQData(oldp+1719,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__read_burst_length_37),33);
        bufp->chgBit(oldp+1721,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__read_burst_rvalid_38));
        bufp->chgBit(oldp+1722,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__read_burst_rlast_39));
        bufp->chgCData(oldp+1723,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+1724,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+1725,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axis_in_aes_read_req_fifo_empty));
        bufp->chgBit(oldp+1726,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__head) 
                                 == (7U & ((IData)(1U) 
                                           + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+1727,(((7U & ((IData)(1U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__tail))));
        bufp->chgBit(oldp+1728,(((7U & ((IData)(2U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+1729,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__mem
                                  [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_aes_read_req_fifo__DOT__tail]),105);
        bufp->chgCData(oldp+1733,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+1734,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+1735,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axis_in_xordata_read_req_fifo_empty));
        bufp->chgBit(oldp+1736,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__head) 
                                 == (7U & ((IData)(1U) 
                                           + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+1737,(((7U & ((IData)(1U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__tail))));
        bufp->chgBit(oldp+1738,(((7U & ((IData)(2U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+1739,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__mem
                                  [vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_in_xordata_read_req_fifo__DOT__tail]),105);
        bufp->chgWData(oldp+1743,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__mem[0]),105);
        bufp->chgWData(oldp+1747,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__mem[1]),105);
        bufp->chgWData(oldp+1751,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__mem[2]),105);
        bufp->chgWData(oldp+1755,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__mem[3]),105);
        bufp->chgWData(oldp+1759,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__mem[4]),105);
        bufp->chgWData(oldp+1763,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__mem[5]),105);
        bufp->chgWData(oldp+1767,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__mem[6]),105);
        bufp->chgWData(oldp+1771,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__mem[7]),105);
        bufp->chgCData(oldp+1775,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__head),3);
        bufp->chgCData(oldp+1776,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__tail),3);
        bufp->chgBit(oldp+1777,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axis_out_xoreddata_write_req_fifo_empty));
        bufp->chgBit(oldp+1778,(((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__head) 
                                 == (7U & ((IData)(1U) 
                                           + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__tail))))));
        bufp->chgBit(oldp+1779,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axis_out_xoreddata_write_req_fifo_full));
        bufp->chgBit(oldp+1780,(((7U & ((IData)(2U) 
                                        + (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__head))) 
                                 == (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst___05Faxis_out_xoreddata_write_req_fifo__DOT__tail))));
        bufp->chgWData(oldp+1781,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT___axis_out_xoreddata_write_req_fifo_rdata),105);
        bufp->chgWData(oldp+1785,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst_xor_ram__DOT__mem[0]),128);
        bufp->chgWData(oldp+1789,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst_xor_ram__DOT__mem[1]),128);
        bufp->chgWData(oldp+1793,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst_xor_ram__DOT__mem[2]),128);
        bufp->chgWData(oldp+1797,(vlSelf->top__DOT__uut__DOT__uut__DOT__xor_inst__DOT__inst_xor_ram__DOT__mem[3]),128);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[2U])) {
        bufp->chgBit(oldp+1801,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__busy));
        bufp->chgBit(oldp+1802,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__done));
        bufp->chgWData(oldp+1803,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__ciphertext),128);
        bufp->chgCData(oldp+1807,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__st),2);
        bufp->chgCData(oldp+1808,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__round),4);
        bufp->chgWData(oldp+1809,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state),128);
        bufp->chgCData(oldp+1813,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[0]),8);
        bufp->chgCData(oldp+1814,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[1]),8);
        bufp->chgCData(oldp+1815,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[2]),8);
        bufp->chgCData(oldp+1816,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[3]),8);
        bufp->chgCData(oldp+1817,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[4]),8);
        bufp->chgCData(oldp+1818,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[5]),8);
        bufp->chgCData(oldp+1819,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[6]),8);
        bufp->chgCData(oldp+1820,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[7]),8);
        bufp->chgCData(oldp+1821,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[8]),8);
        bufp->chgCData(oldp+1822,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[9]),8);
        bufp->chgCData(oldp+1823,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[10]),8);
        bufp->chgCData(oldp+1824,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[11]),8);
        bufp->chgCData(oldp+1825,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[12]),8);
        bufp->chgCData(oldp+1826,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[13]),8);
        bufp->chgCData(oldp+1827,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[14]),8);
        bufp->chgCData(oldp+1828,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__sb[15]),8);
        __Vtemp_32[0U] = (IData)((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u8__out)) 
                                   << 0x38U) | (((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u9__out)) 
                                                 << 0x30U) 
                                                | (((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u10__out)) 
                                                    << 0x28U) 
                                                   | (((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u11__out)) 
                                                       << 0x20U) 
                                                      | (QData)((IData)(
                                                                        (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u12__out) 
                                                                          << 0x18U) 
                                                                         | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u13__out) 
                                                                             << 0x10U) 
                                                                            | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u14__out) 
                                                                                << 8U) 
                                                                               | (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u15__out)))))))))));
        __Vtemp_32[1U] = (IData)(((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u8__out)) 
                                    << 0x38U) | (((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u9__out)) 
                                                  << 0x30U) 
                                                 | (((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u10__out)) 
                                                     << 0x28U) 
                                                    | (((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u11__out)) 
                                                        << 0x20U) 
                                                       | (QData)((IData)(
                                                                         (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u12__out) 
                                                                           << 0x18U) 
                                                                          | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u13__out) 
                                                                              << 0x10U) 
                                                                             | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u14__out) 
                                                                                << 8U) 
                                                                                | (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u15__out)))))))))) 
                                  >> 0x20U));
        __Vtemp_32[2U] = (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u4__out) 
                           << 0x18U) | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u5__out) 
                                         << 0x10U) 
                                        | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u6__out) 
                                            << 8U) 
                                           | (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u7__out))));
        __Vtemp_32[3U] = (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u0__out) 
                           << 0x18U) | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u1__out) 
                                         << 0x10U) 
                                        | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u2__out) 
                                            << 8U) 
                                           | (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u3__out))));
        bufp->chgWData(oldp+1829,(__Vtemp_32),128);
        __Vtemp_40[0U] = (IData)((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u2__out)) 
                                   << 0x38U) | (((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u6__out)) 
                                                 << 0x30U) 
                                                | (((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u10__out)) 
                                                    << 0x28U) 
                                                   | (((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u14__out)) 
                                                       << 0x20U) 
                                                      | (QData)((IData)(
                                                                        (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u3__out) 
                                                                          << 0x18U) 
                                                                         | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u7__out) 
                                                                             << 0x10U) 
                                                                            | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u11__out) 
                                                                                << 8U) 
                                                                               | (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u15__out)))))))))));
        __Vtemp_40[1U] = (IData)(((((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u2__out)) 
                                    << 0x38U) | (((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u6__out)) 
                                                  << 0x30U) 
                                                 | (((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u10__out)) 
                                                     << 0x28U) 
                                                    | (((QData)((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u14__out)) 
                                                        << 0x20U) 
                                                       | (QData)((IData)(
                                                                         (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u3__out) 
                                                                           << 0x18U) 
                                                                          | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u7__out) 
                                                                              << 0x10U) 
                                                                             | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u11__out) 
                                                                                << 8U) 
                                                                                | (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u15__out)))))))))) 
                                  >> 0x20U));
        __Vtemp_40[2U] = (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u1__out) 
                           << 0x18U) | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u5__out) 
                                         << 0x10U) 
                                        | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u9__out) 
                                            << 8U) 
                                           | (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u13__out))));
        __Vtemp_40[3U] = (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u0__out) 
                           << 0x18U) | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u4__out) 
                                         << 0x10U) 
                                        | (((IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u8__out) 
                                            << 8U) 
                                           | (IData)(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u12__out))));
        bufp->chgWData(oldp+1833,(__Vtemp_40),128);
        bufp->chgWData(oldp+1837,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__mixcolumns_state),128);
        bufp->chgCData(oldp+1841,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[0]),8);
        bufp->chgCData(oldp+1842,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[1]),8);
        bufp->chgCData(oldp+1843,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[2]),8);
        bufp->chgCData(oldp+1844,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[3]),8);
        bufp->chgCData(oldp+1845,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[4]),8);
        bufp->chgCData(oldp+1846,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[5]),8);
        bufp->chgCData(oldp+1847,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[6]),8);
        bufp->chgCData(oldp+1848,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[7]),8);
        bufp->chgCData(oldp+1849,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[8]),8);
        bufp->chgCData(oldp+1850,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[9]),8);
        bufp->chgCData(oldp+1851,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[10]),8);
        bufp->chgCData(oldp+1852,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[11]),8);
        bufp->chgCData(oldp+1853,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[12]),8);
        bufp->chgCData(oldp+1854,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[13]),8);
        bufp->chgCData(oldp+1855,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[14]),8);
        bufp->chgCData(oldp+1856,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__s[15]),8);
        bufp->chgCData(oldp+1857,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[0]),8);
        bufp->chgCData(oldp+1858,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[1]),8);
        bufp->chgCData(oldp+1859,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[2]),8);
        bufp->chgCData(oldp+1860,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[3]),8);
        bufp->chgCData(oldp+1861,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[4]),8);
        bufp->chgCData(oldp+1862,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[5]),8);
        bufp->chgCData(oldp+1863,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[6]),8);
        bufp->chgCData(oldp+1864,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[7]),8);
        bufp->chgCData(oldp+1865,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[8]),8);
        bufp->chgCData(oldp+1866,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[9]),8);
        bufp->chgCData(oldp+1867,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[10]),8);
        bufp->chgCData(oldp+1868,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[11]),8);
        bufp->chgCData(oldp+1869,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[12]),8);
        bufp->chgCData(oldp+1870,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[13]),8);
        bufp->chgCData(oldp+1871,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[14]),8);
        bufp->chgCData(oldp+1872,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__xtime_s[15]),8);
        bufp->chgCData(oldp+1873,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[0]),8);
        bufp->chgCData(oldp+1874,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[1]),8);
        bufp->chgCData(oldp+1875,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[2]),8);
        bufp->chgCData(oldp+1876,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[3]),8);
        bufp->chgCData(oldp+1877,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[4]),8);
        bufp->chgCData(oldp+1878,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[5]),8);
        bufp->chgCData(oldp+1879,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[6]),8);
        bufp->chgCData(oldp+1880,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[7]),8);
        bufp->chgCData(oldp+1881,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[8]),8);
        bufp->chgCData(oldp+1882,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[9]),8);
        bufp->chgCData(oldp+1883,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[10]),8);
        bufp->chgCData(oldp+1884,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[11]),8);
        bufp->chgCData(oldp+1885,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[12]),8);
        bufp->chgCData(oldp+1886,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[13]),8);
        bufp->chgCData(oldp+1887,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[14]),8);
        bufp->chgCData(oldp+1888,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__d[15]),8);
        bufp->chgCData(oldp+1889,((vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[3U] 
                                   >> 0x18U)),8);
        bufp->chgCData(oldp+1890,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u0__out),8);
        bufp->chgCData(oldp+1891,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[3U] 
                                            >> 0x10U))),8);
        bufp->chgCData(oldp+1892,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u1__out),8);
        bufp->chgCData(oldp+1893,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[1U] 
                                            >> 8U))),8);
        bufp->chgCData(oldp+1894,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u10__out),8);
        bufp->chgCData(oldp+1895,((0xffU & vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[1U])),8);
        bufp->chgCData(oldp+1896,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u11__out),8);
        bufp->chgCData(oldp+1897,((vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[0U] 
                                   >> 0x18U)),8);
        bufp->chgCData(oldp+1898,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u12__out),8);
        bufp->chgCData(oldp+1899,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[0U] 
                                            >> 0x10U))),8);
        bufp->chgCData(oldp+1900,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u13__out),8);
        bufp->chgCData(oldp+1901,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[0U] 
                                            >> 8U))),8);
        bufp->chgCData(oldp+1902,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u14__out),8);
        bufp->chgCData(oldp+1903,((0xffU & vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[0U])),8);
        bufp->chgCData(oldp+1904,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u15__out),8);
        bufp->chgCData(oldp+1905,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[3U] 
                                            >> 8U))),8);
        bufp->chgCData(oldp+1906,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u2__out),8);
        bufp->chgCData(oldp+1907,((0xffU & vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[3U])),8);
        bufp->chgCData(oldp+1908,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u3__out),8);
        bufp->chgCData(oldp+1909,((vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[2U] 
                                   >> 0x18U)),8);
        bufp->chgCData(oldp+1910,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u4__out),8);
        bufp->chgCData(oldp+1911,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[2U] 
                                            >> 0x10U))),8);
        bufp->chgCData(oldp+1912,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u5__out),8);
        bufp->chgCData(oldp+1913,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[2U] 
                                            >> 8U))),8);
        bufp->chgCData(oldp+1914,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u6__out),8);
        bufp->chgCData(oldp+1915,((0xffU & vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[2U])),8);
        bufp->chgCData(oldp+1916,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u7__out),8);
        bufp->chgCData(oldp+1917,((vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[1U] 
                                   >> 0x18U)),8);
        bufp->chgCData(oldp+1918,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u8__out),8);
        bufp->chgCData(oldp+1919,((0xffU & (vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT__state[1U] 
                                            >> 0x10U))),8);
        bufp->chgCData(oldp+1920,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__aes_inst__DOT____Vcellout__u9__out),8);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[3U])) {
        bufp->chgBit(oldp+1921,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__start));
        bufp->chgWData(oldp+1922,(vlSelf->top__DOT__uut__DOT__uut__DOT__aes_inst__DOT__plaintext),128);
    }
    bufp->chgBit(oldp+1926,(vlSelf->io_CLK));
    bufp->chgBit(oldp+1927,(vlSelf->io_RST));
    bufp->chgBit(oldp+1928,(vlSelf->top__DOT__CLK));
    bufp->chgBit(oldp+1929,(vlSelf->top__DOT__RST));
}

void Vtop___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_cleanup\n"); );
    // Init
    Vtop___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtop___024root*>(voidSelf);
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[3U] = 0U;
}
