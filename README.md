# ソフトウェアディファインドメモリ整合性検証アクセラレータ spike シミュレーション
このプロジェクトは、RISC-Vコアによるソフトウェア制御と専用ハードウェアアクセラレータを用いて、メモリの暗号化と整合性検証を提供するシステムのソフトウェアシミュレーションです。

## システム概要
本システムは、LLC（ラストレベルキャッシュ）とDRAMの間に位置し、64B単位のメモリアクセスに対して暗号化と整合性保証を透過的に提供する。
- AES-CTRを用いた64B単位の暗号化
- FNV-1aハッシュを用いた整合性検証
- 32分木構造の認証木によるリプレイ攻撃耐性

## 構成
main.cにコアによる制御のコードがある。
- メモリ保護領域
    - 保護領域: 64MB (0x0000_0000 - 0x03FF_FFFF)
- キャッシュライン: 1M個 (64B/ライン)
- タグ: 8B/ライン (合計8MB)
- カウンターライン: 32K個 (32分木、高さ4)
- 認証木
    - 32分木 (各ノードが32子を持つ)
    - 高さ4 (ルート + 3レベルの中間ノード + リーフノード)
    - 各ノードは64Bの
- カウンターライン
    - 各カウンターラインは32個のカウンターを格納
    - 1カウンターあたりのサイズ:　(メジャーカウンター 64bit + マイナーカウンター 8bit)

# Software-Defined AMEソフトウェアの動かした。
全てのビルドと実行はcad005で行っています。

#### 手順
1. MMIOデバイスを追加したspikeのビルド -> champsimのビルドに必要なライブラリファイルの生成
2. ChampSimのビルド
3. AMEソフトウェアのコンパイル
4. 初期化データの用意
5. 実行

## 0. 
このリポジトリをクローンしたら、まずspikeの差分をアップデートするために以下のコマンドを実行してください。
```
bash setup.sh
```
次にChampSimで動かすトレースファイルを(https://dpc3.compas.cs.stonybrook.edu/champsim-traces/speccpu/)からダウンロードしてください。
riscvツールチェインのコンパイラやriscv-testに含まれているファイルを一部使うので用意してください。

## 1. Spikeのビルド
spikeをビルドします。最後のところ以外は正式なものと変わりありません。
```
$ cd spike
$ mkdir build
$ cd build
$ ../configure
$ make
$ make all-spikecore 
```
## 2. ChampSimのビルド
ChampSimのリポジトリに移動してください.必要なライブラリなどは公式に従ってインストールしてください。
Makefileに先ほどビルドしたSpikeのパスをSPIKE_PREFIXへ追加してください。
```
$ ./config.sh champsim_config_pass.json
$ make
```
エラーが出たらごめんなさい。

## 3. AMEソフトウェアのコンパイル
逐次実行アルゴリズムのファイルはvar_set_asoc_cache.cです。各種設定ファイルはconfig.hにまとめています。
以下のコマンドでコンパイルします。
```
$ cd spike_simulation
$ riscv64-unknown-elf-gcc \
-I/riscv-tests/build/../benchmarks/../env \
-I/riscv-tests/build/../benchmarks/common -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O3 -ffast-math -fno-common -fno-builtin-printf -fno-tree-loop-distribute-patterns -march=rv64gcv \
/riscv-tests/build/../benchmarks/common/syscalls.c \
/riscv-tests/build/../benchmarks//common/crt.S \
-static -nostdlib -nostartfiles -lm -lgcc \
-T /riscv-tests/build/../benchmarks/common/test.ld \
-I/inc/ \
-o tmp_.elf var_set_asoc_cache.c
```

## 4. 初期化データの用意
16GBとかの暗号化データとそのメタデータを毎回用意するのはとても時間がかかるので、データを暗号化して初期化した体でシミュレーションを始めています。
```
$ cd init_data
$ g++ -o a.out -I/path/to/spike_simulation/inc init_image_main.cc -fopenmp
$ ./a.out image_6.bin
```
これで生成した初期化イメージデータを次で、ChampSimに渡します。

## 5. 実行
ChampSimのディレクトリへ移動します。
以下のコマンドでシミュレーションを開始します.実行命令数などはうまく調整してください。
```
bin/champsim -i 10000000 -w 4000000 \
--spike_kernel /path/to/elf_file  --spike_m 65536   --spike_init_image /path/to/init_image_file \
/path/to/trace_data_file
```