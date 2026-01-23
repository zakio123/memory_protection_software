#include <stdint.h>
#include "mmio_reg/spm_reg.h"
#include "mmio_reg/mac_reg.h"
#include "mmio_reg/aes_reg.h"
#include "mmio_reg/axim_reg.h"
#include "mmio_reg/memreq_reg.h"
#include "mmio_reg/xor_reg.h"
#include "mmio_reg/reg_map.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "util.h"
#include "config.h"
#include "cache_controll.h"
#include "addr_util.h"
#include "sec_operation.h"
#include "lock.h"

int main(){
  int hartid;
  asm volatile(
      "csrr %0, mhartid"
      : "=r"(hartid)
  );
  push_temp_buffer(hartid * 64);
  spm_offset_t c1 = pop_temp_buffer();
  lock_print();
  printf("Popped temp buffer: %016llx\n", c1);
  unlock_print();
  while(1){
    asm volatile("nop");
  }
}