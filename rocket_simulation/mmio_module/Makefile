# ===== ユーザ設定 =====
TOP       ?= TestHarness
PREFIX    ?= VTestHarness

# 生成済み Verilog のリスト
FILELIST  ?= build/filelist.f

# elaborate.dest と plusArgs
ELAB_DIR  ?= /home/ozaki/rocket/rocket-chip/out/emulator/freechips.rocketchip.system.TestHarness/freechips.rocketchip.system.DefaultSmallConfig128mmio/generator/elaborate.dest
CONFIG    ?= freechips.rocketchip.system.DefaultSmallConfig128mmio
PLUSARGS  ?= $(ELAB_DIR)/$(CONFIG).plusArgs

# Spike/fesvr
SPIKE_ROOT ?= $(RISCV)

# 補助C++ソース
CSRC_DIR  ?= /home/ozaki/rocket/rocket-chip/src/main/resources/csrc
CSRC      ?= $(CSRC_DIR)/SimDTM.cc \
             $(CSRC_DIR)/SimJTAG.cc \
             $(CSRC_DIR)/debug_rob.cc \
             $(CSRC_DIR)/emulator.cc \
             $(CSRC_DIR)/remote_bitbang.cc \

# 追加Verilog include が要ればここ
VSRC_DIR  ?= /home/ozaki/rocket/rocket-chip/src/main/resources/vsrc

# ツール
VERILATOR ?= verilator
VERILATOR_ROOT=/usr/local/share/verilator
CXX       ?= clang++
CC        ?= clang

# 出力
BUILDDIR  ?= build/emu
OBJDIR    := $(BUILDDIR)/obj_dir
BIN       := $(BUILDDIR)/emulator

# ===== 共通フラグ =====
CPPFLAGS  := -I$(CSRC_DIR) -I$(ELAB_DIR) -I$(SPIKE_ROOT)/include -I$(VERILATOR_ROOT)/include -I$(VERILATOR_ROOT)/include/vltstd
CXXFLAGS  := -O3 -std=gnu++17 -isystem /usr/include/c++/13 \
             -DVERILATOR -DTEST_HARNESS=$(PREFIX) -DVM_TRACE=1 \
             -include VTestHarness.h -include verilator.h -include $(PLUSARGS)
LDFLAGS   := -L$(SPIKE_ROOT)/lib
LDLIBS    := -lfesvr -lstdc++ -lpthread

VERILATOR_ARGS := --top-module $(TOP) \
                  -f $(FILELIST) \
				  -j 16 \
				  -Wno-UNOPTTHREADS -Wno-STMTDLY -Wno-LATCH -Wno-WIDTH \
                  --trace --no-timing --x-assign unique \
                  --output-split 20000 --output-split-cfuncs 20000 \
                  --max-num-width 1048576 -I$(VSRC_DIR)

# ===== ルール =====
.PHONY: all clean run showcmd

all: $(BIN)

# 1) Verilator: Verilog -> C++生成（ライブラリ化は後で make）
$(OBJDIR)/$(PREFIX)__ALL.a: $(FILELIST)
	@mkdir -p $(OBJDIR)
	$(VERILATOR) --cc $(VERILATOR_ARGS) --Mdir $(OBJDIR) --prefix $(PREFIX)
	+$(MAKE) -C $(OBJDIR) -f V$(TOP).mk $(PREFIX)__ALL.a

# 2) C++補助ソースのビルド
$(OBJDIR)/%.o: $(CSRC_DIR)/%.cc | $(OBJDIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -I$(OBJDIR) -c $< -o $@

# 3) リンク
$(BIN): $(OBJDIR)/$(PREFIX)__ALL.a \
        $(patsubst $(CSRC_DIR)/%.cc,$(OBJDIR)/%.o,$(CSRC))
	@mkdir -p $(BUILDDIR)
	$(CXX) -o $@ $(patsubst $(CSRC_DIR)/%.cc,$(OBJDIR)/%.o,$(CSRC)) \
	  $(OBJDIR)/$(PREFIX)__ALL.a $(LDFLAGS) $(LDLIBS)

run: all
	LD_LIBRARY_PATH=$(SPIKE_ROOT)/lib:$$LD_LIBRARY_PATH $(BIN)

clean:
	rm -rf $(BUILDDIR)

showcmd:
	@echo "CXXFLAGS = $(CXXFLAGS)"
	@echo "CPPFLAGS = $(CPPFLAGS)"
	@echo "VERILATOR_ARGS = $(VERILATOR_ARGS)"
