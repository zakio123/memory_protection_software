# ==========================================
# 設定: ディレクトリとツールチェーン
# ==========================================

# プロジェクトのルートパス (絶対パス)
PROJECT_ROOT := /home/ozaki/rocket/rocket-chip/

# コンパイラのパス (相対パスで指定されていたものをそのまま採用)
RISCV_TOOL_DIR := ../../../tools/rv64gc
CC_RISCV       := $(RISCV_TOOL_DIR)/bin/riscv64-unknown-elf-gcc
CXX_HOST       := g++

# ==========================================
# コンパイルオプション (ユーザー指定)
# ==========================================

# 1. 共通コンパイルフラグ (CFLAGS)
RISCV_CFLAGS := -mcmodel=medany -static -std=gnu99 -O3 -ffast-math \
                -fno-common -fno-builtin-printf -fno-tree-loop-distribute-patterns \
                -march=rv64gcv -DPREALLOCATE=1

# 2. インクルードパス (-I)
#    (既存の include/ と firmware/ に加えて、指定されたパスを追加)
RISCV_INCLUDES := -I$(PROJECT_ROOT)/tools/rv64gc/src/rocket-tools/riscv-tests/env \
                  -I$(PROJECT_ROOT)/mmio_project/common \
                  -I$(PROJECT_ROOT)/mmio_project/spike_simulation/inc/ \
				  -I$(PROJECT_ROOT)/mmio_project/spike_simulation/mmio_reg/ \
				  -I$(PROJECT_ROOT)/mmio_project/spike_simulation/metadata_controll/ \
				  -I$(PROJECT_ROOT)/mmio_project/spike_simulation/temp_extension/ 

# 3. 共通ソースファイル (syscalls.c, crt.S)
RISCV_COMMON_SRCS := $(PROJECT_ROOT)/mmio_project/common/syscalls.c \
                     $(PROJECT_ROOT)/mmio_project/common/crt.S

# 4. リンカフラグ (LDFLAGS / LIBS)
#    (-T でリンカスクリプトを指定、ライブラリをリンク)
RISCV_LDFLAGS := -static -nostdlib -nostartfiles \
                 -T $(PROJECT_ROOT)/mmio_project/common/test.ld \
                 -lm -lgcc

# ==========================================
# Spike拡張 (C++) 用設定
# ==========================================
# ここは変更なし (ホスト側の設定)
CXXFLAGS_EXT := -std=c++17 -fPIC -shared 

# ==========================================
# 出力ファイルとターゲット
# ==========================================
TARGET_FW  := firmware.elf

# ベンチマークのメインソース (firmware/ ディレクトリにある想定)
SRC_MAIN   := benchmark.c cache_manage.c

.PHONY: all clean run

all: $(TARGET_SO) $(TARGET_FW)

# # 1. Spike拡張ライブラリ (.so) のビルド
# $(TARGET_SO): $(SRC_EXT) include/tmx_encoding.h
# 	@echo "Building Spike Extension..."
# 	$(CXX_HOST) $(CXXFLAGS_EXT) -o $@ $(SRC_EXT)

# 2. RISC-Vファームウェア (.elf) のビルド
#    指定されたオプション、ソース、ライブラリを全て結合します
$(TARGET_FW): $(SRC_MAIN) $(RISCV_COMMON_SRCS) 
	@echo "Building Firmware..."
	$(CC_RISCV) $(RISCV_CFLAGS) $(RISCV_INCLUDES) \
		-o $@ \
		$(SRC_MAIN) $(RISCV_COMMON_SRCS) \
		$(RISCV_LDFLAGS)

# 3. 実行
#    -nostdlib環境では pk なしで動く場合もありますが、
#    syscalls.c をリンクしているので pk 経由で動かす想定のままとします。
# run: all
# 	@echo "Running Simulation..."
# 	export LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):. && \

# クリーンアップ
clean:
	rm -f $(TARGET_SO) $(TARGET_FW)