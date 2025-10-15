#!/bin/bash

# エラーが発生したらスクリプトを終了する
set -e

# --- 設定項目 ---
# 各ディレクトリへのパス
TOP_DIR="/home/ozaki/rocket/rocket-chip/mmio_project/rocket_simulation/mmio_module"
BUILD_DIR="build"
# トップモジュール名
TOP_MODULE_WRAPPER="top"

# ステップ1: veriloggenでVerilogを生成
rm -rf ${TOP_DIR}/out
python "src/main.py"


# ステップ2: ビルドディレクトリを作成し、全Verilogファイルのリストを作成
echo "📑 Step 2: Creating file list for Verilator..."
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}

# Rocket Chipの全Verilogファイルを追加
find "${TOP_DIR}/verilog/" -name "*v" > "${BUILD_DIR}/filelist.f"

# # veriloggenで生成したラッパーモジュールを追加
echo "${TOP_DIR}/out/top.v" >> "${BUILD_DIR}/filelist.f"

echo "File list created at ${BUILD_DIR}/filelist.f"

# ステップ3: Verilatorを実行
echo "⏳ Step 3: Running Verilator..."
verilator \
    --cc \
    --exe \
    -j 16 \
    --build \
    --top-module ${TOP_MODULE_WRAPPER} \
    -f "${BUILD_DIR}/filelist.f" \
    "${TOP_DIR}/out/sim.cpp" \
    --trace \
    -O3 \
    -Wno-WIDTHEXPAND \
    -Wno-WIDTH \
    -Wno-WIDTHTRUNC \
    -Wno-STMTDLY \
    -Wno-UNOPTFLAT \
    -Wno-LATCH \
    --output-split 20000 \
    --x-assign unique

# # 成果物は ./obj_dir ディレクトリに生成されます。

echo "✅ Verilator build complete. Executable is in ./obj_dir/"

# ステップ4: シミュレーションを実行
echo "🏁 Step 4: Running the simulation..."
./obj_dir/V${TOP_MODULE_WRAPPER}

echo "🎉 All steps completed successfully!"
echo "Generated waveform file: waveform.vcd"