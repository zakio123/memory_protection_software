#pragma once
#include "memory_map.hpp"
#include "dram.hpp"
#include "spm.hpp"
#include <iostream>
#include <vector>

class DmaController {
public:
    DmaController(Dram& dram, Spm& spm) : m_dram(dram), m_spm(spm) {}

    void writeReg(uint32_t offset, uint32_t value) {
        switch (offset) {
            case MemoryMap::DmaReg::DRAM_ADDR: m_dram_addr = value; break;
            case MemoryMap::DmaReg::SPM_ADDR:  m_spm_addr = value; break;
            case MemoryMap::DmaReg::SIZE:      m_size = value; break;
            case MemoryMap::DmaReg::DIRECTION: m_direction = value; break;
            case MemoryMap::DmaReg::START:
                if (value == 1 && m_status == 0) {
                    m_status = 1;
                    executeDmaTransfer();
                }
                break;
        }
    }

    uint32_t readReg(uint32_t offset) {
        return (offset == MemoryMap::DmaReg::START) ? m_status : 0;
    }

private:
    void executeDmaTransfer() {
        std::cout << "  HW (DMA): Transfer started.\n";
        std::vector<uint8_t> buffer(m_size);

        if (m_direction == 0) { // DRAM -> SPM
            m_dram.read(m_dram_addr, buffer.data(), m_size);
            m_spm.write(m_spm_addr, buffer.data(), m_size);
        } else { // SPM -> DRAM
            m_spm.read(m_spm_addr, buffer.data(), m_size);
            m_dram.write(m_dram_addr, buffer.data(), m_size);
        }

        std::cout << "  HW (DMA): Transfer finished.\n";
        m_status = 0;
    }

    Dram& m_dram;
    Spm& m_spm;

    uint32_t m_dram_addr = 0, m_spm_addr = 0, m_size = 0, m_direction = 0, m_status = 0;
};