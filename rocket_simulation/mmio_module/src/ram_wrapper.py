# 複数のMMIOモジュールを使用する場合のmain.pyの例

import os
import sys
from veriloggen import *
import veriloggen as vg
import veriloggen.thread as vthread
import veriloggen.types.axi as axi
from mmio_map import *

verilog_code = """
module ram_spm
(
  input CLK,
  input [9-1:0] ram_spm_0_addr,
  output [64-1:0] ram_spm_0_rdata,
  input [64-1:0] ram_spm_0_wdata,
  input ram_spm_0_wenable,
  input ram_spm_0_enable,
  input [9-1:0] ram_spm_1_addr,
  output [64-1:0] ram_spm_1_rdata,
  input [64-1:0] ram_spm_1_wdata,
  input ram_spm_1_wenable,
  input ram_spm_1_enable
);

  reg [64-1:0] ram_spm_0_rdata_out;
  assign ram_spm_0_rdata = ram_spm_0_rdata_out;
  reg [64-1:0] ram_spm_1_rdata_out;
  assign ram_spm_1_rdata = ram_spm_1_rdata_out;
  reg [64-1:0] mem [0:512-1];

  always @(posedge CLK) begin
    if(ram_spm_0_enable) begin
      if(ram_spm_0_wenable) begin
        mem[ram_spm_0_addr] <= ram_spm_0_wdata;
        ram_spm_0_rdata_out <= ram_spm_0_wdata; // Write-through
      end else begin
        ram_spm_0_rdata_out <= mem[ram_spm_0_addr];
      end
    end 
  end

  always @(posedge CLK) begin
    if(ram_spm_1_enable) begin
      if(ram_spm_1_wenable) begin
        mem[ram_spm_1_addr] <= ram_spm_1_wdata;
        ram_spm_1_rdata_out <= ram_spm_1_wdata; // Write-through
      end else begin
        ram_spm_1_rdata_out <= mem[ram_spm_1_addr];
      end
    end 
  end

endmodule
"""



def main(memimg=None):
    m = Module('wrapper')
    clk = m.Input('CLK')
    rst = m.Input('RST')
    # SPM
    axi_s_spm_data = axi.AxiLiteSlave(m,"axi_s_spm_data", clk, rst, 64, addrwidth=32, noio=False)
    read_data = m.Wire("ram_spm_1_rdata", width=64)
    rdata_reg = m.Reg("rdata_reg", width=64, initval=0)
    write_data = m.Reg("ram_spm_1_wdata", width=64, initval=0)
    addr_reg = m.Reg("ram_spm_1_addr", width=64, initval=0)
    wenable = m.Reg("ram_spm_1_wenable", width=1, initval=0)
    enable = m.Reg("ram_spm_1_enable", width=1, initval=0)
    modules = from_verilog.read_verilog_module_str(verilog_code)
    ram = modules['ram_spm']
    ports = (
        ("CLK", clk),  # clk は clk のまま
        ("ram_spm_1_addr", addr_reg),  # addr は addr のまま
        ("ram_spm_1_wdata", write_data),  # wdata は write
        ("ram_spm_1_wenable", wenable),  # wenable は wenable のまま
        ("ram_spm_1_enable", enable),  # enable は enable のまま
        ("ram_spm_1_rdata", read_data),  # rdata は read_data のまま
    )
    m.Instance(ram,"inst_ram", ports=ports)
    fsm = FSM(m, 'fsm', clk, rst)
    fsm.goto_next()
    addr, readvalid, writevalid = axi_s_spm_data.pull_request(cond=fsm)
    fsm(addr_reg(addr // 8))
    fsm.If(readvalid)(wenable(0), enable(1))
    fsm.If(readvalid).goto(100)
    fsm.If(writevalid).goto(200)

    # readリクエストの処理
    fsm.set_index(100)
    fsm(enable(0), wenable(0), addr_reg(0)).goto_next()
    fsm(rdata_reg(read_data)).goto_next()
    ack = axi_s_spm_data.push_read_data(rdata_reg, cond=fsm)
    fsm.If(ack).goto_init()
    # writeリクエストの処理
    fsm.set_index(200)
    data, mask,valid = axi_s_spm_data.pull_write_data(cond=fsm)
    fsm(write_data(data),wenable(1), enable(1))
    fsm.If(valid).goto_next()
    # fsm(Systask("display", "Write request received:  data=%d", ( data)))
    # fsm(wenable(1), enable(1)).goto_next()
    fsm(wenable(0), enable(0), write_data(0), addr_reg(0)).goto_init()
    return m

def mktest():
    m = Module('test_mac')

    # target instance
    led = main()

    # copy paras and ports
    params = m.copy_params(led)
    ports = m.copy_sim_ports(led)

    clk = ports['CLK']
    rst = ports['RST']

    maxi = vthread.AXIMLite(m, 'maxi_mac', clk, rst, 64,addrwidth=32,noio=True)
    maxi.connect(ports, 'axi_s_spm_data')
    tmp = m.TmpReg(64, initval=0, prefix='tmp')
    def ctrl():
        for i in range(32):
            tmp.value = i * 2
            maxi.write(i*8, tmp.value)
            # print("write", i)
        for i in range(32):
            tmp.value = maxi.read(i*8)
            print("read", i, tmp.value)
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

    test = mktest()

    if filename is not None:
        test.to_verilog(filename)

    sim = simulation.Simulator(test, sim=simtype)
    rslt = sim.run(outputfile=outputfile)

    return rslt

if __name__ == '__main__':
    rslt = run(filename='../verilog/ram_spm.v')
    print(rslt)

    # print(verilog)
