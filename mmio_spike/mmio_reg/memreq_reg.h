#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include "reg_map.h"

/* --- MEMREQ 操作用インライン関数 --- */
static inline void memreq_make(uint64_t size, uint64_t num) {
    MEMREQ_MEM_SIZE_REG = size;
  MEMREQ_NUM_REG  = num;
    // printf("[Core FW] MEMREQ: size=%llu, num=%llu\n", size, num);
  return;
}