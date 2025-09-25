# C++コンパイラ
CXX = g++
# C++コンパイルオプション (-std=c++17を追加)
CXXFLAGS = -Wall -std=c++17 -I./include
# ソースファイル (main.cppのみ)
SRCS = main.cpp
# 実行ファイル名
TARGET = simulator

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRCS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SRCS)

clean:
	rm -f $(TARGET)