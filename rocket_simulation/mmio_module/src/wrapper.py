# 複数のMMIOモジュールを使用する場合のmain.pyの例

import os
import sys
from veriloggen import *
import veriloggen as vg
import veriloggen.thread as vthread
import veriloggen.types.axi as axi
from mmio_map import *

def main(memimg=None):
    m = Module('wrapper')
    clk = m.Input('CLK')
    rst = m.Input('RST')
    # SPM
    axi_s_ctrl_spm = vthread.AXISLiteRegister(m,"axi_s_ctrl_spm", clk, rst, 64, length=7, noio=False)
    axi_m_dram = vthread.AXIM(m,"axi_m_dram", clk, rst, 128, addrwidth=32, noio=False)
    # MAC
    axi_s_ctrl_mac = vthread.AXISLiteRegister(m,"axi_s_ctrl_mac", clk, rst, 64, length=7, noio=False)
    # XOR
    axi_s_ctrl_xor = vthread.AXISLiteRegister(m,"axi_s_ctrl_xor", clk, rst, 64, length=2, noio=False)
    # AES
    axi_s_ctrl_aes = vthread.AXISLiteRegister(m,"axi_s_ctrl_aes", clk, rst, 64, length=9, noio=False)
    # AXIManager
    axi_s_ctrl_manager = vthread.AXISLiteRegister(m,"axi_s_ctrl_axim", clk, rst, 64, length=6, noio=False)
    axi_s_llc = axi.AxiSlave(m, 'axi_s_llc', clk, rst, datawidth=128, addrwidth=32, noio=False)
    return m

if __name__ == '__main__':
    m = main()
    verilog = m.to_verilog('w.v')
    # print(verilog)
