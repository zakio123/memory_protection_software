#!/bin/bash

# エラーが発生したらスクリプトを終了する
set -e

# --- 設定項目 ---
# 各ディレクトリへのパス
TOP_DIR="/home/ozaki/rocket/rocket-chip/mmio_project/rocket_simulation/mmio_module"
ROCKET_DIR="/home/ozaki/rocket/rocket-chip/out/emulator/freechips.rocketchip.system.TestHarness/freechips.rocketchip.system.DefaultSmallConfig128mmio/mfccompiler/compile.dest"
BUILD_DIR="build"
# トップモジュール名
TOP_MODULE_WRAPPER="TestHarness"

# ステップ1: veriloggenでVerilogを生成
# python "src/main.py"


# ステップ2: ビルドディレクトリを作成し、全Verilogファイルのリストを作成
echo "📑 Step 2: Creating file list for Verilator..."
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}

# Rocket Chipの全Verilogファイルを追加
find "${ROCKET_DIR}" -name "*v" > "${BUILD_DIR}/filelist.f"

# # veriloggenで生成したラッパーモジュールを追加
echo "${TOP_DIR}/verilog/double.v" >> "${BUILD_DIR}/filelist.f"

echo "File list created at ${BUILD_DIR}/filelist.f"

# ステップ3: Verilatorを実行
# echo "clang compile"
# clang \
#     -isystem /usr/include/c++/13  \
#     -DVERILATOR  \
#     -DTEST_HARNESS=VTestHarness \
#     -DVM_TRACE=1 \
#     -include VTestHarness.h \
#     -include verilator.h 


echo "⏳ Step 3: Running Verilator..."
verilator \
    --cc \
    --exe \
    -j 16 \
    --build \
    --top-module ${TOP_MODULE_WRAPPER} \
    -f "${BUILD_DIR}/filelist.f" \
    "/home/ozaki/rocket/rocket-chip/src/main/resources/csrc/emulator_double.cc" \
    --trace \
    -O3 \
    --CFLAGS "\
        -isystem /usr/include/c++/13  \
        -DVERILATOR  \
        -DTEST_HARNESS=VTestHarness \
        -DVM_TRACE=1 \
        -include VTestHarness.h \
        -include /home/ozaki/rocket/rocket-chip/out/emulator/freechips.rocketchip.system.TestHarness/freechips.rocketchip.system.DefaultSmallConfig128mmio/generator/elaborate.dest/freechips.rocketchip.system.DefaultSmallConfig128mmio.plusArgs \
    "\
    --CFLAGS "-I/home/ozaki/rocket/rocket-chip/tools/rv64gc/include" \
    -Wno-WIDTHEXPAND \
    -Wno-WIDTH \
    -Wno-WIDTHTRUNC \
    -Wno-STMTDLY \
    -Wno-UNOPTFLAT \
    -Wno-LATCH \
    --output-split 20000 \
    --x-assign unique \
    -I/home/ozaki/rocket/rocket-chip/src/main/resources/vsrc \
    --output-split-cfuncs 20000 \
    --max-num-width 1048576 \
    -Wno-UNOPTTHREADS \

# # 成果物は ./obj_dir ディレクトリに生成されます。

echo "✅ Verilator build complete. Executable is in ./obj_dir/"

# ステップ4: シミュレーションを実行
echo "🏁 Step 4: Running the simulation..."

echo "🎉 All steps completed successfully!"
echo "Generated waveform file: waveform.vcd"