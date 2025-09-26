# C++コンパイラを指定
CXX = g++

# コンパイルオプション
# -Wall : 全ての警告を有効にする
# -std=c++17 : C++17の標準規格でコンパイルする
# -I./include : ヘッダファイルの検索パスに 'include' ディレクトリを追加する
CXXFLAGS = -Wall -std=c++17 -I./include

# コンパイル対象のソースファイル (今回はmain.cppのみ)
SRCS = main.cpp

# 生成する実行ファイル名
TARGET = simulator

.PHONY: all clean

# 'make' コマンドで実行されるデフォルトのターゲット
all: $(TARGET)

# 実行ファイルを生成するルール
$(TARGET): $(SRCS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SRCS)

# 'make clean' コマンドで実行されるターゲット
# 生成されたファイルを削除する
clean:
	rm -f $(TARGET)