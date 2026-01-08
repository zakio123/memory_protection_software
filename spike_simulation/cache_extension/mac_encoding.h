#ifndef MAC_ENCODING_H
#define MAC_ENCODING_H

/* --- 基本パラメータ --- */
#define MAC_OPCODE 0x5b // custom-1
#define MAC_F3     0x0

/* --- Funct7 定義 (Command ID) --- */
#define F7_MAC_INIT    0x00
#define F7_MAC_COPY    0x01
#define F7_MAC_UPDATE  0x02
#define F7_MAC_DIGEST  0x03
#define F7_MAC_COMPARE 0x04
#define F7_MAC_ID      0x05
#define F7_MAC_INIT_2    0x10
#define F7_MAC_COPY_2    0x11
#define F7_MAC_UPDATE_2  0x12
#define F7_MAC_DIGEST_2  0x13
#define F7_MAC_COMPARE_2 0x14
#define F7_MAC_ID_2      0x15
/* --- Spike (C++) 用ヘルパマクロ --- */
/* Match値生成: (funct7 << 25) | (funct3 << 12) | opcode */
#define MAC_MATCH(f7)  (((f7) << 25) | (MAC_F3 << 12) | MAC_OPCODE)
#define MAC_MASK       0xFE00707F
#endif // MAC_ENCODING_H