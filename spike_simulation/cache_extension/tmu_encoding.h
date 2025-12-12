#ifndef TMU_ENCODING_H
#define TMU_ENCODING_H

/* --- 基本パラメータ --- */
#define TMU_OPCODE 0x2b // custom-1
#define TMU_F3     0x0


/* --- Funct7 定義 (Command ID) --- */
#define F7_TMU_CHECK_TAG    0x00
#define F7_TMU_ACQUIRE      0x01
#define F7_TMU_RELEASE      0x02
#define F7_TMU_SET_TAG      0x03
#define F7_TMU_GET_TAG      0x0B
#define F7_TMU_SET_D        0x04
#define F7_TMU_IS_D         0x05
#define F7_TMU_CLEAR_D      0x06
#define F7_TMU_SET_SPM      0x07
#define F7_TMU_GET_SPM      0x08
#define F7_TMU_IS_SWAPPABLE 0x09
#define F7_TMU_RETURN_METADATA 0x0A
/* --- Spike (C++) 用ヘルパマクロ --- */
/* Match値生成: (funct7 << 25) | (funct3 << 12) | opcode */
#define TMU_MATCH(f7)  (((f7) << 25) | (TMU_F3 << 12) | TMU_OPCODE)
#define TMU_MASK       0xFE00707F

#endif // TMU_ENCODING_H