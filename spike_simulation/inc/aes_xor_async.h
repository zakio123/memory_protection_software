#ifdef __cplusplus
extern "C" {
#endif

#pragma once

#include <stdint.h>
#include <stdbool.h>
#include "../mmio_reg/aes_xor_async_reg.h"

static inline void aes_xor_async_set_nonce64(uint64_t major_counter, uint16_t minor_counter, uint64_t d_addr) {
  uint64_t seed_0 = major_counter;
  uint64_t seed_1 = (uint64_t)minor_counter << 48 | d_addr;
  uint64_t seed_2 = major_counter;
  uint64_t seed_3 = (uint64_t)minor_counter << 48 | (d_addr + 16);
  uint64_t seed_4 = major_counter;
  uint64_t seed_5 = (uint64_t)minor_counter << 48 | (d_addr + 32);
  uint64_t seed_6 = major_counter;
  uint64_t seed_7 = (uint64_t)minor_counter << 48 | (d_addr + 48);
  AES_XOR_ASYNC_NONCE_0_REG = seed_0;
  AES_XOR_ASYNC_NONCE_1_REG = seed_1;
  AES_XOR_ASYNC_NONCE_2_REG = seed_2;
  AES_XOR_ASYNC_NONCE_3_REG = seed_3;
  AES_XOR_ASYNC_NONCE_4_REG = seed_4;
  AES_XOR_ASYNC_NONCE_5_REG = seed_5;
  AES_XOR_ASYNC_NONCE_6_REG = seed_6;
  AES_XOR_ASYNC_NONCE_7_REG = seed_7;
}

static inline uint64_t aes_xor_async_pack_xor_cfg(bool in_from_reqio,
                                                   bool out_to_reqio,
                                                   uint32_t spm_offset,
                                                   uint32_t dma_id) {
  uint64_t v = 0;
  if (in_from_reqio) v |= AES_XOR_CFG_IN_FROM_REQIO_BIT;
  if (out_to_reqio) v |= AES_XOR_CFG_OUT_TO_REQIO_BIT;
  v |= ((uint64_t)(spm_offset & AES_XOR_CFG_SPM_OFFSET_MASK))
       << AES_XOR_CFG_SPM_OFFSET_SHIFT;
  v |= ((uint64_t)dma_id) << AES_XOR_CFG_DMA_ID_SHIFT;
  return v;
}

static inline uint64_t aes_xor_async_pack_ctrl(uint32_t aes_id,
                                               bool last_in_group) {
  uint64_t v = AES_XOR_CTRL_START_BIT;
  if (last_in_group) v |= AES_XOR_CTRL_LAST_IN_GROUP_BIT;
  v |= ((uint64_t)aes_id) << AES_XOR_CTRL_AES_ID_SHIFT;
  return v;
}

static inline void aes_xor_async_submit64_with_reqid(uint64_t major_counter,
                                                     uint16_t minor_counter,
                                                     uint64_t d_addr,
                                                     uint32_t req_id,
                                                     uint32_t aes_id,
                                                     bool last_in_group,
                                                     uint32_t spm_offset,
                                                     bool in_from_reqio,
                                                     bool out_to_reqio,
                                                     uint32_t dma_id) {
  aes_xor_async_set_nonce64(major_counter, minor_counter, d_addr);
  AES_XOR_ASYNC_REQ_ID_REG = (uint64_t)req_id;
  AES_XOR_ASYNC_XORCFG_REG = aes_xor_async_pack_xor_cfg(
      in_from_reqio, out_to_reqio, spm_offset, dma_id);
  AES_XOR_ASYNC_CTRL_REG = aes_xor_async_pack_ctrl(aes_id, last_in_group);
}
static inline uint32_t aes_xor_async_last_done_id(void) {
  return (uint32_t)AES_XOR_ASYNC_LAST_DONE_REG;
}

static inline bool aes_xor_async_is_done(uint32_t expected_id) {
  return expected_id <= aes_xor_async_last_done_id();
}

#ifdef __cplusplus
}
#endif
