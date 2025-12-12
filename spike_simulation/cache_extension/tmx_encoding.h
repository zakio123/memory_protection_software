#ifndef TMX_ENCODING_H
#define TMX_ENCODING_H

/* --- 基本パラメータ --- */
#define TMX_OPCODE 0x0b // custom-0
#define TMX_F3     0x0

/* --- Funct7 定義 (Command ID) --- */
#define F7_TMX_FIND    0x00
#define F7_TMX_GET_SPM 0x01
#define F7_TMX_ALLOC   0x02
#define F7_TMX_INVALID 0x03
#define F7_TMX_SET_D   0x04
#define F7_TMX_IS_D    0x05
#define F7_TMX_ACQ     0x06
#define F7_TMX_REL     0x07
#define F7_TMX_SET_L   0x08
#define F7_TMX_IS_L    0x09
#define F7_TMX_SWAP    0x0A
#define F7_TMX_PUSH    0x0B
#define F7_TMX_POP     0x0C

/* --- Spike (C++) 用ヘルパマクロ --- */
/* Match値生成: (funct7 << 25) | (funct3 << 12) | opcode */
#define TMX_MATCH(f7)  (((f7) << 25) | (TMX_F3 << 12) | TMX_OPCODE)
#define TMX_MASK       0xFE00707F
#endif // TMX_ENCODING_H