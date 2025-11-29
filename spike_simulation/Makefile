# ===========================================
# RISC-V Toolchain
# ===========================================
RISCV ?= ../../tools/rv64gc
CC     = $(RISCV)/bin/riscv64-unknown-elf-gcc
CXX    = $(RISCV)/bin/riscv64-unknown-elf-g++
OBJDUMP= $(RISCV)/bin/riscv64-unknown-elf-objdump
OBJCOPY= $(RISCV)/bin/riscv64-unknown-elf-objcopy

# ===========================================
# Paths / Files
# ===========================================
COMMON_DIR  = /home/ozaki/rocket/rocket-chip/mmio_project/common
SPIKE_INC   = /home/ozaki/rocket/rocket-chip/mmio_project/spike_simulation/inc/
ENV_INC     = /home/ozaki/rocket/rocket-chip/tools/rv64gc/src/rocket-tools/riscv-tests/build/../benchmarks/../env
LDSCRIPT    = $(COMMON_DIR)/test.ld

C_SRCS      = $(COMMON_DIR)/syscalls.c $(COMMON_DIR)/crt.S
CPP_SRCS    = main.cpp

C_OBJS      = $(C_SRCS:.c=.o)
C_OBJS     := $(C_OBJS:.S=.o)
CPP_OBJS    = $(CPP_SRCS:.cpp=.o)

TARGET      = hello.elf

# ===========================================
# Compiler Flags
# ===========================================
CFLAGS = -I$(ENV_INC) -I$(COMMON_DIR) -DPREALLOCATE=1 \
         -mcmodel=medany -static -std=gnu99 -O2 -ffast-math \
         -fno-common -fno-builtin-printf -fno-tree-loop-distribute-patterns \
         -march=rv64gcv

CPPFLAGS = -I$(ENV_INC) -I$(COMMON_DIR) -I$(SPIKE_INC) -DPREALLOCATE=1 \
           -mcmodel=medany -static -std=gnu++17 -O2 -ffast-math \
           -fno-common -fno-builtin-printf -fno-tree-loop-distribute-patterns \
           -march=rv64gcv

LDFLAGS = -mcmodel=medany -static -nostdlib -nostartfiles \
          -T $(LDSCRIPT) -lm -lgcc

# ===========================================
# Rules
# ===========================================

all: $(TARGET)

# --- Compile C sources ---
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

# --- Compile C++ sources ---
%.o: %.cpp
	$(CXX) $(CPPFLAGS) -c $< -o $@

# --- Link ---
$(TARGET): $(C_OBJS) $(CPP_OBJS)
	$(CXX) $(C_OBJS) $(CPP_OBJS) $(LDFLAGS) -o $@

clean:
	rm -f $(TARGET) $(C_OBJS) $(CPP_OBJS)

dump:
	$(OBJDUMP) -d $(TARGET) | less

.PHONY: all clean dump
