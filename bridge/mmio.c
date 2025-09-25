#include "software_if.h"
#include "hardware_model.h"

void mmio_write(unsigned int addr, int value) {
    hardware_write_reg(addr, value);
}

int mmio_read(unsigned int addr) {
    return hardware_read_reg(addr);
}