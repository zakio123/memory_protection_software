#include "bus.hpp"
#include <iostream>
#include <string>
#include <vector>

void start_dma_and_wait(Bus& bus, uint32_t dram_addr, uint32_t spm_addr, uint32_t size, int direction) {
    bus.write32(MemoryMap::MMIO_BASE_ADDR + MemoryMap::DmaReg::DRAM_ADDR, dram_addr);
    bus.write32(MemoryMap::MMIO_BASE_ADDR + MemoryMap::DmaReg::SPM_ADDR, spm_addr);
    bus.write32(MemoryMap::MMIO_BASE_ADDR + MemoryMap::DmaReg::SIZE, size);
    bus.write32(MemoryMap::MMIO_BASE_ADDR + MemoryMap::DmaReg::DIRECTION, direction);
    bus.write32(MemoryMap::MMIO_BASE_ADDR + MemoryMap::DmaReg::START, 1);
    
    while (bus.read32(MemoryMap::MMIO_BASE_ADDR + MemoryMap::DmaReg::START) == 1) {}
    std::cout << "SW:   DMA operation completed.\n";
}

int main() {
    // 1. ハードウェアコンポーネントをインスタンス化
    Dram dram;
    Spm spm;
    DmaController dma(dram, spm);
    Bus bus(dma, spm);

    // --- 2. テストシナリオ実行 ---
    std::cout << "\n--- Test 1: DRAM to SPM ---\n";
    const uint32_t dram_src_addr = 0x1000;
    const uint32_t spm_dest_addr = 0x100;
    const std::string original_data = "Hello from DRAM!";
    
    start_dma_and_wait(bus, dram_src_addr, spm_dest_addr, original_data.length() + 1, 0);

    // SPMから読み出して検証
    std::vector<char> spm_buffer(original_data.length() + 1);
    uint32_t word;
    for (size_t i = 0; i < spm_buffer.size(); i += 4) {
        word = bus.read32(MemoryMap::SPM_BASE_ADDR + spm_dest_addr + i);
        std::memcpy(spm_buffer.data() + i, &word, std::min(4ul, spm_buffer.size() - i));
    }
    std::cout << "SW:   Read from SPM: \"" << spm_buffer.data() << "\"\n";

    // ...以降のテストシナリオも同様に実装...
    std::cout << "\n--- Test 2: SPM to DRAM ---\n";
    const uint32_t spm_src_addr = 0x200;
    const uint32_t dram_dest_addr = 0x2000;
    const std::string spm_data = "Data from SPM!";
    for (size_t i = 0; i < spm_data.length() + 1; i += 4) {
        word = 0;
        std::memcpy(&word, spm_data.data() + i, std::min(4ul, spm_data.length() + 1 - i));
        bus.write32(MemoryMap::SPM_BASE_ADDR + spm_src_addr + i, word);
    }
    start_dma_and_wait(bus, dram_dest_addr, spm_src_addr, spm_data.length() + 1, 1);

    // DRAMから読み出して検証
    std::vector<char> dram_buffer(spm_data.length() + 1);
    dram.read(dram_dest_addr, reinterpret_cast<uint8_t*>(dram_buffer.data()), spm_data.length() + 1);
    std::cout << "SW:   Read from DRAM: \"" << dram_buffer.data() << "\"\n";
    return 0;
}