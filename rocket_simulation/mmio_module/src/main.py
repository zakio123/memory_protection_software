# 複数のMMIOモジュールを使用する場合のmain.pyの例

import os
import sys
from veriloggen import *
import veriloggen as vg
import veriloggen.thread as vthread
import veriloggen.types.axi as axi
from mmio_map import *
import numpy as np

protection_size = 1024 * 1024 * 64 # 64MB
tag_base = protection_size
tag_size = protection_size // 8 # 8MB
counter_size = protection_size // 32 # 2MB
counter_base = tag_base + tag_size
HEIGHT = 4

SPM_DATA_SIZE = 64 * 64 # 64line * 64B
SPM_CTRL_SIZE = 0x1000
MAC_CTRL_SIZE = 0x1000
AES_CTRL_SIZE = 0x1000
AXIM_CTRL_SIZE = 0x1000
XOR_CTRL_SIZE = 0x1000
MEMREQ_CTRL_SIZE = 0x1000

MMIO_BASE = 0x6000_0000
SPM_DATA_BOUND = SPM_DATA_SIZE
SPM_CTRL_BASE = SPM_DATA_SIZE
SPM_CTRL_BOUND = SPM_DATA_BOUND + SPM_CTRL_SIZE
MAC_CTRL_BASE = SPM_CTRL_BASE + SPM_CTRL_SIZE
MAC_CTRL_BOUND = SPM_CTRL_BOUND + MAC_CTRL_SIZE
AES_CTRL_BASE = MAC_CTRL_BASE + MAC_CTRL_SIZE
AES_CTRL_BOUND = MAC_CTRL_BOUND + AES_CTRL_SIZE
AXIM_CTRL_BASE = AES_CTRL_BASE + AES_CTRL_SIZE
AXIM_CTRL_BOUND = AES_CTRL_BOUND + AXIM_CTRL_SIZE
XOR_CTRL_BASE = AXIM_CTRL_BASE + AXIM_CTRL_SIZE
XOR_CTRL_BOUND = AXIM_CTRL_BOUND + XOR_CTRL_SIZE
MEMREQ_CTRL_BOUND = XOR_CTRL_BOUND + MEMREQ_CTRL_SIZE

def height_base(height):
    h = HEIGHT - height
    base = counter_base
    for i in range(h):
        base += counter_size // (2 ** (5*i))
    return base

def lcg_random(x,N=1024):
    a = 1664525
    c = 1013904223
    x = (a * x + c) % N
    return x % N

def main(memimg_name=None):
    m = Module('top')
    current_dir = os.path.dirname(os.path.abspath(__file__))
    wrapper_dir = os.path.join(current_dir, 'wrapper.v')
    modules = from_verilog.read_verilog_module(wrapper_dir)
    wrapper = modules['wrapper']
    ports = m.copy_sim_ports(wrapper) 
    clk = ports['CLK']
    rst = ports['RST']
    # 必要なaxislave Masterポートを生成
    # SPM
    maxi_ctrl_spm = vthread.AXIMLite(m,"axi_m_ctrl_spm", clk, rst, 64, addrwidth=32, noio=True)
    maxi_ctrl_spm.connect(ports, 'axi_s_ctrl_spm')
    maxi_spm_data = vthread.AXIMLite(m,"axi_m_spm_data", clk, rst, 64, addrwidth=32, noio=True)
    maxi_spm_data.connect(ports, 'axi_s_spm_data')
    # MAC
    maxi_ctrl_mac = vthread.AXIMLite(m,"axi_m_ctrl_mac", clk, rst, 64, addrwidth=32, noio=True)
    maxi_ctrl_mac.connect(ports, 'axi_s_ctrl_mac')
    # XOR
    maxi_ctrl_xor = vthread.AXIMLite(m,"axi_m_ctrl_xor", clk, rst, 64, addrwidth=32, noio=True)
    maxi_ctrl_xor.connect(ports, 'axi_s_ctrl_xor')
    # AES
    maxi_ctrl_aes = vthread.AXIMLite(m,"axi_m_ctrl_aes", clk, rst, 64, addrwidth=32, noio=True)
    maxi_ctrl_aes.connect(ports, 'axi_s_ctrl_aes')
    # AXIManager
    maxi_ctrl_axim = vthread.AXIMLite(m,"axi_m_ctrl_axim", clk, rst, 64, addrwidth=32, noio=True)
    maxi_ctrl_axim.connect(ports, 'axi_s_ctrl_axim')
    # 仮想メモリインスタンス
    # myaxi = vthread.AXIM(m, 'myaxi', clk, rst, 128, addrwidth=32, noio=True)
    memory = axi.AxiMemoryModel(m, 'v_memory', clk, rst, memimg_name=memimg_name,datawidth=128,mem_addrwidth=27)
    memory.connect(ports, 'axi_m_dram')
    


    tmp = m.Reg('tmp',64, initval=0)
    read_spm_data = m.TmpReg(64, initval=0, prefix='read_spm_data')
    req_addr = m.TmpReg(64, initval=0, prefix='req_addr')
    is_write = m.TmpReg(1, initval=0, prefix='is_write')
    tag = m.TmpReg(64, initval=0, prefix='tag')
    expected_tag = m.TmpReg(64, initval=0, prefix='expected_tag')
    tag_blockaddr = m.TmpReg(64, initval=0, prefix='tag_blockaddr')
    tag_spm_addr = m.TmpReg(64, initval=0, prefix='tag_spm_addr')
    line_info = m.TmpReg(64, initval=0, prefix='line_info')
    current_block_addr = m.TmpReg(64, initval=0, prefix='current_block_addr')
    valid = m.TmpReg(1, initval=0, prefix='valid')
    dirty = m.TmpReg(1, initval=0, prefix='dirty')
    seed_low = m.TmpReg(64, initval=0, prefix='seed_low')
    seed_high = m.TmpReg(64, initval=0, prefix='seed_high')
    counter_blockaddr = m.TmpReg(64,initval=0, prefix='counter_blockaddr')
    major_counter = m.TmpReg(64,initval=0, prefix='major_counter')
    minor_counters = m.TmpReg(64,initval=0, prefix='minor_counters')
    minor_counter = m.TmpReg(64,initval=0, prefix='minor_counter')
    minor_counter_bitoffset = m.TmpReg(64,initval=0, prefix='minor_counter_bitoffset') 
    counter_index = m.TmpReg(64,initval=0, prefix='counter_index')
    height = m.TmpReg(64,initval=0, prefix='height')

    spm_dram_addr = m.TmpReg(64,initval=0, prefix='spm_dram_addr')
    spm_local_addr = m.TmpReg(64,initval=0, prefix='spm_local_addr')
    spm_manage_addr = m.TmpReg(64,initval=0, prefix='spm_manage_addr')

    tmp_addr = m.TmpReg(64,initval=0, prefix='tmp_addr')
    def spm_request(size, direction, destination):
        maxi_ctrl_spm.write(SPM_DRAM_ADDR*8, spm_dram_addr.value)
        maxi_ctrl_spm.write(SPM_LOCAL_ADDR*8, spm_local_addr.value)
        maxi_ctrl_spm.write(SPM_SIZE*8, size)
        maxi_ctrl_spm.write(SPM_DIRECTION*8, direction)
        maxi_ctrl_spm.write(SPM_DESTINATION*8, destination)
        maxi_ctrl_spm.write(SPM_START*8, 1) # Start
        while(1):
            if (maxi_ctrl_spm.read(SPM_STATUS*8) == 0):
                break
            pass

    def ensureBlockAddr():
        line_info.value = maxi_spm_data.read(spm_manage_addr.value)
        valid.value = line_info & 1
        dirty.value = (line_info >> 1) & 1
        current_block_addr.value = (line_info >> 6) << 6
        # print(" Ensuring block addr: %x (current: %x valid: %d dirty: %d)" % (spm_dram_addr.value, current_block_addr.value, valid.value, dirty.value))
        if ((valid.value == 0) | current_block_addr != spm_dram_addr.value):
            # Dirtyビットが立っていれば、現在のブロックをDRAMに書き戻す
            tmp_addr.value = spm_dram_addr.value
            if (valid.value == 1 & dirty.value == 1) :
                spm_dram_addr.value = current_block_addr.value
                spm_request(64, direction=1, destination=1); # direction=0: spm->dram, destination=1: DRAM
            spm_dram_addr.value = tmp_addr.value
            spm_request(64, direction=0, destination=1); # direction=1: dram->spm, destination=0: SPM
            # 管理情報を更新 (Valid=1, Dirty=0)
            line_info.value = (spm_dram_addr.value) | 1
            maxi_spm_data.write(spm_manage_addr.value, line_info.value)
    
    def setblockdirty(manage_addr):
        line_info.value = maxi_spm_data.read(manage_addr)
        line_info.value = line_info.value | 3 # dirtyビットを立てる
        maxi_spm_data.write(manage_addr, line_info.value) 

    def set_seed():
        print(" Setting AES seed major: %x minor: %x" % (major_counter.value, minor_counter.value))
        seed_low.value = req_addr.value + (minor_counter.value << 3)
        seed_high.value = major_counter.value + req_addr.value
        for i in range(4):
            maxi_ctrl_aes.write(AES_INPUT_0*8 + i*16, seed_low.value + i * 16)
            maxi_ctrl_aes.write(AES_INPUT_1*8 + i*16, seed_high.value + (i+1) * 16)
        maxi_ctrl_aes.write(AES_START*8, 1) # Command: START
        while(1):
            if (maxi_ctrl_aes.read(AES_START*8) == 0):
                break
            pass
          
    def mac_init():
        maxi_ctrl_mac.write(MAC_COMMAND*8, 1) # Command: INIT
        while(1):
            if (maxi_ctrl_mac.read(MAC_STATUS*8) == 0):
                break
            pass

    def mac_buffer_set():
        # SPMからMACへデータを送るように設定
        spm_request( size=8, direction=1, destination=2) # direction=1: spm->extern, destination=2: MAC

    def mac_update(start_bit, end_bit):
        maxi_ctrl_mac.write(MAC_START_BIT*8, start_bit) # Start bit
        maxi_ctrl_mac.write(MAC_END_BIT*8, end_bit) # End bit
        maxi_ctrl_mac.write(MAC_COMMAND*8, 2) # Clear end bit
        while(1):
            if (maxi_ctrl_mac.read(MAC_STATUS*8) == 0):
                break
            pass

    def mac_digest():
        maxi_ctrl_mac.write(MAC_COMMAND*8,4) # Command: CALC
        while(1):
            if (maxi_ctrl_mac.read(MAC_STATUS*8) == 0):
                break
            pass
        tag.value = maxi_ctrl_mac.read(MAC_RESULT*8)

    
    def tree_verify_one_level():
        # 1階層分の検証
        # height.valueとcounter_index.valueを使って、そのブロックを検証する。
        # その階層のcounterブロックを読み込む
        counter_index.value = (req_addr.value // 64) // (2 ** (5 * (HEIGHT - height.value)))
        spm_dram_addr.value = counter_blockaddr.value + (counter_index.value // 32) * 64
        minor_counter_bitoffset.value = (counter_index.value % 32) * 8 + 64
        spm_local_addr.value = 64 * (2 + height.value)
        spm_manage_addr.value = 56 * 64 + (2 + height.value) * 8
        ensureBlockAddr()
        # macの生成
        mac_init()
        mac_buffer_set()
        mac_update(0,447)
        # 上位のカウンターを読み込む
        spm_local_addr.value = 64 * (2 + height.value - 1)
        mac_buffer_set()
        if height.value == 1:
            mac_update(0,63)
        else :
            tmp.value = (counter_index.value // 32) % 32 * 8 + 64
            mac_update(64 + tmp.value, tmp.value + 7)
        mac_digest()
        spm_local_addr.value = 64 * (2 + height.value)
        expected_tag.value = maxi_spm_data.read(spm_local_addr.value + 448 // 8)
        if height.value < HEIGHT:
            counter_blockaddr.value = counter_blockaddr.value + 64 * (2 ** (5 * (height.value - 1)))
        height.value = height.value + 1
        print("  Verified level %d: expected tag %x, calculated tag %x" % (height.value - 1, expected_tag.value, tag.value))
        # return (tag.value == expected_tag.value)

    def tree_authenticate_one_level():
        # height.valueとcounter_index.valueを使って、そのブロックを検証する。
        # その階層のcounterブロックを読み込む
        counter_index.value = (req_addr.value // 64) // (2 ** (5 * (HEIGHT - height.value)))
        spm_dram_addr.value = counter_blockaddr.value + (counter_index.value // 32) * 64
        minor_counter_bitoffset.value = (counter_index.value % 32) * 8 + 64
        spm_local_addr.value = 64 * (2 + height.value)
        spm_manage_addr.value = 56 * 64 + (2 + height.value) * 8
        ensureBlockAddr()
        # minor_counterをインクリメントして保存
        minor_counters.value = maxi_spm_data.read(spm_local_addr.value + (minor_counter_bitoffset.value // 8))
        minor_counter.value = (minor_counters.value >> (minor_counter_bitoffset.value % 64)) & 0xff
        minor_counter.value = minor_counter.value + 1
        minor_counters.value = (minor_counters.value & (~(0xff << (minor_counter_bitoffset.value % 64)))) | (minor_counter.value << (minor_counter_bitoffset.value % 64))
        maxi_spm_data.write(spm_local_addr.value + (minor_counter_bitoffset.value // 8), minor_counters.value)
        setblockdirty(56 * 64 + (2 + height.value) * 8)
        # macの生成
        mac_init()
        spm_local_addr.value = 64 * (2 + height.value)
        mac_buffer_set()
        mac_update(0,447)
        # 上位のカウンターを読み込む
        spm_local_addr.value = 64 * (2 + height.value - 1)
        mac_buffer_set()
        if height.value == 1:
            mac_update(0,63)
        else :
            tmp.value = (counter_index.value // 32) % 32 * 8 + 64
            mac_update(64 + tmp.value, tmp.value + 7)
        mac_digest()
        spm_local_addr.value = 64 * (2 + height.value)
        maxi_spm_data.write(spm_local_addr.value + 448 // 8, tag.value)
        setblockdirty(56 * 64 + (2 + height.value) * 8)
        if height.value < HEIGHT:
            counter_blockaddr.value = counter_blockaddr.value + 64 * (2 ** (5 * (height.value - 1)))
        height.value = height.value + 1
        
    def authentication():
        for i in range(HEIGHT-1):
            counter_blockaddr.value = counter_blockaddr.value + 64 * (2 ** (5 * i))
        minor_counter_bitoffset.value = 64 + ( ( (req_addr.value // 64) % 32) * 8)
        spm_dram_addr.value = counter_blockaddr.value
        spm_local_addr.value = 64 * 6
        ensureBlockAddr()
        major_minor_counter_load()
        if major_counter.value != 0 or minor_counter.value != 0:
            counter_blockaddr.value = counter_base
            height.value = 1
            for i in range(HEIGHT):
                tree_verify_one_level()
                if tag.value != expected_tag.value:
                    print(" Authentication failed at height %d" % (i+1))
                    
            print(" Authentication succeeded")
        counter_blockaddr.value = counter_base
        height.value = 1
        for i in range(HEIGHT):
            tree_authenticate_one_level()
        ensureBlockAddr()
        major_minor_counter_load()
        # AXI MからSPMへデータをコピー
        # SPMからリクエストを作る
        spm_dram_addr.value = 0
        spm_local_addr.value = 0
        spm_request(direction=0, size=64, destination=4)
        # AXIMへデータを返すように指示
        maxi_ctrl_axim.write(AXIM_COMMAND * 8,1)
        while(1):
            if (maxi_ctrl_axim.read(AXIM_BUSY*8) == 0):
                break
            pass
        # AESのシードを設定
        set_seed()
        # # 平文をXORに転送
        spm_dram_addr.value = 0
        spm_local_addr.value = 0
        spm_request(direction=1, size=64, destination=8)
        maxi_ctrl_xor.write(XOR_START*8, 1) # Start
        while(1):
            if (maxi_ctrl_xor.read(XOR_START*8) == 0):
                break
            pass
        # XOR結果をSPMに保存
        spm_dram_addr.value = 0
        spm_local_addr.value = 0
        spm_request(direction=0, size=64, destination=8)
        # データタグを計算
        mac_init()
        spm_local_addr.value = 0
        mac_buffer_set() # SPMの先頭アドレスにデータ
        mac_update(0, 447) # 64バイト
        spm_local_addr.value = 64 * 3
        mac_buffer_set()
        mac_update(minor_counter_bitoffset.value, minor_counter_bitoffset.value + 7)
        mac_digest()
        tag.value = maxi_ctrl_mac.read(MAC_RESULT*8)
        print(" Tag: %x" % tag.value)
        # タグのブロックアドレスを計算
        spm_dram_addr.value = tag_blockaddr.value
        spm_local_addr.value = 64
        spm_manage_addr.value = 56 * 64 + 2 * 8
        ensureBlockAddr()
        # タグをSPMに保存
        tag_spm_addr.value = 64 + ((req_addr.value // 64) % 8) * 8
        maxi_spm_data.write(tag_spm_addr.value, tag.value)
        setblockdirty(56 * 64 + 2 * 8)
        spm_dram_addr.value = req_addr.value
        spm_local_addr.value = 0
        spm_request(direction=1, size=64, destination=1) # DRAM <- SPM
        maxi_ctrl_axim.write(AXIM_COMMAND * 8,32)
        while(1):
            if (maxi_ctrl_axim.read(AXIM_BUSY*8) == 0):
                break
            pass
        print(" Write completed")

    def major_minor_counter_load():
        # spm_dram_addr.value = counter_blockaddr.value
        # spm_local_addr.value = 64 * 3
        # spm_manage_addr.value = 56 * 64 + 3 * 8
        # ensureBlockAddr()
        major_counter.value = maxi_spm_data.read(spm_local_addr.value + 0)
        minor_counters.value = (maxi_spm_data.read(spm_local_addr.value + (minor_counter_bitoffset.value // 8)))
        minor_counter.value = (minor_counters.value >> (minor_counter_bitoffset.value % 64)) & 0xff

    def verification():
        for i in range(HEIGHT):
            tree_verify_one_level()
            if (tag.value != expected_tag.value):
                print(" Verification failed at height %d" % (i+1))
        print(" Verification succeeded")
        counter_blockaddr.value = counter_base
        for i in range(HEIGHT-1):
            counter_blockaddr.value = counter_blockaddr.value + 64 * (2 ** (5 * i))
        minor_counter_bitoffset.value = 64 + ( ( (req_addr.value // 64) % 32) * 8)
        spm_dram_addr.value = counter_blockaddr.value
        spm_local_addr.value = 64 * 6
        ensureBlockAddr()
        major_minor_counter_load()
        print("Major counter: %d, minor counter: %d, spm_addr: %d" % (major_counter.value, minor_counter.value, spm_local_addr.value))
        # SPMへデータを読み込むように指示
        spm_dram_addr.value = req_addr.value
        spm_local_addr.value = 0
        spm_request(direction=0, size=64, destination=1) # DRAM -> SPM
        # tagを計算
        mac_init()
        spm_local_addr.value = 0
        mac_buffer_set() # SPMの先頭アドレスにデータ
        mac_update(0, 447) # 64バイト
        spm_local_addr.value = 64 * 3
        mac_buffer_set()
        mac_update(minor_counter_bitoffset.value, minor_counter_bitoffset.value + 7)
        mac_digest()
        tag.value = maxi_ctrl_mac.read(MAC_RESULT*8)
        print(" Tag: %x" % tag.value)
        spm_dram_addr.value = tag_blockaddr.value
        spm_local_addr.value = 164
        spm_manage_addr.value = 56 * 64 + 2 * 8
        ensureBlockAddr()
        # SPMからタグを読み出し
        expected_tag.value = maxi_spm_data.read(64 + ((req_addr.value // 64) % 8) * 8)
        if (tag.value != expected_tag.value):
            print(" Tag mismatch! expected=%x" % expected_tag.value)
        set_seed()
        # XORへデータを転送
        spm_dram_addr.value = 0
        spm_local_addr.value = 0
        spm_request(direction=1, size=64, destination=8)
        while(1):
            if (maxi_ctrl_spm.read(SPM_STATUS*8) == 0):
                break
            pass
        maxi_ctrl_xor.write(XOR_START*8, 1) # Start
        while(1):
            if (maxi_ctrl_xor.read(XOR_START*8) == 0):
                break
            pass
        # 結果をSPMに保存s
        spm_dram_addr.value = 0
        spm_local_addr.value = 0
        spm_request(direction=0, size=64, destination=8)
        while(1):
            if (maxi_ctrl_spm.read(SPM_STATUS*8) == 0):
                break
            pass

        # SPMからAXI Mへデータを返すように指示
        spm_dram_addr.value = 0
        spm_local_addr.value = 0
        spm_request(direction=1, size=64, destination=4)
        while(1):
            if (maxi_ctrl_spm.read(SPM_STATUS*8) == 0):
                break
            pass
        maxi_ctrl_axim.write(AXIM_COMMAND * 8,16)
        while(1):
            if (maxi_ctrl_axim.read(AXIM_BUSY*8) == 0):
                break
            pass
        print(" Read completed")

    def ctrl():
        # AXI リクエストを送信
        # ---- SPMの構成 64line*64B ----
        # 0 : 暗号文/平文
        # 1 : MACデータ
        # 2 : height 0 counter(root)
        # 3 : height 1 counter
        # 4 : height 2 counter
        # 5 : height 3 counter
        # 6 : height 4 counter(for encryption)

        # 56-63 : タグ (8line*64B = 8B(per line) * 64line = 512B )
        for i in range(512):
            maxi_spm_data.write(i * 8, 0)
        for i in range(counter_size // 64):
            spm_dram_addr.value = counter_base + i * 64
            spm_local_addr.value = 0
            spm_request(direction=1, size=64, destination=1) # DRAM -> SPM
        while(1):
            while(1):
                if (maxi_ctrl_axim.read(AXIM_STATUS*8) != 0):
                    break
                pass
            req_addr.value = maxi_ctrl_axim.read(AXIM_REQ_ADDR*8)
            is_write.value = (maxi_ctrl_axim.read(AXIM_STATUS*8) >> 1) & 1
            tag_blockaddr.value = (req_addr.value // 512) * 64 + tag_base
            counter_blockaddr.value = counter_base
            minor_counter_bitoffset.value = 64 + ((req_addr.value // 64) % 32) * 8
            height.value = 1
            print("Request received: addr=%x write=%d tag_blockaddr=%x counter_blockaddr=%x minor_counter_bitoffset=%d" % (req_addr.value, is_write.value, tag_blockaddr.value, counter_blockaddr.value, minor_counter_bitoffset.value))
            if is_write.value == 1:
                # カウンターを作る
                authentication()
            else :
                verification()


    th_ctrl = vthread.Thread(m, 'ctrl_thread', clk, rst, ctrl)
    th_ctrl.start()
    # AXI Master
    llc_requester = vthread.AXIM(m, 'llc_requester', clk, rst, datawidth=128, addrwidth=32, noio=True)
    llc_requester.connect(ports, 'axi_s_llc')
    request_ram = vthread.RAM(m, 'request_ram', clk, rst, 128, addrwidth=12)
    receive_ram = vthread.RAM(m, 'receive_ram', clk, rst, 128, addrwidth=12)
    # LLCへデータを書き込むテスト
    read_llc_data = m.TmpReg(128, initval=0, prefix='read_llc_data')
    def make_request():
        # データを作る
        for i in range(4096):
            request_ram.write(i, i)
        for i in range(1024):
            llc_requester.dma_write(request_ram, global_addr=i * 64,local_size=4,local_addr=i*4)
        for i in range(512, 1024):
            llc_requester.dma_write(request_ram, global_addr=i * 64,local_size=4,local_addr=i*4)
        llc_requester.dma_write(request_ram, global_addr=16*64,local_size=4,local_addr=16*4)
        # random_addr_list = np.random.permutation(256)
        # print("Random read address:")
        for i in range(1024):
            llc_requester.dma_read(request_ram, global_addr=i * 64, local_size=4, local_addr=i*4)
        for i in range(256):
            read_llc_data.value = request_ram.read(i)
            if read_llc_data.value != i:
                print("LLC data mismatch %d: %x" % (i, read_llc_data.value))
        print("LLC read/write completed")
    th_request = vthread.Thread(m, 'request_thread', clk, rst, make_request)
    th_request.start()

    m.Instance(wrapper, 'uut',
               params=m.connect_params(wrapper),
               ports=m.connect_ports(wrapper))

    vcd_name = os.path.splitext(os.path.basename(__file__))[0] + '.vcd'
    # simulation.setup_waveform(m, wrapper, dumpfile=vcd_name)
    simulation.setup_clock(m, clk, hperiod=5)
    init = simulation.setup_reset(m, rst, m.make_reset(), period=100)

    init.add(
        Delay(2000000),
        Systask('finish'),
    )
    return m

def slave_bridge():
    m = Module('bridge')
    clk = m.Input('CLK')
    rst = m.Input('RST')
    current_dir = os.path.dirname(os.path.abspath(__file__))
    wrapper_dir = os.path.join(current_dir, 'wrapper.v')
    modules = from_verilog.read_verilog_module(wrapper_dir)
    wrapper = modules['wrapper']
    axi_includes = (
    r'CLK', r'RST',               # クロック・リセット
    r'axi_m_dram_*',                      # AXI4 master #0
    r'axi_s_llc_*',                       # AXI4 slave #0
    )
    # bridge = slave_bridge()
    ports = m.copy_sim_ports(wrapper,exclude=axi_includes)
    # clk = ports['CLK']
    # rst = ports['RST']

    # 必要なaxislave Masterポートを生成
    # SPM
    maxi_ctrl_spm = vthread.AXIMLite(m,"axi_m_ctrl_spm", clk, rst, 64, addrwidth=32, noio=True)
    maxi_ctrl_spm.connect(ports, 'axi_s_ctrl_spm')
    maxi_spm_data = vthread.AXIMLite(m,"axi_m_spm_data", clk, rst, 64, addrwidth=32, noio=True)
    maxi_spm_data.connect(ports, 'axi_s_spm_data')
    # MAC
    maxi_ctrl_mac = vthread.AXIMLite(m,"axi_m_ctrl_mac", clk, rst, 64, addrwidth=32, noio=True)
    maxi_ctrl_mac.connect(ports, 'axi_s_ctrl_mac')
    # XOR
    maxi_ctrl_xor = vthread.AXIMLite(m,"axi_m_ctrl_xor", clk, rst, 64, addrwidth=32, noio=True)
    maxi_ctrl_xor.connect(ports, 'axi_s_ctrl_xor')
    # AES
    maxi_ctrl_aes = vthread.AXIMLite(m,"axi_m_ctrl_aes", clk, rst, 64, addrwidth=32, noio=True)
    maxi_ctrl_aes.connect(ports, 'axi_s_ctrl_aes')
    # AXIManager
    maxi_ctrl_axim = vthread.AXIMLite(m,"axi_m_ctrl_axim", clk, rst, 64, addrwidth=32, noio=True)
    maxi_ctrl_axim.connect(ports, 'axi_s_ctrl_axim')
    # rocket coreからのリクエストを受け取る
    saxi_bridge = axi.AxiSlave(m,'axi_s_bridge', clk, rst, datawidth=64, addrwidth=32,waddr_id_width=4, wdata_id_width=4, wresp_id_width=4,
                 raddr_id_width=4, rdata_id_width=4,)
    out_ports = m.copy_ports(wrapper, include=axi_includes,use_fullmatch=False)
    uut = m.Instance(wrapper, 'uut',
                    params=m.connect_params(wrapper),
                    ports=m.connect_ports(wrapper))
    
    addr_reg = m.Reg('addr_reg', 64, initval=0)
    is_write = m.Reg('is_write', 1, initval=0)
    request_valid = m.Reg('request_valid', 1, initval=0)
    write_data = m.Reg('write_data', 64, initval=0)
    read_data = m.Reg('read_data', 64, initval=0)
    status = m.TmpReg(64, initval=0, prefix='status')
    request_complete = m.TmpReg( 1, initval=0, prefix='request_complete')
    def mkBridge():
        while(1):
            if status.value == 0:            
                if request_valid == 1:
                    if addr_reg < SPM_DATA_BOUND:
                        # print(" Accessing SPM data addr: %x data : %x" % (addr_reg, write_data.value))
                        if is_write == 1:
                            maxi_spm_data.write(addr_reg, write_data.value)
                        else :
                            read_data.value = maxi_spm_data.read(addr_reg)
                    elif addr_reg < SPM_CTRL_BOUND:
                        if is_write == 1:
                            maxi_ctrl_spm.write(addr_reg - SPM_DATA_BOUND, write_data)
                        else :
                            read_data.value = maxi_ctrl_spm.read(addr_reg - SPM_DATA_BOUND)
                    elif addr_reg < MAC_CTRL_BOUND:
                        if is_write == 1:
                            maxi_ctrl_mac.write(addr_reg - SPM_CTRL_BOUND, write_data)
                        else :
                            read_data.value = maxi_ctrl_mac.read(addr_reg - SPM_CTRL_BOUND)
                    elif addr_reg < AES_CTRL_BOUND:
                        if is_write == 1:
                            maxi_ctrl_aes.write(addr_reg - MAC_CTRL_BOUND, write_data)
                        else :
                            read_data.value = maxi_ctrl_aes.read(addr_reg - MAC_CTRL_BOUND)
                    elif addr_reg < AXIM_CTRL_BOUND:
                        if is_write == 1:
                            maxi_ctrl_axim.write(addr_reg - AES_CTRL_BOUND, write_data)
                        else :
                            read_data.value = maxi_ctrl_axim.read(addr_reg - AES_CTRL_BOUND)
                    elif addr_reg < XOR_CTRL_BOUND:
                        if is_write == 1:
                            maxi_ctrl_xor.write(addr_reg - AXIM_CTRL_BOUND, write_data)
                        else :
                            read_data.value = maxi_ctrl_xor.read(addr_reg - AXIM_CTRL_BOUND)
                    # elif addr_reg < MEMREQ_CTRL_BOUND:
                    else :
                        print(" Invalid address: %x" % addr_reg)
                    request_complete.value = 1
                    status.value = 1
                else :
                    pass
            elif status.value == 1:
                if (request_valid == 0):
                    request_complete.value = 0
                    status.value = 0
                else :
                    pass
        
    th_bridge = vthread.Thread(m, 'bridge_thread', clk, rst, mkBridge)
    th_bridge.start()

    fsm = FSM(m, 'fsm', clk, rst)
    fsm.goto_next()
    addr,length,readvalid,writevalid = saxi_bridge.pull_request(cond=fsm)
    fsm(addr_reg(addr))
    fsm.If(writevalid)(is_write(1))
    fsm.If(readvalid)(is_write(0),request_valid(1))
    fsm.If(readvalid).goto(100)
    fsm.If(writevalid).goto(200)

    # readリクエスト
    fsm.set_index(100)
    fsm.goto_next()
    fsm.If(request_complete == 1).goto_next()
    ack = saxi_bridge.push_read_data(read_data,last=1, cond=fsm)
    fsm.If(ack).goto_next()
    fsm(request_valid(0))
    fsm.goto_next()
    fsm.If(status == 0).goto_next()
    fsm.goto_init()

    fsm.set_index(200)
    fsm.goto_next()
    data, mask, last,valid = saxi_bridge.pull_write_data(cond=fsm)
    fsm(write_data(data))
    fsm.If(valid & last).goto_next()
    fsm(request_valid(1))
    fsm.goto_next()
    fsm.If(request_complete == 1).goto_next()
    fsm(request_valid(0))
    fsm.If(status == 0).goto_next()
    fsm.goto_init()
    return m

def bridge_main(memimg_name=None):
    m = Module('top')
    bridge = slave_bridge()
    ports = m.copy_sim_ports(bridge)
    params = m.copy_params(bridge)

    clk = ports['CLK']
    rst = ports['RST']
    axi_m_bridge = vthread.AXIM(m, 'axi_m_bridge', clk, rst, datawidth=64, addrwidth=32, noio=True)
    axi_m_bridge.connect(ports, 'axi_s_bridge')
    memory = axi.AxiMemoryModel(m, 'v_memory', clk, rst, memimg_name=memimg_name,datawidth=128,mem_addrwidth=27)
    memory.connect(ports, 'axi_m_dram')

    tmp = m.Reg('tmp',64, initval=0)
    read_spm_data = m.TmpReg(64, initval=0, prefix='read_spm_data')
    req_addr = m.TmpReg(64, initval=0, prefix='req_addr')
    is_write = m.TmpReg(1, initval=0, prefix='is_write')
    tag = m.TmpReg(64, initval=0, prefix='tag')
    expected_tag = m.TmpReg(64, initval=0, prefix='expected_tag')
    tag_blockaddr = m.TmpReg(64, initval=0, prefix='tag_blockaddr')
    tag_spm_addr = m.TmpReg(64, initval=0, prefix='tag_spm_addr')
    line_info = m.TmpReg(64, initval=0, prefix='line_info')
    current_block_addr = m.TmpReg(64, initval=0, prefix='current_block_addr')
    valid = m.TmpReg(1, initval=0, prefix='valid')
    dirty = m.TmpReg(1, initval=0, prefix='dirty')
    seed_low = m.TmpReg(64, initval=0, prefix='seed_low')
    seed_high = m.TmpReg(64, initval=0, prefix='seed_high')
    counter_blockaddr = m.TmpReg(64,initval=0, prefix='counter_blockaddr')
    major_counter = m.TmpReg(64,initval=0, prefix='major_counter')
    minor_counters = m.TmpReg(64,initval=0, prefix='minor_counters')
    minor_counter = m.TmpReg(64,initval=0, prefix='minor_counter')
    minor_counter_bitoffset = m.TmpReg(64,initval=0, prefix='minor_counter_bitoffset') 
    counter_index = m.TmpReg(64,initval=0, prefix='counter_index')
    height = m.TmpReg(64,initval=0, prefix='height')
    spm_dram_addr = m.TmpReg(64,initval=0, prefix='spm_dram_addr')
    spm_local_addr = m.TmpReg(64,initval=0, prefix='spm_local_addr')
    spm_manage_addr = m.TmpReg(64,initval=0, prefix='spm_manage_addr')

    tmp_addr = m.TmpReg(64,initval=0, prefix='tmp_addr')
    def spm_request(size, direction, destination):
        axi_m_bridge.write(SPM_CTRL_BASE + SPM_DRAM_ADDR*8,spm_dram_addr.value) #maxi_ctrl_spm.write(SPM_DRAM_ADDR*8, spm_dram_addr.value)
        axi_m_bridge.write(SPM_CTRL_BASE + SPM_LOCAL_ADDR*8, spm_local_addr.value)
        axi_m_bridge.write(SPM_CTRL_BASE + SPM_SIZE*8, size)
        axi_m_bridge.write(SPM_CTRL_BASE + SPM_DIRECTION*8, direction)
        axi_m_bridge.write(SPM_CTRL_BASE + SPM_DESTINATION*8, destination)
        axi_m_bridge.write(SPM_CTRL_BASE + SPM_START*8, 1) # Start
        while(1):
            if (axi_m_bridge.read(SPM_CTRL_BASE + SPM_STATUS*8) == 0):
                break
            pass

    def ensureBlockAddr():
        spm_manage_addr.value = (spm_local_addr.value // 64) * 8 + 56 * 64
        line_info.value = axi_m_bridge.read(spm_manage_addr.value)
        valid.value = line_info & 1
        dirty.value = (line_info >> 1) & 1
        current_block_addr.value = (line_info >> 6) << 6
        # print(" Ensuring block addr: %x (current: %x valid: %d dirty: %d)" % (spm_dram_addr.value, current_block_addr.value, valid.value, dirty.value))
        if ((valid.value == 0) | current_block_addr != spm_dram_addr.value):
            # Dirtyビットが立っていれば、現在のブロックをDRAMに書き戻す
            tmp_addr.value = spm_dram_addr.value
            if (valid.value == 1 & dirty.value == 1) :
                spm_dram_addr.value = current_block_addr.value
                spm_request(64, direction=1, destination=1); # direction=0: spm->dram, destination=1: DRAM
            spm_dram_addr.value = tmp_addr.value
            spm_request(64, direction=0, destination=1); # direction=1: dram->spm, destination=0: SPM
            # 管理情報を更新 (Valid=1, Dirty=0)
            line_info.value = (spm_dram_addr.value) | 1
            axi_m_bridge.write(spm_manage_addr.value, line_info.value)
    
    def setblockdirty(manage_addr):
        line_info.value = axi_m_bridge.read(manage_addr)
        line_info.value = line_info.value | 3 # dirtyビットを立てる
        axi_m_bridge.write(manage_addr, line_info.value)

    def set_seed():
        print(" Setting AES seed major: %x minor: %x" % (major_counter.value, minor_counter.value))
        seed_low.value = req_addr.value + (minor_counter.value << 3)
        seed_high.value = major_counter.value + req_addr.value
        for i in range(4):
            axi_m_bridge.write(AES_CTRL_BASE + AES_INPUT_0*8 + i*16, seed_low.value + i * 16)
            axi_m_bridge.write(AES_CTRL_BASE + AES_INPUT_1*8 + i*16, seed_high.value + (i+1) * 16)
        axi_m_bridge.write(AES_CTRL_BASE + AES_START*8, 1) # Command: START
        while(1):
            if (axi_m_bridge.read(AES_CTRL_BASE + AES_START*8) == 0):
                break
            pass
          
    def mac_init():
        axi_m_bridge.write(MAC_CTRL_BASE + MAC_COMMAND*8, 1) # Command: INIT
        while(1):
            if (axi_m_bridge.read(MAC_CTRL_BASE + MAC_STATUS*8) == 0):
                break
            pass

    def mac_buffer_set():
        # SPMからMACへデータを送るように設定
        spm_request( size=8, direction=1, destination=2) # direction=1: spm->extern, destination=2: MAC

    def mac_update(start_bit, end_bit): 
        axi_m_bridge.write(MAC_CTRL_BASE + MAC_START_BIT*8, start_bit) # Start bit
        axi_m_bridge.write(MAC_CTRL_BASE + MAC_END_BIT*8, end_bit) # End bit
        axi_m_bridge.write(MAC_CTRL_BASE + MAC_COMMAND*8, 2) # Clear end bit
        while(1):
            if (axi_m_bridge.read(MAC_CTRL_BASE + MAC_STATUS*8) == 0):
                break
            pass

    def mac_digest():
        axi_m_bridge.write(MAC_CTRL_BASE + MAC_COMMAND*8,4) # Command: CALC
        while(1):
            if (axi_m_bridge.read(MAC_CTRL_BASE + MAC_STATUS*8) == 0):
                break
            pass
        tag.value = axi_m_bridge.read(MAC_CTRL_BASE + MAC_RESULT*8)

    def tree_verify_one_level():
        # 1階層分の検証
        # height.valueとcounter_index.valueを使って、そのブロックを検証する。
        # その階層のcounterブロックを読み込む
        counter_index.value = (req_addr.value // 64) // (2 ** (5 * (HEIGHT - height.value)))
        spm_dram_addr.value = counter_blockaddr.value + (counter_index.value // 32) * 64
        minor_counter_bitoffset.value = (counter_index.value % 32) * 8 + 64
        spm_local_addr.value = 64 * (2 + height.value)
        ensureBlockAddr()
        # macの生成
        mac_init()
        mac_buffer_set()
        mac_update(0,447)
        # 上位のカウンターを読み込む
        spm_local_addr.value = 64 * (2 + height.value - 1)
        mac_buffer_set()
        if height.value == 1:
            mac_update(0,63)
        else :
            tmp.value = (counter_index.value // 32) % 32 * 8 + 64
            mac_update(64 + tmp.value, tmp.value + 7)
        mac_digest()
        spm_local_addr.value = 64 * (2 + height.value)
        expected_tag.value = axi_m_bridge.read(spm_local_addr.value + 448 // 8)
        if height.value < HEIGHT:
            counter_blockaddr.value = counter_blockaddr.value + 64 * (2 ** (5 * (height.value - 1)))
        height.value = height.value + 1
        print("  Verified level %d: expected tag %x, calculated tag %x" % (height.value - 1, expected_tag.value, tag.value))
        # return (tag.value == expected_tag.value)

    def tree_authenticate_one_level():
        # height.valueとcounter_index.valueを使って、そのブロックを検証する。
        # その階層のcounterブロックを読み込む
        counter_index.value = (req_addr.value // 64) // (2 ** (5 * (HEIGHT - height.value)))
        spm_dram_addr.value = counter_blockaddr.value + (counter_index.value // 32) * 64
        minor_counter_bitoffset.value = (counter_index.value % 32) * 8 + 64
        spm_local_addr.value = 64 * (2 + height.value)
        ensureBlockAddr()
        # minor_counterをインクリメントして保存
        minor_counters.value = axi_m_bridge.read(spm_local_addr.value + (minor_counter_bitoffset.value // 8))
        minor_counter.value = (minor_counters.value >> (minor_counter_bitoffset.value % 64)) & 0xff
        minor_counter.value = minor_counter.value + 1
        minor_counters.value = (minor_counters.value & (~(0xff << (minor_counter_bitoffset.value % 64)))) | (minor_counter.value << (minor_counter_bitoffset.value % 64))
        axi_m_bridge.write(spm_local_addr.value + (minor_counter_bitoffset.value // 8), minor_counters.value)
        setblockdirty(56 * 64 + (2 + height.value) * 8)
        # macの生成
        mac_init()
        spm_local_addr.value = 64 * (2 + height.value)
        mac_buffer_set()
        mac_update(0,447)
        # 上位のカウンターを読み込む
        spm_local_addr.value = 64 * (2 + height.value - 1)
        mac_buffer_set()
        if height.value == 1:
            mac_update(0,63)
        else :
            tmp.value = (counter_index.value // 32) % 32 * 8 + 64
            mac_update(64 + tmp.value, tmp.value + 7)
        mac_digest()
        spm_local_addr.value = 64 * (2 + height.value)
        axi_m_bridge.write(spm_local_addr.value + 448 // 8, tag.value)
        setblockdirty(56 * 64 + (2 + height.value) * 8)
        if height.value < HEIGHT:
            counter_blockaddr.value = counter_blockaddr.value + 64 * (2 ** (5 * (height.value - 1)))
        height.value = height.value + 1
        
    def authentication():
        print(" Authentication started")
        for i in range(HEIGHT-1):
            counter_blockaddr.value = counter_blockaddr.value + 64 * (2 ** (5 * i))
        minor_counter_bitoffset.value = 64 + ( ( (req_addr.value // 64) % 32) * 8)
        spm_dram_addr.value = counter_blockaddr.value
        spm_local_addr.value = 64 * 6
        print(" Counter block addr: %x, minor counter bit offset: %d" % (counter_blockaddr.value, minor_counter_bitoffset.value))
        major_minor_counter_load()
        print(" Major counter: %d, minor counter: %d" % (major_counter.value, minor_counter.value))
        if major_counter.value != 0 or minor_counter.value != 0:
            counter_blockaddr.value = counter_base
            height.value = 1
            for i in range(HEIGHT):
                tree_verify_one_level()
                if tag.value != expected_tag.value:
                    print(" Authentication failed at height %d" % (i+1))
                    
            print(" Authentication succeeded")
        counter_blockaddr.value = counter_base
        height.value = 1
        for i in range(HEIGHT):
            tree_authenticate_one_level()
        major_minor_counter_load()
        # AXI MからSPMへデータをコピー
        # SPMからリクエストを作る
        spm_dram_addr.value = 0
        spm_local_addr.value = 0
        spm_request(direction=0, size=64, destination=4)
        # AXIMへデータを返すように指示
        axi_m_bridge.write(AXIM_CTRL_BASE + AXIM_COMMAND * 8,1)
        while(1):
            if (axi_m_bridge.read(AXIM_CTRL_BASE + AXIM_BUSY*8) == 0):
                break
            pass
        # AESのシードを設定
        set_seed()
        # # 平文をXORに転送
        spm_dram_addr.value = 0
        spm_local_addr.value = 0
        spm_request(direction=1, size=64, destination=8)
        axi_m_bridge.write(XOR_CTRL_BASE + XOR_START*8, 1) # Start
        while(1):
            if (axi_m_bridge.read(XOR_CTRL_BASE + XOR_START*8) == 0):
                break
            pass
        # XOR結果をSPMに保存
        spm_dram_addr.value = 0
        spm_local_addr.value = 0
        spm_request(direction=0, size=64, destination=8)
        # データタグを計算
        mac_init()
        spm_local_addr.value = 0
        mac_buffer_set() # SPMの先頭アドレスにデータ
        mac_update(0, 447) # 64バイト
        spm_local_addr.value = 64 * 6
        mac_buffer_set()
        mac_update(minor_counter_bitoffset.value, minor_counter_bitoffset.value + 7)
        mac_digest()
        tag.value = axi_m_bridge.read(MAC_CTRL_BASE + MAC_RESULT*8)
        print(" Tag: %x" % tag.value)
        # タグのブロックアドレスを計算
        spm_dram_addr.value = tag_blockaddr.value
        spm_local_addr.value = 64
        ensureBlockAddr()
        # タグをSPMに保存
        tag_spm_addr.value = 64 + ((req_addr.value // 64) % 8) * 8
        axi_m_bridge.write(tag_spm_addr.value, tag.value)
        setblockdirty(56 * 64 + 1 * 8)
        spm_dram_addr.value = req_addr.value
        spm_local_addr.value = 0
        spm_request(direction=1, size=64, destination=1) # DRAM <- SPM
        axi_m_bridge.write(AXIM_CTRL_BASE + AXIM_COMMAND * 8,32)
        while(1):
            if (axi_m_bridge.read(AXIM_CTRL_BASE + AXIM_BUSY*8) == 0):
                break
            pass
        print(" Write completed")

    def major_minor_counter_load():
        major_counter.value = axi_m_bridge.read(spm_local_addr.value + 0)
        minor_counters.value = (axi_m_bridge.read(spm_local_addr.value + (minor_counter_bitoffset.value // 8)))
        minor_counter.value = (minor_counters.value >> (minor_counter_bitoffset.value % 64)) & 0xff

    def verification():
        for i in range(HEIGHT):
            tree_verify_one_level()
            if (tag.value != expected_tag.value):
                print(" Verification failed at height %d" % (i+1))
        # print(" Verification succeeded")
        major_minor_counter_load()
        # print("Major counter: %d, minor counter: %d, spm_addr: %d" % (major_counter.value, minor_counter.value, spm_local_addr.value))
        # SPMへデータを読み込むように指示
        spm_dram_addr.value = req_addr.value
        spm_local_addr.value = 0
        spm_request(direction=0, size=64, destination=1) # DRAM -> SPM
        # tagを計算
        mac_init()
        spm_local_addr.value = 0
        mac_buffer_set() # SPMの先頭アドレスにデータ
        mac_update(0, 447) # 64バイト
        spm_local_addr.value = 64 * 6
        mac_buffer_set()
        mac_update(minor_counter_bitoffset.value, minor_counter_bitoffset.value + 7)
        mac_digest()
        tag.value = axi_m_bridge.read(MAC_CTRL_BASE + MAC_RESULT*8)
        print(" Tag: %x" % tag.value)
        spm_dram_addr.value = tag_blockaddr.value
        spm_local_addr.value = 64
        ensureBlockAddr()
        # SPMからタグを読み出し
        expected_tag.value = axi_m_bridge.read(64 + ((req_addr.value // 64) % 8) * 8)
        if (tag.value != expected_tag.value):
            print(" Tag mismatch! expected=%x" % expected_tag.value)
        set_seed()
        # XORへデータを転送
        spm_dram_addr.value = 0
        spm_local_addr.value = 0
        spm_request(direction=1, size=64, destination=8)
        while(1):
            if (axi_m_bridge.read(SPM_CTRL_BASE+SPM_STATUS*8) == 0):
                break
            pass
        axi_m_bridge.write(XOR_CTRL_BASE + XOR_START*8, 1) # Start
        while(1):
            if (axi_m_bridge.read(XOR_CTRL_BASE + XOR_START*8) == 0):
                break
            pass
        # 結果をSPMに保存
        spm_dram_addr.value = 0
        spm_local_addr.value = 0
        spm_request(direction=0, size=64, destination=8)
        while(1):
            if (axi_m_bridge.read(SPM_CTRL_BASE+SPM_STATUS*8) == 0):
                break
            pass

        # SPMからAXI Mへデータを返すように指示
        spm_dram_addr.value = 0
        spm_local_addr.value = 0
        spm_request(direction=1, size=64, destination=4)
        while(1):
            if (axi_m_bridge.read(SPM_CTRL_BASE+SPM_STATUS*8) == 0):
                break
            pass
        axi_m_bridge.write(AXIM_CTRL_BASE + AXIM_COMMAND * 8,16)
        while(1):
            if (axi_m_bridge.read(AXIM_CTRL_BASE + AXIM_BUSY*8) == 0):
                break
            pass
        print(" Read completed")

    def ctrl():
        # AXI リクエストを送信
        # ---- SPMの構成 64line*64B ----
        # 0 : 暗号文/平文
        # 1 : MACデータ
        # 2 : height 0 counter(root)
        # 3 : height 1 counter
        # 4 : height 2 counter
        # 5 : height 3 counter
        # 6 : height 4 counter(for encryption)

        # 56-63 : タグ (8line*64B = 8B(per line) * 64line = 512B )
        for i in range(512):
            axi_m_bridge.write(i * 8, 0)
        for i in range(counter_size // 64):
            spm_dram_addr.value = counter_base + i * 64
            spm_local_addr.value = 0
            spm_request(direction=1, size=64, destination=1) # DRAM -> SPM
        # axi_m_bridge.write(0,1)
        # b = axi_m_bridge.read(1024)
        # print("AXI read/write test: %x" % b)
        while(1):
            while(1):
                if (axi_m_bridge.read(AXIM_CTRL_BASE + AXIM_STATUS*8) != 0):
                    break
                pass
            req_addr.value = axi_m_bridge.read(AXIM_CTRL_BASE + AXIM_REQ_ADDR*8)
            is_write.value = (axi_m_bridge.read(AXIM_CTRL_BASE + AXIM_STATUS*8) >> 1) & 1
            tag_blockaddr.value = (req_addr.value // 512) * 64 + tag_base
            counter_blockaddr.value = counter_base
            minor_counter_bitoffset.value = 64 + ((req_addr.value // 64) % 32) * 8
            height.value = 1
            # print("Request received: addr=%x write=%d tag_blockaddr=%x counter_blockaddr=%x minor_counter_bitoffset=%d" % (req_addr.value, is_write.value, tag_blockaddr.value, counter_blockaddr.value, minor_counter_bitoffset.value))
            if is_write.value == 1:
                # カウンターを作る
                # print(" Write request")
                authentication()
            else :
                # print(" Read request")
                verification()

    th_ctrl = vthread.Thread(m, 'ctrl_thread', clk, rst, ctrl)
    th_ctrl.start()

    # LLC接続用ポートを生成
    llc_requester = vthread.AXIM(m, 'llc_requester', clk, rst, datawidth=128, addrwidth=32, noio=True)
    llc_requester.connect(ports, 'axi_s_llc')
    ram_addrwidth = 20
    request_ram = vthread.RAM(m, 'request_ram', clk, rst, 128, addrwidth=ram_addrwidth)
    receive_ram = vthread.RAM(m, 'receive_ram', clk, rst, 128, addrwidth=ram_addrwidth)
    # LLCへデータを書き込むテスト
    read_llc_data = m.TmpReg(128, initval=0, prefix='read_llc_data')
    a = m.TmpReg(64, initval=0, prefix='a')
    c = m.TmpReg(64, initval=0, prefix='c')
    N = m.TmpReg(64, initval=0, prefix='N')
    x = m.TmpReg(64, initval=0, prefix='x')
    y = m.TmpReg(64, initval=0, prefix='y')
    def lcg_random():
        # 0~N-1の乱数を生成
        y.value = (x.value * a.value + c.value) % N.value
    def make_request():
        # データを作る
        request_width = 14
        for i in range(2 ** request_width):
            request_ram.write(i, i*2)
        for i in range(2 ** request_width // 4):
            llc_requester.dma_write(request_ram, global_addr=i * 64,local_size=4,local_addr=i*4)
        a.value = 1664525
        c.value = 1013904223
        N.value = 2 ** request_width // 4
        for i in range(N.value):
            x.value = i
            lcg_random()
            print(" LLC write addr: %d" % (y.value))
            llc_requester.dma_read(receive_ram, global_addr=y.value * 64, local_size=4, local_addr=y.value * 4)
        for i in range(2 ** request_width):
            read_llc_data.value = receive_ram.read(i)
            if read_llc_data.value != i*2:
                print("LLC data mismatch %d: %x" % (i, read_llc_data.value))
        print("LLC read/write completed")
    th_request = vthread.Thread(m, 'request_thread', clk, rst, make_request)
    th_request.start()

    m.Instance(bridge, 'uut',
               params=m.connect_params(bridge),
               ports=m.connect_ports(bridge))

    vcd_name = os.path.splitext(os.path.basename(__file__))[0] + '.vcd'
    # simulation.setup_waveform(m, wrapper, dumpfile=vcd_name)
    simulation.setup_clock(m, clk, hperiod=5)
    init = simulation.setup_reset(m, rst, m.make_reset(), period=100)

    init.add(
        Delay(2000000),
        Systask('finish'),
    )
    return m

def run(filename="test.v", simtype="iverilog", outputfile=None):

    if outputfile is None:
        outputfile = os.path.splitext(os.path.basename(__file__))[0] + ".out"
    memimg_name = "memimg_" + outputfile
    bridge = bridge_main()
    if filename is not None:
        bridge.to_verilog(filename)
    simulation.to_verilator(
        top=bridge,
        objs=(bridge,),
        outputdir="out",
        verilog_prefix="top",  # 生成されるVerilogファイル名 (my_design.v)
        cpp_prefix="sim",  # 生成されるC++ファイル名 (my_sim.cpp)
    )
    return None

if __name__ == '__main__':
    # bridge = bridge_main()
    # bridge.to_verilog("bridge.v")
    run(filename="main.v")
    slave = slave_bridge()
    current_dir = os.path.dirname(os.path.abspath(__file__))
    bridge_dir = os.path.join(current_dir, '../verilog/bridge.v')
    slave.to_verilog(bridge_dir)