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
def mkAES():
    """
    AXI-Lite Slaveで制御し、AES-CTR OTPを計算して
    AXI-Streamで出力するモジュール
    4つのインターフェースを持つ
    1. 制御用 AXI-Lite Slave (64bit幅)
    2. SPMからデータを受け取る AXIstreamIN
    """
    m = Module('aes')
    clk = m.Input('CLK')
    rst = m.Input('RST')

    # --- インターフェース定義 ---
    # 1. 制御用 AXI-Lite Slave (64bit幅)
    saxi = vthread.AXISLiteRegister(m, 'axi_s_ctrl_aes', clk, rst, datawidth=64, length=9)
    # 2. AXI Manager用 AXI stream out (128bit幅)
    a_axi_stream = vthread.AXIStreamOut(m, 'axis_out_aes', clk, rst, datawidth=128, with_last=True)
    data_low = m.TmpReg(64, initval=0, prefix='data')
    data_high = m.TmpReg(64, initval=0, prefix='data')
    data = m.TmpReg(128, initval=0, prefix='data')
    otp = m.TmpReg(128, initval=0, prefix='otp_data')
    aes_ram = vthread.RAM(m, 'aes_ram', clk, rst, datawidth=128, addrwidth=2)

    start = m.Reg('start',1, initval=0)
    plaintext = m.Reg('plaintext',128, initval=0)
    busy = m.Wire('busy',1)
    done = m.Wire('done',1)
    ciphertext = m.Wire('ciphertext',128)
    ports = (
        ('CLK', clk),
        ('RST', rst),
        ('start', start),
        ('plaintext', plaintext),
        ('busy', busy),
        ('done',done),
        ('ciphertext',ciphertext),
    )
    modules = from_verilog.read_verilog_stubmodule("aes_rtl.v")
    aes_inst = modules['aes128_enc_fixedkey']
    m.Instance(aes_inst, 'aes_inst',ports=ports)
    def aes():
        while True:
            # --- 制御レジスタの読み込み ---
            saxi.wait_flag(8,1) # START信号待ち
            # AESの計算
            for i in range(4):
                data_low.value = saxi.read(2*i)
                data_high.value = saxi.read(2*i+1)
                plaintext.value = (data_high.value << 64) | data_low.value
                start.value = 1
                start.value = 0
                while(1):
                    if done == 1:
                        break
                    pass
                otp.value = ciphertext
                aes_ram.write(i, otp.value)
            a_axi_stream.dma_write_async(aes_ram, 0, 4)
            saxi.write(8,0) # STARTビットクリア
    # スレッドをVerilogのステートマシンとして合成
    th = vthread.Thread(m, 'aes_thread', clk, rst, aes)
    fsm = th.start()
    return m

def mkTest(memimg_name=None):
    m = Module('test_aes')

    # target instance
    led = mkAES()

    # copy paras and ports
    params = m.copy_params(led)
    ports = m.copy_sim_ports(led)

    clk = ports['CLK']
    rst = ports['RST']

    maxi = vthread.AXIMLite(m, 'maxi_aes', clk, rst, 64,addrwidth=32,noio=True)
    stream_in = vthread.AXIStreamIn(m, 's_axis_aes', clk, rst, datawidth=128, with_last=True, noio=True)
    maxi.connect(ports, 'axi_s_ctrl_aes')
    stream_in.connect(ports, 'axis_out_aes')
    read_data = m.TmpReg(128, initval=0, prefix='read_data')
    # data = m.TmpReg(128, initval=0, prefix='data')
    def ctrl():
        for i in range(8):
            maxi.write(i*8,i)
        maxi.write(8*8,1)
        for i in range(4):
            read_data.value, last = stream_in.read()
            # print("Received chunk %d: %x (last=%d)" % (i, read_data.value, last))
        # maxi.wait_flag(8,0) # wait for clearing START bit
        while(1):
            v = maxi.read(8*8)
            if v == 0:
                break
            pass
        # print("Completed")
        for i in range(8):
            maxi.write(i*8,i + 10)
        maxi.write(8*8,1)
        for i in range(4):
            read_data.value, last = stream_in.read()
            # print("Received chunk %d: %x (last=%d)" % (i, read_data.value, last))
        while(1):
            v = maxi.read(8*8)
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
    rslt = run(filename='../verilog/aes.v')
    print(rslt)