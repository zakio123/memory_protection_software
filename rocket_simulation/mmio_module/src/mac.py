from __future__ import absolute_import
from __future__ import print_function
import sys
import os

# # the next line can be removed after installation
# sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
#     os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))))

from veriloggen import *
import veriloggen as vg
import veriloggen.thread as vthread
from mmio_map import *
### ---- レジスタマップ ----
# 0x00 : SPM Address (64bit)
# 0x08 : SPM Start Address (64bit)
# 0x10 : Command (0: idle, 1: start) (64bit)
# 0x18 : Status (0: idle, 1: busy, 2: done) (64bit)
# 0x20 : Start Bit (write 1 to start / read busy) (64bit)
# 0x28 : End Bit (read 1 when done) (64bit)
# 0x30 : MAC Result (128bit) (64bit)
### ------------------------
FNV_PRIME = 0x100000001b3
FNV_OFFSET_BASIS = 0xcbf29ce484222325
def mkMAC():
    """
    AXI-Lite Slaveで制御し、AES-CTR OTPを計算して
    AXI-Streamで出力するモジュール
    4つのインターフェースを持つ
    1. 制御用 AXI-Lite Slave (64bit幅)
    2. SPMからデータを受け取る AXIstreamIN
    """
    m = vg.Module('mac')
    clk = m.Input('CLK')
    rst = m.Input('RST')

    # --- インターフェース定義 ---
    # 1. 制御用 AXI-Lite Slave (64bit幅)
    saxi = vthread.AXISLiteRegister(m, 'axi_s_ctrl_mac', clk, rst, datawidth=64, length=7)
    # 2. SPM用 AXI stream (128bit幅)
    a_axi_stream = vthread.AXIStreamIn(m, 'axis_in_mac', clk, rst, datawidth=128, with_last=True)
    
    buffer = m.TmpReg(512, initval=0, prefix='buffer')
    mac_result = m.TmpReg(64, initval=0, prefix='mac_result')
    data = m.TmpReg(128, initval=0, prefix='data')
    start_bit = m.TmpReg(64, initval=0, prefix='start_bit')
    end_bit = m.TmpReg(64, initval=0, prefix='end_bit')
    mask = m.TmpReg(512, initval=0, prefix='mask')
    def mac_buffer():
        while(1):
            # buffer.value = 0
            for i in range(4):
                data.value, last = a_axi_stream.read()
                mask.value = ~(0xffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff << (128*i))
                print(" read: %x" % data.value)
                buffer.value = (buffer.value & mask ) | (data.value << (128*i))
    def mac():
        while True:
            # th_buffer.start()
            while(1):
                if saxi.read(MAC_COMMAND) != 0:
                    break
                pass
            # MACの計算
            saxi.write(MAC_STATUS, 1) # Statusをbusyに
            if saxi.read(MAC_COMMAND) == 1:
                mac_result.value = FNV_OFFSET_BASIS
            elif saxi.read(MAC_COMMAND) == 2:
                start_bit.value = saxi.read(MAC_START_BIT)
                end_bit.value = saxi.read(MAC_END_BIT)
                print("buffer: %x" % buffer.value)
                for i in range(start_bit.value / 8, end_bit.value / 8 + 1):
                    byte = (buffer.value >> (i*8)) & 0xff
                    mac_result.value = mac_result.value ^ byte
                    mac_result.value = (mac_result.value * FNV_PRIME)
            else :
                saxi.write(MAC_RESULT,mac_result.value) # Endビットクリア
            saxi.write(MAC_COMMAND,0)
            saxi.write(MAC_STATUS,0) # Statusをdoneに

    th_buffer = vthread.Thread(m, 'mac_buffer_thread', clk, rst, mac_buffer)
    # スレッドをVerilogのステートマシンとして合成
    th = vthread.Thread(m, 'spm_thread', clk, rst, mac)
    th_buffer.start()
    fsm = th.start()
    return m

def mkTest(memimg_name=None):
    m = Module('test_mac')

    # target instance
    led = mkMAC()

    # copy paras and ports
    params = m.copy_params(led)
    ports = m.copy_sim_ports(led)

    clk = ports['CLK']
    rst = ports['RST']

    maxi = vthread.AXIMLite(m, 'maxi_mac', clk, rst, 64,addrwidth=32,noio=True)
    stream_in = vthread.AXIStreamOut(m, 's_axis_mac', clk, rst, datawidth=128, with_last=True, noio=True)
    maxi.connect(ports, 'axi_s_ctrl_mac')
    stream_in.connect(ports, 'axis_in_mac')
    read_data = m.TmpReg(128, initval=0, prefix='read_data')
    # data = m.TmpReg(128, initval=0, prefix='data')
    def ctrl():
        for i in range(4):
            stream_in.write(i, last=(i==3))
        # for i in range(8):
        #     maxi.write(i*8,i)
        maxi.write(MAC_COMMAND*8, 1) # Command: INIT
        while(1):
            if (maxi.read(MAC_STATUS*8) == 0):
                break
            pass
        maxi.write(MAC_START_BIT*8, 0) # Clear start bit
        maxi.write(MAC_END_BIT*8, 64) # End bit
        maxi.write(MAC_COMMAND*8, 2) # Clear end bit
        while(1):
            if (maxi.read(MAC_STATUS*8) == 0):
                break
            pass
        for i in range(4):
            stream_in.write(i*2, last=(i==3))
        while(1):
            if (maxi.read(MAC_STATUS*8) == 0):
                break
            pass
        maxi.write(MAC_START_BIT*8, 0) # Clear start bit
        maxi.write(MAC_END_BIT*8, 7) # End bit
        maxi.write(MAC_COMMAND*8,2) # Clear end bit
        while(1):
            if (maxi.read(MAC_STATUS*8) == 0):
                break
            pass
        maxi.write(MAC_COMMAND*8,4) # Command: CALC
        while(1):
            if (maxi.read(MAC_STATUS*8) == 0):
                break
            pass
        print("MAC Result: %x" % maxi.read(MAC_RESULT*8))
    th = vthread.Thread(m, 'th_ctrl', clk, rst, ctrl)
    th.start()

    uut = m.Instance(led, 'uut',
                     params=m.connect_params(led),
                     ports=m.connect_ports(led))

    # vcd_name = os.path.splitext(os.path.basename(__file__))[0] + '.vcd'
    # simulation.setup_waveform(m, uut, dumpfile=vcd_name)
    simulation.setup_clock(m, clk, hperiod=5)
    init = simulation.setup_reset(m, rst, m.make_reset(), period=100)

    init.add(
        Delay(1000000),
        Systask('finish'),
    )

    return m


def run(filename='tmp.v', simtype='iverilog', outputfile=None):

    if outputfile is None:
        outputfile = os.path.splitext(os.path.basename(__file__))[0] + '.out'

    memimg_name = 'memimg_' + outputfile

    test = mkTest(memimg_name=memimg_name)

    if filename is not None:
        test.to_verilog(filename)

    sim = simulation.Simulator(test, sim=simtype)
    rslt = sim.run(outputfile=outputfile)

    return rslt


if __name__ == '__main__':
    rslt = run(filename='../verilog/mac.v')
    print(rslt)