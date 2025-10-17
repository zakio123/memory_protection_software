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
# 0x00 : Status;
# 0x08 : REQ_ADDR (64bit)
# 0x10 : REQ_ID (64bit)
# 0x18 : SPM_ADDR (64bit)
# 0x20 : Command  (64bit)
# 0x28 : BUSY (read only) (64bit)
### ------------------------
def mkAXIManager():
    """
    AXI-Lite Slaveで制御し、AES-CTR OTPを計算して
    AXI-Streamで出力するモジュール
    4つのインターフェースを持つ
    1. 制御用 AXI-Lite Slave (64bit幅)
    2. SPM用 AXI stream in (128bit幅)
    3. SPM用 AXI stream out (128bit幅)
    4. AES用 AXI stream in
    5. 外部から来るAXI slave
    """
    m = vg.Module('axim')
    clk = m.Input('CLK')
    rst = m.Input('RST')

    # --- インターフェース定義 ---
    # 1. 制御用 AXI-Lite Slave (64bit幅)
    saxi = vthread.AXISLiteRegister(m, 'axi_s_ctrl_axim', clk, rst, datawidth=64, length=6)
    # 2. SPM用　AXI stream in (128bit幅)
    spm_stream_in = vthread.AXIStreamIn(m, 'axis_in_axim', clk, rst, datawidth=128)
    # 3. SPM用 AXI stream out (128bit幅)
    spm_stream_out = vthread.AXIStreamOut(m, 'axis_out_axim', clk, rst, datawidth=128)
    # 5. 外部から来るAXI slave
    llc_saxi = axi.AxiSlave(m, 'axi_s_llc', clk, rst, datawidth=128, addrwidth=32)

    # spm_ram = vthread.RAM(m, 'ram_spm', clk, rst, datawidth=64, addrwidth=____, numports=2, external_ports=(1,))
    # 3. 制御とデータ生成を行うスレッド
    req_addr = m.Reg('req_addr',64, initval=0)
    req_id = m.Reg('req_id',64, initval=0)
    req_accept = m.Reg('req_accept',64, initval=0)
    is_write = m.Reg('is_write',64, initval=0)
    req_complete = m.Reg('req_complete',64, initval=0)
    write_data = m.Reg('write_data',128,dims=4, initval=0)
    read_data = m.Reg('read_data',128,dims=4, initval=0)
    counter = m.Reg('counter',64, initval=0)

    m_status = m.TmpReg(64, initval=0, prefix='status')

    th_status = m.TmpReg(64, initval=0, prefix='th_status')
    tmp_data = m.TmpReg(128, initval=0, prefix='tmp_data')
    def axi_manager():
        while True:
            if th_status.value == 0:
                # --- 制御レジスタの読み込み ---
                # print("Waiting for request")
                req_complete.value = 0
                if req_accept != 0:
                    print("Request accepted: addr=%x id=%d write=%d" % (req_addr.value, req_id.value, is_write.value))
                    m_status.value = is_write << 1 | req_accept.value
                    saxi.write(AXIM_STATUS, m_status.value) # Status
                    saxi.write(AXIM_REQ_ADDR, req_addr.value) # REQ_ADDR
                    req_complete.value = 0
                    th_status.value = 1
            elif th_status.value == 1:
                # コマンドを受け付ける
                print("Waiting for command")
                while(1):
                    if saxi.read(AXIM_COMMAND) != 0:
                        break
                    pass
                saxi.write(AXIM_BUSY, 1) # BUSYフラグセット
                if saxi.read(AXIM_COMMAND) == 1:
                    # w data をSPMに書き込む
                    for i in range(4):
                        # print("Writing data %d: %x" % (i, write_data[i].value))
                        spm_stream_out.write(write_data[i].value, last=(i==3))
                elif saxi.read(AXIM_COMMAND) == 16:
                    #  read レスポンス
                    # print("Reading data from SPM")
                    for i in range(4):
                        read_data[i].value = spm_stream_in.read()[0]
                        print("Reading data %d: %x" % (i, read_data[i].value))
                    req_complete.value = 1
                    th_status.value = 2
                elif saxi.read(AXIM_COMMAND) == 32:
                    # write レスポンス
                    req_complete.value = 1
                    th_status.value = 2
                else :
                    print("Unknown command: %d" % saxi.read(AXIM_COMMAND))
                saxi.write(AXIM_COMMAND, 0) # Commandビットクリア
                saxi.write(AXIM_BUSY, 0) # BUSYビットクリア
            elif th_status.value == 2:
                if req_accept == 0:
                    th_status.value = 0
                    req_complete.value = 0
                    m_status.value = 0
                    saxi.write(AXIM_STATUS, m_status.value) # Status
                    saxi.write(AXIM_REQ_ADDR, 0) # REQ_ADDR
                    # req_addr.value = 0
                    # req_id.value = 0
                    # is_write.value = 0


    # スレッドをVerilogのステートマシンとして合成
    th = vthread.Thread(m, 'spm_thread', clk, rst,axi_manager)
    th.start()
    
    fsm = FSM(m, 'fsm', clk, rst)
    fsm.goto_next()
    addr, length,readvalid, writevalid = llc_saxi.pull_request(cond=fsm)
    fsm(req_addr(addr))
    fsm.If(writevalid)(is_write(1))
    fsm.If(writevalid).goto(200)
    fsm.If(readvalid).goto(100)
    # readリクエストの処理
    fsm.set_index(100)
    fsm(Systask('display', "Request received: addr=%x length=", (addr)))
    fsm(req_accept(1))
    fsm.goto_next()
    fsm.If((req_complete == 1),(th_status == 2)).goto_next()
    last = (counter == 3)
    ack = llc_saxi.push_read_data(read_data[counter], last=last,cond=fsm)
    fsm.If(ack)(counter(counter+1))
    fsm.If(ack, counter == 3).goto_next()
    fsm(req_accept(0),is_write(0), counter(0),req_addr(0),req_id(0))
    fsm.If(th_status == 0).goto_next()
    fsm.goto_init()

    # writeリクエストの処理
    fsm.set_index(200)
    fsm(counter(0))
    fsm.goto_next()
    data,mask,valid,last = llc_saxi.pull_write_data(cond=fsm)
    fsm(write_data[counter](data))
    fsm.If(valid)(counter(counter+1))
    fsm.If(valid,last).goto_next()
    # fsm(Systask('display', "Write request received: addr=%x", (req_addr)))
    fsm(req_accept(1))
    fsm(is_write(1))
    fsm.goto_next()
    fsm.If((req_complete == 1),(th_status == 2)).goto_next()
    fsm(Systask('display', "Write completed"))
    fsm(req_accept(0),is_write(0), counter(0),req_addr(0),req_id(0))
    fsm.If(th_status == 0).goto_next()
    fsm.goto_init()

    return m

def mkTest(memimg_name=None):
    m = Module('test_axim')

    # target instance
    led = mkAXIManager()

    # copy paras and ports
    params = m.copy_params(led)
    ports = m.copy_sim_ports(led)

    clk = ports['CLK']
    rst = ports['RST']

    maxi = vthread.AXIMLite(m, 'maxi_axim', clk, rst, 64,addrwidth=32,noio=True)
    llc_maxi = axi.AxiMaster(m, 'llc_maxi_axim', clk, rst, datawidth=128, addrwidth=32, noio=True)
    stream_in = vthread.AXIStreamIn(m, 's_axis_axim', clk, rst, datawidth=128, with_last=True, noio=True)
    maxi.connect(ports, 'axi_s_ctrl_axim')
    stream_in.connect(ports, 'axis_out_axim')
    read_data = m.TmpReg(128, initval=0, prefix='read_data')
    llc_maxi.connect(ports, 'axi_s_llc')
    # data = m.TmpReg(128, initval=0, prefix='data')
    def ctrl():
        while(1):
            v = maxi.read(AXIM_STATUS*8)
            if v != 0:
                # print("Status: %x" % v)
                break
            pass
        # for i in range(4):
        #     read_data.value, last = stream_in.read()
        #     print("Received chunk %d: %x (last=%d)" % (i, read_data.value, last))
    th = vthread.Thread(m, 'th_ctrl', clk, rst, ctrl)
    th.start()

    fsm = FSM(m, 'fsm', clk, rst)
    fsm.goto_next()
    ack = llc_maxi.write_request(64, 4, cond=fsm)
    fsm.If(ack).goto_next()
    fsm.goto_next()
    ack = llc_maxi.write_data(0xbeef, last=0, cond=fsm)
    fsm.If(ack).goto_next()
    ack = llc_maxi.write_data(0xbeef, last=0, cond=fsm)
    fsm.If(ack).goto_next()
    ack = llc_maxi.write_data(0xbeef, last=0, cond=fsm)
    fsm.If(ack).goto_next()
    ack = llc_maxi.write_data(0xbeef, last=1, cond=fsm)
    fsm.If(ack).goto_next()
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
    rslt = run(filename='../verilog/axim.v',outputfile='axim.vcd')
    print(rslt)