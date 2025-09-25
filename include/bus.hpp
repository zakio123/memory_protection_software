#pragma once
#include "memory_map.hpp"
#include "dma_controller.hpp"
#include "spm.hpp"

class Bus {
public:
    Bus(DmaController& dma, Spm& spm) : m_dma(dma), m_spm(spm) {}

    void write32(uint32_t addr, uint32_t data) {
        if (addr >= MemoryMap::MMIO_BASE_ADDR && addr < MemoryMap::MMIO_BASE_ADDR + 0x1000) {
            m_dma.writeReg(addr - MemoryMap::MMIO_BASE_ADDR, data);
        } else if (addr >= MemoryMap::SPM_BASE_ADDR && addr < MemoryMap::SPM_BASE_ADDR + Spm::SPM_SIZE) {
            m_spm.write32(addr - MemoryMap::SPM_BASE_ADDR, data);
        }
    }

    uint32_t read32(uint32_t addr) {
        if (addr >= MemoryMap::MMIO_BASE_ADDR && addr < MemoryMap::MMIO_BASE_ADDR + 0x1000) {
            return m_dma.readReg(addr - MemoryMap::MMIO_BASE_ADDR);
        }
        if (addr >= MemoryMap::SPM_BASE_ADDR && addr < MemoryMap::SPM_BASE_ADDR + Spm::SPM_SIZE) {
            return m_spm.read32(addr - MemoryMap::SPM_BASE_ADDR);
        }
        return 0;
    }

private:
    DmaController& m_dma;
    Spm& m_spm;
};