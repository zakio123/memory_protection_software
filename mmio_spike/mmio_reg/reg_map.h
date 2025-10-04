#pragma once
#include <stdint.h>
#include <stddef.h>
/* アクセスマクロ (64bit レジスタ) */
#define REG64(base, off) (*(volatile uint64_t*)((uintptr_t)(base) + (off)))

#ifndef SPM_ADDRMAP_H
#define SPM_ADDRMAP_H
/* --- SPM アドレスマップ（定数マクロに統一） --- */
#define SPM_BASE        0x40000000ULL
#define SPM_CTRL_SIZE   0x00001000ULL /* 4 KiB */
#define SPM_MEM_SIZE    0x00010000ULL /* 64 KiB */
#define SPM_TOTAL_SIZE  (SPM_CTRL_SIZE + SPM_MEM_SIZE)

/* 64-bit レジスタオフセット（SPM_BASEからの相対） */
#define SPM_REG_DRAM_ADDR    0x00ULL
#define SPM_REG_LOCAL_ADDR   0x08ULL /* SPMデータ窓先頭からのバイトオフセット */
#define SPM_REG_SIZE         0x10ULL
#define SPM_REG_DIRECTION    0x18ULL /* 0/1 */
#define SPM_REG_START        0x20ULL /* write 1=start / read: busy */
#define SPM_REG_STATUS       0x28ULL

/* データ窓のベース */
#define SPM_MEM_BASE   (SPM_BASE + SPM_CTRL_SIZE)

/* --- MMIO アクセスヘルパ --- */
/* 注意: 8Bアクセスは8バイト境界に合わせること（未アラインで例外） */
#define SPM_REG64(off)   (*(volatile uint64_t *)((uintptr_t)(SPM_BASE + (off))))

#define SPM_DRAM_ADDRESS   SPM_REG64(SPM_REG_DRAM_ADDR)
#define SPM_LOCAL_ADDRESS  SPM_REG64(SPM_REG_LOCAL_ADDR)
#define SPM_SIZE_REG       SPM_REG64(SPM_REG_SIZE)
#define SPM_DIRECTION      SPM_REG64(SPM_REG_DIRECTION)
#define SPM_START          SPM_REG64(SPM_REG_START)
#define SPM_STATUS         SPM_REG64(SPM_REG_STATUS)
#endif // SPM_ADDRMAP_H

#ifndef MAC_ADDRMAP_H
#define MAC_ADDRMAP_H


// ベースアドレスとサイズ
#define MAC_BASE        0x50000000ULL
#define MAC_CTRL_SIZE   0x00001000ULL  // 4 KiB

// レジスタオフセット（BASEからの相対）
#define MAC_REG_SPM_ADDR    0x00
#define MAC_REG_SPM_START   0x08
#define MAC_REG_COMMAND     0x10
#define MAC_REG_STATUS      0x18
#define MAC_REG_START_BIT   0x20
#define MAC_REG_END_BIT     0x28
#define MAC_REG_MAC_RESULT  0x30


// 実際のレジスタアクセス
#define MAC_SPM_ADDR     REG64(MAC_BASE, MAC_REG_SPM_ADDR)
#define MAC_SPM_START    REG64(MAC_BASE, MAC_REG_SPM_START)
#define MAC_COMMAND      REG64(MAC_BASE, MAC_REG_COMMAND)
#define MAC_STATUS       REG64(MAC_BASE, MAC_REG_STATUS)
#define MAC_START_BIT    REG64(MAC_BASE, MAC_REG_START_BIT)
#define MAC_END_BIT      REG64(MAC_BASE, MAC_REG_END_BIT)
#define MAC_RESULT       REG64(MAC_BASE, MAC_REG_MAC_RESULT)

#endif // MAC_ADDRMAP_H

#ifndef AES_ADDRMAP_H
#define AES_ADDRMAP_H


// ベースアドレスとサイズ
#define AES_BASE        0x50001000ULL
#define AES_CTRL_SIZE   0x00001000ULL  // 4 KiB

// レジスタオフセット（BASEからの相対）
#define AES_INPUT_0    0x00
#define AES_INPUT_1    0x08
#define AES_INPUT_2    0x10
#define AES_INPUT_3    0x18
#define AES_INPUT_4    0x20
#define AES_INPUT_5    0x28
#define AES_INPUT_6    0x30
#define AES_INPUT_7    0x38
#define AES_START      0x40

// 実際のレジスタアクセス
#define AES_INPUT_0_REG    REG64(AES_BASE, AES_INPUT_0)
#define AES_INPUT_1_REG    REG64(AES_BASE, AES_INPUT_1)
#define AES_INPUT_2_REG    REG64(AES_BASE, AES_INPUT_2)
#define AES_INPUT_3_REG    REG64(AES_BASE, AES_INPUT_3)
#define AES_INPUT_4_REG    REG64(AES_BASE, AES_INPUT_4)
#define AES_INPUT_5_REG    REG64(AES_BASE, AES_INPUT_5)
#define AES_INPUT_6_REG    REG64(AES_BASE, AES_INPUT_6)
#define AES_INPUT_7_REG    REG64(AES_BASE, AES_INPUT_7)
#define AES_START_REG      REG64(AES_BASE, AES_START)
#endif // AES_ADDRMAP_H

/* AXIM */
#ifndef AXIM_ADDRMAP_H
#define AXIM_ADDRMAP_H


#define AXIM_BASE           (AES_BASE + AES_CTRL_SIZE)
#define AXIM_CTRL_SIZE      0x00001000ULL
#define AXIM_STATUS         0x00ULL
#define AXIM_REQ_ADDR       0x08ULL
#define AXIM_REQ_ID         0x10ULL
#define AXIM_SPM_ADDR       0x18ULL
#define AXIM_COMMAND        0x20ULL
#define AXIM_BUSY           0x28ULL


/* 実際のレジスタアクセス */
#define AXIM_STATUS_REG    REG64(AXIM_BASE, AXIM_STATUS)
#define AXIM_REQ_ADDR_REG  REG64(AXIM_BASE, AXIM_REQ_ADDR)
#define AXIM_REQ_ID_REG    REG64(AXIM_BASE, AXIM_REQ_ID)
#define AXIM_SPM_ADDR_REG  REG64(AXIM_BASE, AXIM_SPM_ADDR)
#define AXIM_COMMAND_REG   REG64(AXIM_BASE, AXIM_COMMAND)
#define AXIM_BUSY_REG      REG64(AXIM_BASE, AXIM_BUSY)

#endif // AXIM_ADDRMAP_H

#ifndef MEMREQ_ADDRMAP_H
#define MEMREQ_ADDRMAP_H
/* MEMREQ */
#define MEMREQ_BASE         (AXIM_BASE + AXIM_CTRL_SIZE)
#define MEMREQ_CTRL_SIZE    0x00001000ULL
#define MEMREQ_MEM_SIZE     0x00ULL
#define MEMREQ_NUM          0x08ULL

/* 実際のレジスタアクセス */
#define MEMREQ_MEM_SIZE_REG REG64(MEMREQ_BASE, MEMREQ_MEM_SIZE)
#define MEMREQ_NUM_REG      REG64(MEMREQ_BASE, MEMREQ_NUM)
#endif // MEMREQ_ADDRMAP_H
