#!/bin/bash

# エラーが発生したら即停止
set -e

# --- デフォルト設定 ---
JSON_FILENAME="default.json"  # デフォルトのファイル名
OUTPUT_BIN="default.bin"        # 生成する実行バイナリ名
IMAGE_FILE="init_data.img"    # C++が出力するイメージファイル名

# --- 引数解析 (getopts) ---
# -j [filename] でjsonファイルを指定可能にする
while getopts "j:" opt; do
  case ${opt} in
    j)
      JSON_FILENAME="$OPTARG"
      ;;
    \?)
      echo "Usage: $0 [-j json_filename]"
      exit 1
      ;;
  esac
done

# --- パスの構築 ---
JSON_PATH="json/${JSON_FILENAME}"
PYTHON_SCRIPT="json/make_config.py"
INC_DIR="inc"

# --- 実行フロー ---

echo "=== 1. Generating Configuration ==="
# Pythonスクリプトを実行。JSONのパスを引数として渡す。
# ※Python側で inc/config.h を生成するように修正済み前提
if [ ! -f "$JSON_PATH" ]; then
    echo "Error: JSON file not found at $JSON_PATH"
    exit 1
fi
python3 "$PYTHON_SCRIPT" "$JSON_PATH"

echo "=== 2. Compiling C++ Code ==="
# -Iinc オプションで config.h の場所を教える
# -fopenmp はOpenMPを使用しているため必須
g++ -O3 -fopenmp -I"${INC_DIR}" "$SOURCE_FILE" -o "$OUTPUT_BIN"

echo "=== 3. Running Simulation ==="
# 生成されたバイナリを実行
./"$OUTPUT_BIN" "$IMAGE_FILE"

echo "=== Done. Image generated at $IMAGE_FILE ==="