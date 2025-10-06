RISCV_PREFIX ?= riscv64-unknown-elf-
SPIKE_INCLUDE_PATH ?= /home/ozaki/rocket/rocket-chip/tools/rv64gc/include

.PHONY: all clean

all: doubler_plugin.so main.elf

doubler_plugin.so: doubler_plugin.cpp
	g++ -shared -fPIC -I$(SPIKE_INCLUDE_PATH) $< -o $@

main.elf: main.c
	$(RISCV_PREFIX)gcc  -o $@  $<

clean:
	rm -f doubler_plugin.so main.elf