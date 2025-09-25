# コンパイラ
CC = gcc

# コンパイルオプション
CFLAGS = -Wall -I./include

# ソースファイル
SRCS = app/main.c hw_model/hardware_model.c bridge/mmio.c sim_main.c

# 実行ファイル名
TARGET = simulator

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRCS)

clean:
	rm -f $(TARGET)