#!/bin/bash

# 1. すべての出力を書き込むログファイルを指定
LOG_FILE="spike_full_output.log"

# 2. トレースファイルが格納されているディレクトリ
TRACE_DIR="../../../ChampSim/log"

# 3. Spikeコマンド本体
SPIKE_CMD="../../riscv-isa-sim/build/spike"

# 4. 実行するELFファイル
ELF_FILE="var.elf"

# --- スクリプト本体 ---

# ログファイルを初期化（スクリプト実行時に古いログを消去）
echo "Spike一括実行開始: $(date)" > "$LOG_FILE"
echo "=================================================" >> "$LOG_FILE"

# 5. TRACE_DIR内のすべての .bin ファイルに対してループ
for trace_file in "$TRACE_DIR"/*.bin; do

    # (念のため) ファイルが存在するかどうかをチェック
    if [ -f "$trace_file" ]; then
        
        # 画面とログファイルの両方に、どのトレースを実行しているか表示
        echo | tee -a "$LOG_FILE" # 読みやすくするために空行を挿入
        echo "[INFO] 実行中: $trace_file" | tee -a "$LOG_FILE"
        
        # 6. Spikeコマンドを実行
        #    標準出力(stdout)と標準エラー(stderr)の両方(2>&1)を...
        #    ...$LOG_FILE に追記(>>)する
        "$SPIKE_CMD" -m65536 --init_image=image_6.bin -l --log=tmp.txt --trace_data_file="$trace_file" "$ELF_FILE" >> "$LOG_FILE" 2>&1
        
        echo "[INFO] 完了: $trace_file" | tee -a "$LOG_FILE"
    
    else
        # マッチする .bin ファイルが1つも見つからなかった場合の処理
        echo "[WARN] $TRACE_DIR に .bin ファイルが見つかりません。" | tee -a "$LOG_FILE"
        break
    fi
done

echo "=================================================" | tee -a "$LOG_FILE"
echo "すべてのSpike実行が完了: $(date)" | tee -a "$LOG_FILE"