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
import veriloggen.types.axi as axi
from mmio_map import *
### ---- レジスタマップ ----
# 0x00 : DRAM Address (64bit)
# 0x08 : Local Address (64bit)
# 0x10 : Size (64bit)
# 0x18 : Direction (0: SPM->DRAM, 1: DRAM->SPM) (64bit)
# 0x20 : Start (write 1 to start / read busy) (64bit)
# 0x28 : Status (64bit)
# 0x30 : Destination (1:DRAM 2:MAC, 4:AXIManager) (64bit)
### ------------------------
d_addr_reg = 0
l_addr_reg = 1
size_reg = 2
direction_reg = 3
start_reg = 4
status_reg = 5
destination_reg = 6
def mkSMP():
    """
    AXI-Lite Slaveで制御し、AES-CTR OTPを計算して
    AXI-Streamで出力するモジュール
    4つのインターフェースを持つ
    1. 制御用 AXI-Lite Slave (64bit幅)
    2. DRAM用 AXI Master
    3. MAC用 AXI Master
    4. AXI-Manager用 AXI Master
    """
    m = vg.Module('spm')
    clk = m.Input('CLK')
    rst = m.Input('RST')

    # --- インターフェース定義 ---
    # 1. 制御用 AXI-Lite Slave (64bit幅)
    saxi = vthread.AXISLiteRegister(m, 'axi_s_ctrl_spm', clk, rst, datawidth=64, length=7)
    # 2. DRAM用 AXI Master (128bit幅)
    d_axim = vthread.AXIM(m, 'axi_m_dram', clk, rst, datawidth=64, addrwidth=32,waddr_id_width=4, wdata_id_width=4, wresp_id_width=4,
                 raddr_id_width=4, rdata_id_width=4,)
    # 3. MAC用 AXI Master (128bit幅)
    m_axi_stream_out = vthread.AXIStreamOut(m, 'axis_out_mac_spm', clk, rst, datawidth=128, with_last=True)
    # 4. AXI-Manager用 AXI (128bit幅)
    a_axi_stream_out = vthread.AXIStreamOut(m, 'axis_out_axim_spm', clk, rst, datawidth=128, addrwidth=32)
    a_axi_stream_in = vthread.AXIStreamIn(m, 'axis_in_axim_spm', clk, rst, datawidth=128, addrwidth=32)
    # 5. XOR用 AXI (128bit幅)
    x_axi_stream_out = vthread.AXIStreamOut(m, 'axis_out_xored_spm', clk, rst, datawidth=128, with_last=True)
    x_axi_stream_in = vthread.AXIStreamIn(m, 'axis_in_xored_spm', clk, rst, datawidth=128, with_last=True)

    spm_ram = vthread.RAM(m, 'ram_spm', clk, rst, datawidth=64, addrwidth=9, numports=2, external_ports=(1,))
    # 3. 制御とデータ生成を行うスレッド
    dram_addr = m.TmpReg(64, initval=0, prefix='dram_addr')
    spm_addr = m.TmpReg(64, initval=0, prefix='spm_addr')
    direction = m.TmpReg(64, initval=0, prefix='direction')
    destination = m.TmpReg(64, initval=0, prefix='destination')
    size = m.TmpReg(64, initval=0, prefix='size')
    status = m.TmpReg(64, initval=0, prefix='status')

    tmp_data = m.TmpReg(128, initval=0, prefix='tmp_data')
    tmp_data_2 = m.TmpReg(64, initval=0, prefix='tmp_data_2')
    def spm():
        while True:
            # --- 制御レジスタの読み込み ---
            # print("Waiting for START signal...")
            saxi.wait_flag(SPM_START,1) # START信号待ち
            dram_addr.value = saxi.read(SPM_DRAM_ADDR)
            spm_addr.value = saxi.read(SPM_LOCAL_ADDR)
            size.value = saxi.read(SPM_SIZE)
            direction.value = saxi.read(SPM_DIRECTION)
            destination.value = saxi.read(SPM_DESTINATION)
            saxi.write(SPM_STATUS, 1) # BUSYフラグセット
            # print("SPM operation: dram_addr=%x, spm_addr=%x, size=%d, direction=%d, destination=%d" % (dram_addr.value, spm_addr.value, size.value, direction.value, destination.value))
            # --- SPM操作 ---
            # DRAM
            if destination.value == 1:
                if direction.value == 0:
                    d_axim.dma_read(spm_ram,global_addr=dram_addr.value, local_addr=spm_addr.value // 8, local_size=size.value // 8,port=0)
                else :
                    # print("DMA Write to DRAM from SPM")
                    # for i in range(8):
                    #     tmp_data_2.value = spm_ram.read(spm_addr.value // 8 + i,port=0)
                    #     print(" write data %d: %x" % (i, tmp_data_2.value))
                    d_axim.dma_write(spm_ram,global_addr=dram_addr.value, local_addr=spm_addr.value // 8, local_size=8,port=0)
            # MAC
            elif destination.value == 2:
                if direction.value == 1:
                    m_axi_stream_out.dma_write(spm_ram,local_addr=spm_addr.value // 8,size=8,port=0)
                    # for i in range(8):
                    #     tmp_data_2.value = spm_ram.read(spm_addr.value // 8 + i,port=0)
                    #     print(" MAC data %d: %x" % (i, tmp_data_2.value))
            # AXI-Manager
            elif destination.value == 4:
                if direction.value == 0:
                    a_axi_stream_in.dma_read_async(spm_ram, local_addr=spm_addr.value // 8, size=8,port=0)
                else :
                    a_axi_stream_out.dma_write_async(spm_ram, local_addr = spm_addr.value // 8, size=8,port=0)
            elif destination.value == 8:
                if direction.value == 0:
                    x_axi_stream_in.dma_read(spm_ram, local_addr=spm_addr.value // 8, size=8,port=0)
                else :
                    x_axi_stream_out.dma_write_async(spm_ram, local_addr = spm_addr.value // 8, size=8,port=0)
            else :
                pass
            saxi.write(SPM_START, 0) # STARTビットクリア
            saxi.write(SPM_STATUS, 0) # BUSYフラグクリア
            # print("SPM operation completed")
    th = vthread.Thread(m, 'spm_thread', clk, rst, spm)
    fsm = th.start()
    return m

def mkTest(memimg_name=None):
    m = Module('test_spm')

    # target instance
    led = mkSMP()

    # copy paras and ports
    params = m.copy_params(led)
    ports = m.copy_sim_ports(led)

    clk = ports['CLK']
    rst = ports['RST']

    maxi = vthread.AXIMLite(m, 'maxi_spm', clk, rst, 64,addrwidth=32,noio=True)
    stream_in = vthread.AXIStreamIn(m, 's_axis_spm', clk, rst, datawidth=128, with_last=True, noio=True)
    stream_out = vthread.AXIStreamOut(m, 'm_axis_spm', clk, rst, datawidth=128, with_last=True, noio=True)
    maxi.connect(ports, 'axi_s_ctrl_spm')
    stream_in.connect(ports, 'axis_out_mac_spm')
    stream_out.connect(ports, 'axis_in_axim_spm')
    read_data = m.TmpReg(128, initval=0, prefix='read_data')
    memory = axi.AxiMemoryModel(m, 'memory', clk, rst, memimg_name=memimg_name,datawidth=64)
    memory.connect(ports, 'axi_m_dram')
    write_data = m.TmpReg(128, initval=0, prefix='write_data')
    complete = m.Reg("complete",1, initval=0)
    # data = m.TmpReg(128, initval=0, prefix='data')
    def ctrl():
        # AXI Managerからdma_readするように設定
        while(1):
            if (maxi.read(status_reg*8) == 0):
                break
            pass
        print("DMA Read from AXI Manager")
        maxi.write(SPM_DRAM_ADDR*8,0) # DRAM Address
        maxi.write(SPM_LOCAL_ADDR*8,0) # Local Address
        maxi.write(SPM_SIZE*8,4) # Size
        maxi.write(SPM_DIRECTION*8,0) # Direction: extern -> spm
        maxi.write(SPM_DESTINATION*8,4) # Destination: AXI Manager
        maxi.write(SPM_START*8,1) # Start
        for i in range(4):
            write_data.value = i + 0x1000 + (i << 32) + (i << 64) + (i << 96)
            stream_out.write(write_data.value, last=(i==3))
        while(1):
            if (maxi.read(SPM_STATUS*8) == 0):
                break
            pass
        # SPMからDRAMへdma_writeするように設定
        print("DMA Write to DRAM")
        maxi.write(SPM_DRAM_ADDR*8,0x1000) # DRAM Address
        maxi.write(SPM_LOCAL_ADDR*8,0) # Local Address
        maxi.write(SPM_SIZE*8,4) # Size
        maxi.write(SPM_DIRECTION*8,1) # Direction: spm -> extern
        maxi.write(SPM_DESTINATION*8,1) # Destination: DRAM
        maxi.write(SPM_START*8,1) # Start
        while(1):
            if (maxi.read(SPM_STATUS*8) == 0):
                break
            pass
        print("DMA Write to DRAM completed")
        complete.value = 1
        # print("DMA Read from AXI Manager completed")

    th = vthread.Thread(m, 'th_ctrl', clk, rst, ctrl)
    th.start()

    fsm = FSM(m, 'fsm', clk, rst)
    fsm.goto_next()
    fsm.If(complete == 1).goto_next()
    data = memory.read(fsm,0x1000)
    fsm(Systask('display', "memory[0x1000] = %x", data))
    data2 = memory.read(fsm,0x1004)
    fsm(Systask('display', "memory[0x1004] = %x", data2))
    data3 = memory.read(fsm,0x1008)
    fsm(Systask('display', "memory[0x1008] = %x", data3))
    data4 = memory.read(fsm,0x103c)
    fsm(Systask('display', "memory[0x100c] = %x", data4))
    # data = memory.read(fsm,0x1010)
    fsm.goto_next()

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
    rslt = run(filename='../verilog/spm.v')
    print(rslt)