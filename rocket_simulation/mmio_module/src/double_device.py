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
FNV_PRIME = 0x100000001b3
FNV_OFFSET_BASIS = 0xcbf29ce484222325
def mkDouble():
    """
    AXI-Lite Slaveで制御し、AES-CTR OTPを計算して
    AXI-Streamで出力するモジュール
    4つのインターフェースを持つ
    1. 制御用 AXI-Lite Slave (64bit幅)
    2. SPMからデータを受け取る AXIstreamIN
    """
    m = vg.Module('double')
    clk = m.Input('CLK')
    rst = m.Input('RST')

    # --- インターフェース定義 ---
    # 1. 制御用 AXI-Lite Slave (64bit幅)

    saxi = vthread.AXISRegister(m, 'axi_s_ctrl_double', clk, rst, datawidth=64,length=3,waddr_id_width=4, wdata_id_width=4, wresp_id_width=4,
                 raddr_id_width=4, rdata_id_width=4,)

    in_reg = m.TmpReg(64, initval=0, prefix='in_reg')
    def double_read():
        while(1):
            # saxi.write(2,1)
            # while(1):
            in_reg.value = saxi.read(0)
            #     # saxi.write(2,1)
            #     if in_reg.value != 0:
            #         break
            #     else :
            #         saxi.write(2,1)
            saxi.write(1, in_reg * 2)

            # saxi.write(2, 0)
    th_read = vthread.Thread(m, 'double_read_thread', clk, rst, double_read)
    # th_write = vthread.Thread(m, 'double_write_thread', clk, rst, double_write)
    th_read.start()
    # th_write.start()
    return m

def mkTest(memimg_name=None):
    m = Module('test_double')

    # target instance
    led = mkDouble()

    # copy paras and ports
    params = m.copy_params(led)
    ports = m.copy_sim_ports(led)

    clk = ports['CLK']
    rst = ports['RST']

    maxi = vthread.AXIM(m, 'maxi_double', clk, rst, 64,addrwidth=32,noio=True)
    maxi.connect(ports, 'axi_s_ctrl_double')
    data = m.TmpReg(64, initval=0, prefix='data')
    def ctrl():
        maxi.write(0,3)
        # while (1):
        #     if maxi.read(16) == 0:
        #         break
        #     else:
        #         pass
        data.value = maxi.read(8) # out_reg
        print("out_reg: %d" % data.value)
        data.value = maxi.read(8) # out_reg
        print("out_reg: %d" % data.value)
    th = vthread.Thread(m, 'th_ctrl', clk, rst, ctrl)
    th.start()

    uut = m.Instance(led, 'uut',
                     params=m.connect_params(led),
                     ports=m.connect_ports(led))

    vcd_name = os.path.splitext(os.path.basename(__file__))[0] + '.vcd'
    simulation.setup_waveform(m, uut, dumpfile=vcd_name)
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
    rslt = run(filename='../verilog/double.v')
    print(rslt)