#include <stdint.h>
#include "spm_reg.h"
#include "mac_reg.h"
#include "aes_reg.h"
#include "axim_reg.h"
#include "memreq_reg.h"
#include <stdio.h>
/* 物理DRAMのベース＆アリーナ */
#define DRAM_BASE   0x80000000ULL
#define HEAP_BASE   (DRAM_BASE + 0x4000)  /* .text/.data の少し先から */
static uint64_t heap_ptr = HEAP_BASE;

/* 超簡易 “物理” malloc */
static void* pmalloc(uint64_t size, uint64_t align)
{
  if (align) heap_ptr = (heap_ptr + (align-1)) & ~(align-1);
  void* p = (void*)heap_ptr;
  heap_ptr += size;
  return p;  /* 返り値=物理アドレス */
}

static inline void wr64(uint64_t pa, uint64_t v){ *(volatile uint64_t*)pa = v; }
static inline uint64_t rd64(uint64_t pa){ return *(volatile uint64_t*)pa; }

/* 結果コード観察用アドレス（任意） */
#define RESULT_PA  (DRAM_BASE + 0x4000)
#define PASS_CODE  0x600D600DULL
#define FAIL1      0xDEADBEEFULL
#define FAIL2      0xDEADFA11ULL

int main(void)
{
  /* 1) 物理ヒープから 64B 確保し、既知パターンを書き込む */
  for (int i=0;i<8;++i){
    uint64_t v = spm_ld64(i*8);
    printf("SPM[%d]=%016llx\n", i, v);
  }
  uint64_t buf_pa = (uint64_t)pmalloc(64, 8);
  for (int i=0; i<8; ++i)
    wr64(buf_pa + i*8, 0xAA00000000000000ULL + (uint64_t)i);

  /* 2) DRAM→SPM コピー（local_off=0 に配置） */
  spm_copy_to_local(buf_pa, /*local_off=*/0, /*size=*/64);

  /* 3) SPMの中身を直接読んで検証 */
  for (int i=0; i<8; ++i){
    uint64_t exp = 0xAA00000000000000ULL + (uint64_t)i;
    uint64_t got = spm_ld64(0 + i*8);
    printf("SPM[%d]=%016llx\n", i, got);
    if (got != exp){ 
      printf("i=%d: got=%016llx, exp=%016llx\n", i, got, exp);
      return 1;
    }
  }

  /* 4) SPMを編集（全値 ^0xFF） */
  for (int i=0; i<8; ++i){
    uint64_t v = spm_ld64(0 + i*8);
    spm_sd64(0 + i*8, v ^ 0xFFULL);
  }

  /* 5) SPM→DRAM ライトバック */
  spm_write_back(/*local_off=*/0, buf_pa, 64);

  /* 6) DRAM側が反映されたか検証 */
  for (int i=0; i<8; ++i){
    // uint64_t exp = (0xAA00000000000000ULL + (uint64_t)i) ^ 0xFFULL;
    uint64_t got = rd64(buf_pa + i*8);
    uint64_t exp = spm_ld64(i * 8);
    printf("DRAM[%d]=%016llx\n", i, got);
    if (got != exp){ 
      printf("i=%d: got=%016llx, exp=%016llx\n", i, got, exp);
      return 1;
    }
  }
  // MAC計算
  // 64BをMacのバッファへ移す
  // MACを初期化->SPMからDMA->ビットを与える->計算->結果を読む
  // 1) MACを初期化
  mac_init();
  // 2) SPMからDMA
  mac_buffer_set(0);
  // 3) ビットを与える
  mac_update(0, 511);
  // 4) 結果を読む
  uint64_t mac_result = mac_final();
  // 6) 結果を検証
  // spmに対してFNV-1aハッシュを計算した結果と比較
// FNV-1aハッシュ用の定数 (64bit版)
static uint64_t FNV_PRIME = 0x100000001b3;
static uint64_t FNV_OFFSET_BASIS = 0xcbf29ce484222325;
  uint64_t expected = 0;
  for (int i = 0; i < 8; ++i) {
      printf("  [Hash SW] Processing byte %d: %lx\n", i, spm_ld64(i * 8));
      uint64_t bytes = spm_ld64(i * 8);
      for (int j = 0; j < 8; ++j) {
          expected ^= (bytes & 0xFF);
          bytes >>= 8;
          expected *= FNV_PRIME;
      }
  }

  printf("MAC result: got=%016llx, exp=%016llx\n", mac_result, expected);
  if (mac_result != expected) {
      printf("MAC result mismatch!\n");
      return 2;
  }
  // 7) 結果コードをセットして終了
  return 0;
}
