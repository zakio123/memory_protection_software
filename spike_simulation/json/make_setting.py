import json
import math
import sys
import os

def main():
    # コマンドライン引数があればそれを、なければ json/default.json を使用するロジックに変更
    # (Bashからパス付きで渡されることを想定)
    config_file_path = sys.argv[1] if len(sys.argv) > 1 else "json/default.json"
    print(f"[Python] Loading configuration from: {config_file_path}")
    with open(config_file_path, "r") as f:
        cfg = json.load(f)

    split_counter = cfg.get("SPLIT_COUNTER", False) # getを使って安全に取得
    # メモリレイアウトの表示
    protection_base = int(cfg["PROTECTION_BASE"], 16)
    protection_size = int(cfg["PROTECTION_SIZE"])
    protection_uint = cfg["SIZE_UNIT"]
    protection_size_grain = cfg.get("PROTECTION_SIZE_GRAIN", 64)  # デフォルト値を64に設定

    if protection_uint == "MB":
        protection_size *= 1024 * 1024
    elif protection_uint == "GB":
        protection_size *= 1024 * 1024 * 1024
    elif protection_uint == "TB":
        protection_size *= 1024 * 1024 * 1024 * 1024
    else:
        raise ValueError(f"Unknown SIZE_UNIT: {protection_uint}")
    tag_size = protection_size // (protection_size_grain * 8)
    tag_base = protection_base + protection_size
    counter_base = tag_base + tag_size
    # マイナーカウンターの数が木の分木数に相当
    height = 0
    mc_width = cfg["MINOR_COUNTER_WIDTH"]
    mc_count = cfg["MINOR_COUNTER_COUNT"]
    split_ = cfg["SPLIT_COUNTER"]
    arty_log2 = math.log2(mc_count)
    print(f"arty_log2: {arty_log2}")
    # exit(0)
    while(1):
        height += 1
        if (mc_count ** (height)) * protection_size_grain >= protection_size:
            break
    # ★ここを変更: incディレクトリの下に作成する
    output_path = "inc/setting.h"
    
    # incディレクトリがない場合は作成する（念のため）
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w") as f:
        print(f"[Python] Writing configuration to: {output_path}")
        f.write("#ifndef CONFIG_H\n#define CONFIG_H\n\n")
        # f.write("#include <cstdint>\n\n")
        # カウンター関連
        if (split_):
            f.write(f"#define SETTING_SPLIT_COUNTER 1\n")
        else:
            f.write(f"#define SETTING_SPLIT_COUNTER 0\n")
        f.write(f"#define SETTING_MINOR_COUNTER_WIDTH {mc_width}\n")
        f.write(f"#define SETTING_MINOR_COUNTER_COUNT {mc_count}\n")
        f.write(f"#define SETTING_ARTY_LOG2 {int(arty_log2)}\n")
        f.write(f"#define SETTING_HEIGHT {height}\n")
        f.write(f"#define SETTING_PROTECTION_BASE 0x{protection_base:X}\n")
        f.write(f"#define SETTING_PROTECTION_SIZE 0x{protection_size:X}\n")
        f.write(f"#define SETTING_PROTECTION_SIZE_GRAIN {protection_size_grain}\n")
        f.write(f"#define SETTING_MAC_COVERAGE_BLOCKS 8\n")
        # キャッシュ関連
        cache_ways_log2 = cfg["CACHE_WAYS_LOG2"]
        f.write(f"#define SETTING_CACHE_WAYS_LOG2 {cache_ways_log2}\n")
        f.write("\n#endif\n")


    print(f"[Python] Configuration generated: {output_path} from {config_file_path}")

if __name__ == "__main__":
    main()