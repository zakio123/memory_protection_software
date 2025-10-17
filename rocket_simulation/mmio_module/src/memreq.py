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
import veriloggen.types.axi as axi
### ---- レジスタマップ ----
# 0x00 : MEM RANGE (64bit)
# 0x08 : NUM (64bit)
### ------------------------

def mkMemReq():
    """
    AXI-Lite Slaveで制御し、AES-CTR OTPを計算して
    AXI-Streamで出力するモジュール
    4つのインターフェースを持つ
    1. 制御用 AXI-Lite Slave (64bit幅)
    2. SPMからデータを受け取る AXIstreamIN
    """
    m = vg.Module('memreq')
    clk = m.Input('CLK')
    rst = m.Input('RST')

    # --- インターフェース定義 ---
    # 1. 制御用 AXI-Lite Slave (64bit幅)
    saxi = vthread.AXISLiteRegister(m, 'axi_s_ctrl_memreq', clk, rst, datawidth=64, length=7)
    # 2. Memory リクエスト用 AXI Master (64bit幅)
    axi_m_llc = vthread.AXIM(m, 'axi_m_llc', clk, rst, 128, addrwidth=32)
    num = m.TmpReg(64, initval=0, prefix='num')
    mem_range = m.TmpReg(64, initval=0, prefix='mem_range')
    addr = m.TmpReg(64, initval=0, prefix='addr')
    memreq_range = m.TmpReg(64, initval=0, prefix='memreq_range')
    addrwidth = 20
    request_ram = vthread.RAM(m, 'request_ram', clk, rst, 128, addrwidth=addrwidth)
    receive_ram = vthread.RAM(m, 'receive_ram', clk, rst, 128, addrwidth=addrwidth)
    # LLCへデータを書き込むテスト
    read_llc_data = m.TmpReg(128, initval=0, prefix='read_llc_data')
    test_data = m.TmpReg(128, initval=0, prefix='test_data')
    a = m.TmpReg(64, initval=0, prefix='a')
    c = m.TmpReg(64, initval=0, prefix='c')
    N = m.TmpReg(64, initval=0, prefix='N')
    x = m.TmpReg(64, initval=0, prefix='x')
    y = m.TmpReg(64, initval=0, prefix='y')
    
    def lcg_random():
        # 0~N-1の乱数を生成
        y.value = (x.value * a.value + c.value) % N.value
    
    def memreq():
        # while True:
        while(1):
            mem_range.value = saxi.read(MEMREQ_RANGE)
            num.value = saxi.read(MEMREQ_NUM)
            if num.value != 0 and mem_range.value != 0:
                memreq_range.value = (mem_range.value // num.value)
                if memreq_range.value < 64:
                    memreq_range.value = 64
                # 64byteアラインメント
                memreq_range.value = (memreq_range.value >> 6) << 6
                print("MEMREQ start: range %d, num %d, each %d" % (mem_range.value, num.value, memreq_range.value))
                break
            pass
        for i in range(4 * num.value):
            request_ram.write(i, i*2)
        for i in range(num.value):
            addr.value = i * memreq_range.value
            axi_m_llc.dma_write(request_ram, global_addr=addr.value,local_size=4,local_addr=i*4)
        a.value = 1664525
        c.value = 1013904223
        N.value = num.value
        for i in range(num.value):
            x.value = i
            lcg_random()
            for j in range(4):
                request_ram.write(y.value * 4 + j, (i+j)*2)
            axi_m_llc.dma_write(request_ram, global_addr=y.value * memreq_range.value, local_size=4, local_addr=y.value * 4)
        for i in range(N.value):
            x.value = i
            lcg_random()
            axi_m_llc.dma_read(receive_ram, global_addr=y.value * memreq_range.value, local_size=4, local_addr=y.value * 4)
        for i in range(4 * num.value):
            read_llc_data.value = receive_ram.read(i)
            test_data.value = request_ram.read(i)
            if read_llc_data.value != test_data.value:
                print("LLC data mismatch %d: %x" % (i, read_llc_data.value))
        # print("MEMREQ done")
        vthread.finish()
    th = vthread.Thread(m, 'memreq_thread', clk, rst, memreq)
    th.start()
    return m

def mkTest(memimg_name=None):
    m = Module('test_memreq')
    # target instance
    led = mkMemReq()
    # copy paras and ports
    params = m.copy_params(led)
    ports = m.copy_sim_ports(led)
    clk = ports['CLK']
    rst = ports['RST']
    maxi = vthread.AXIMLite(m, 'maxi_memreq', clk, rst, 64,addrwidth=32,noio=True)
    maxi.connect(ports, 'axi_s_ctrl_memreq')
    memory = axi.AxiMemoryModel(m, 'memory_request', clk, rst, datawidth=128, addrwidth=32)
    memory.connect(ports, 'axi_m_llc')

    def ctrl():
        maxi.write(MEMREQ_RANGE*8, 1024) # MEM RANGE
        maxi.write(MEMREQ_NUM*8, 16) # NUM
        # while(1):
        #     pass
    th = vthread.Thread(m, 'th_ctrl', clk, rst, ctrl)
    th.start()
    uut = m.Instance(led, 'uut',
                     params=m.connect_params(led),
                     ports=m.connect_ports(led))
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
    rslt = run(filename='../verilog/memreq.v')
    print(rslt)