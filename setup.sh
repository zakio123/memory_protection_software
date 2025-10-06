#!/bin/bash
# スクリプトの途中でエラーが発生したら、即座に停止する設定
set -e

echo "--- Initializing and updating submodules to the correct version... ---"
# サブモジュールを初期化し、親リポジトリが記録している特定のコミットに合わせる
git submodule update --init --recursive

echo "--- Applying patches to 'spike' submodule... ---"
# `spike`ディレクトリに対して、`patches`ディレクトリ内の全てのパッチファイルを適用する
git -C spike apply ../patches/*.patch

echo "--- Setup complete! You can now build the project. ---"