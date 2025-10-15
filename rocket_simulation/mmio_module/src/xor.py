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

### ---- レジスタマップ ----
# 0x00 : START
### ------------------------
def mkXOR():
    """
    AXI-Lite Slaveで制御する
    4つのインターフェースを持つ
    1. 制御用 AXI-Lite Slave (64bit幅)
    2. SPMからデータを受け取る AXIstreamIN
    """
    m = vg.Module('xored')
    clk = m.Input('CLK')
    rst = m.Input('RST')

    # --- インターフェース定義 ---
    # 1. 制御用 AXI-Lite Slave (64bit幅)
    saxi = vthread.AXISLiteRegister(m, 'axi_s_ctrl_xored', clk, rst, datawidth=64, length=2)
    # 2. SPM用 AXI streamin (128bit幅)
    data_axi_stream_in = vthread.AXIStreamIn(m, 'axis_in_xordata', clk, rst, datawidth=128, with_last=True)
    # 3. SPM用 AXI streamout (128bit幅)
    data_axi_stream_out = vthread.AXIStreamOut(m, 'axis_out_xoreddata', clk, rst, datawidth=128, with_last=True)
    # 4. AES用 AXI streamin (128bit幅)
    aes_axi_stream_in = vthread.AXIStreamIn(m, 'axis_in_aes', clk, rst, datawidth=128, with_last=True)
    data = m.TmpReg(128, initval=0, prefix='data')
    otp = m.TmpReg(128, initval=0, prefix='otp')
    xored = m.TmpReg(128, initval=0, prefix='xored')
    xored_ram = vthread.RAM(m, 'xor_ram', clk, rst, datawidth=128, addrwidth=2)
    def xor():
        while(1):
            if saxi.read(0) == 0:
                continue
            else :
                for i in range(4):
                    data.value, last = data_axi_stream_in.read()
                    otp.value, last = aes_axi_stream_in.read()
                    xored.value = data.value ^ otp.value
                    xored_ram.write(i, xored.value)
                    # print(" AES OTP %d: %x (data=%x)" % (i, otp.value, data.value))
                data_axi_stream_out.dma_write_async(xored_ram, 0, 4)
                #     print("Received chunk %d: %x (last=%d)" % (i, data.value, last))
                # print("XOR Completed")
                saxi.write(0,0) # STARTビットクリア

    th_xor = vthread.Thread(m, 'mac_buffer_thread', clk, rst, xor)
    # スレッドをVerilogのステートマシンとして合成
    fsm = th_xor.start()
    return m

def mkTest(memimg_name=None):
    m = Module('test_xored')

    # target instance
    led = mkXOR()

    # copy paras and ports
    params = m.copy_params(led)
    ports = m.copy_sim_ports(led)

    clk = ports['CLK']
    rst = ports['RST']

    maxi = vthread.AXIMLite(m, 'maxi_xor', clk, rst, 64,addrwidth=32,noio=True)
    stream_out = vthread.AXIStreamOut(m, 'm_axis_xor', clk, rst, datawidth=128, with_last=True, noio=True)
    aes_stream_out = vthread.AXIStreamOut(m, 'm_axis_aes_xor', clk, rst, datawidth=128, with_last=True, noio=True)
    stream_in = vthread.AXIStreamIn(m, 's_axis_xor', clk, rst, datawidth=128, with_last=True, noio=True)
    maxi.connect(ports, 'axi_s_ctrl_xored')
    stream_out.connect(ports, 'axis_in_xordata')
    aes_stream_out.connect(ports, 'axis_in_aes')
    stream_in.connect(ports, 'axis_out_xoreddata')
    otp = m.TmpReg(128, initval=0, prefix='otp')
    data = m.TmpReg(128, initval=0, prefix='data')
    read_data = m.TmpReg(128, initval=0, prefix='read_data')

    xor_ram = vthread.RAM(m,'xor_ram',clk,rst,datawidth=128,addrwidth=4)
    # data = m.TmpReg(128, initval=0, prefix='data')
    def read():
        for i in range(4):
            read_data.value, last = stream_in.read()
            print("Received chunk %d: %x (last=%d)" % (i, read_data.value, last))
    th_read = vthread.Thread(m, 'th_read', clk, rst, read)
    th_read.start()
    def ctrl():
        maxi.write(0*8,1) # Command: START
        for i in range(4):
            data.value = i
            xor_ram.write(i, data.value)
        stream_out.dma_write_async(xor_ram,0,4)
        for i in range(4):
            # data.value = i
            otp.value = i + 0x1000
            # stream_in.write(data.value, last=(i==3))
            aes_stream_out.write(otp.value, last=(i==3))

        while(1):
            v = maxi.read(0*8)
            if v == 0:
                break
            pass
        # print("Completed")
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
    rslt = run(filename='../verilog/xored.v')
    print(rslt)