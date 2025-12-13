#include "config.h"
#include "mem_layout.h"
#include "temp_controll.h"
#include "tmu_encoding.h"
#include <stdio.h>

/* --- インラインアセンブラマクロ (HWモード用) --- */
#ifdef ENABLE_TMU_HARDWARE
#define TMU_INSN_R(funct7, rd, rs1, rs2) \
    asm volatile ( \
        ".insn r %1, %2, %3, %0, %4, %5" \
        : "=r"(rd) \
        : "i"(TMU_OPCODE), "i"(TMU_F3), "i"(funct7), "r"(rs1), "r"(rs2) \
    )
#endif

struct Info {
    bool dirty;
    bool hit;
    spm_offset_t spm_offset;
    dram_addr_t block_addr;
    int8_t way;
};
static inline index_t get_cache_set_index(dram_addr_t dram_addr) {
    if (dram_addr < COUNTER_BASE) {
        // Data Tag領域
        return ((dram_addr) / 64) % DATA_TAG_SETS;
    } else {
        // Counter Tree領域
        return ((dram_addr) / 64) % TREE_SETS + DATA_TAG_SETS;
    }
}
// キャッシュメタデータの配列　SoA形式
#ifndef ENABLE_TMU_HARDWARE
bool valid_metadata[CACHE_SETS][CACHE_WAYS] = {0};
bool dirty_metadata[CACHE_SETS][CACHE_WAYS] = {0};
dram_addr_t block_addr_metadata[CACHE_SETS][CACHE_WAYS] = {0};
spm_offset_t spm_offset_metadata[CACHE_SETS][CACHE_WAYS] = {0};
uint32_t ref_count_metadata[CACHE_SETS][CACHE_WAYS] = {0};
#endif
bool mac_updated_metadata[CACHE_SETS][CACHE_WAYS] = {0};
bool loaded_metadata[CACHE_SETS][CACHE_WAYS] = {0};
uint32_t access_count_metadata[CACHE_SETS][CACHE_WAYS] = {0};


// --- キャッシュ操作関数群 ---
// ハードウェア支援がありうる場合、インラインアセンブラで実装
static inline void set_block_dirty(index_t set_index,index_t way_index){
  #ifdef ENABLE_TMU_HARDWARE
    long slot_idx = (set_index * CACHE_WAYS) + way_index;
    long ret;
    TMU_INSN_R(F7_TMU_SET_D, ret, slot_idx, 0); 
  #else
    dirty_metadata[set_index][way_index] = true;
  #endif
}
static inline void clear_block_dirty(index_t set_index,index_t way_index){
  #ifdef ENABLE_TMU_HARDWARE
    long slot_idx = (set_index * CACHE_WAYS) + way_index;
    long ret;
    TMU_INSN_R(F7_TMU_CLEAR_D, ret, slot_idx, 0); 
  #else
    dirty_metadata[set_index][way_index] = false;
  #endif
}
bool is_block_dirty(index_t set_index, index_t way_index){
  #ifdef ENABLE_TMU_HARDWARE
    long slot_idx = (set_index * CACHE_WAYS) + way_index;
    long ret;
    TMU_INSN_R(F7_TMU_IS_D, ret, slot_idx, 0); 
    return (bool)ret;
  #else
  return dirty_metadata[set_index][way_index];
  #endif
}

static inline bool acquire_cache_block(index_t set_index, index_t way_index){
  #ifdef ENABLE_TMU_HARDWARE
    long slot_idx = (set_index * CACHE_WAYS) + way_index;
    long ret;
    TMU_INSN_R(F7_TMU_ACQUIRE, ret, slot_idx, 0); 
    return (bool)ret;
  #else
  if (valid_metadata[set_index][way_index] == false){
    printf("Error: Attempt to acquire invalid cache block S:%u W:%u\n", set_index, way_index);
      return false;
  } else {
    ref_count_metadata[set_index][way_index] += 1;
      return true;
    }
  #endif
}
static inline void release_cache_block(index_t set_index, index_t way_index){
  #ifdef ENABLE_TMU_HARDWARE
    long slot_idx = (set_index * CACHE_WAYS) + way_index;
    long ret;
    TMU_INSN_R(F7_TMU_RELEASE, ret, slot_idx, 0); 
  #else
    if (valid_metadata[set_index][way_index] == false){
        printf("Error: Attempt to release invalid cache block S:%u W:%u\n", set_index, way_index);
        exit(1);
        return;
    }
    if (ref_count_metadata[set_index][way_index] == 0){
        printf("Error: Attempt to release cache block S:%u W:%u with ref_count 0\n", set_index, way_index);
        exit(1);
        return;
    }
    ref_count_metadata[set_index][way_index] -= 1;
  #endif
}

static inline bool swappable_cache_block(index_t set_index, index_t way_index){
  #ifdef ENABLE_TMU_HARDWARE
    long slot_idx = (set_index * CACHE_WAYS) + way_index;
    long ret;
    TMU_INSN_R(F7_TMU_IS_SWAPPABLE, ret, slot_idx, 0); 
    return (bool)ret;
  #else
  return (ref_count_metadata[set_index][way_index] == 0);
  #endif
}

static inline uint64_t return_metadata(index_t set_index){
  #ifdef ENABLE_TMU_HARDWARE
    long slot_idx = (set_index * CACHE_WAYS);
    long ret;
    TMU_INSN_R(F7_TMU_RETURN_METADATA, ret, slot_idx, 0); 
    return (uint64_t)ret;
  #else
  // PYHSICAL_WAYS分のvalid,dirty,tree_lruをまとめて返す
  uint64_t metadata = 0;
  for(int w=0; w<CACHE_WAYS; w++){
      metadata |= ((uint64_t)(valid_metadata[set_index][w] ? 1 : 0) << (w * 2));
      metadata |= ((uint64_t)(dirty_metadata[set_index][w] ? 1 : 0) << (w * 2 + 1));
  }
  return metadata;
  #endif
}

spm_offset_t get_cache_block_spm_offset(index_t set_index, index_t way_index){
  #ifdef ENABLE_TMU_HARDWARE
    long slot_idx = (set_index * CACHE_WAYS) + way_index;
    long ret;
    TMU_INSN_R(F7_TMU_GET_SPM, ret, slot_idx, 0); 
    return (spm_offset_t)ret;
  #else
  return spm_offset_metadata[set_index][way_index];
  #endif
}

static inline void set_block_valid(index_t set_index, index_t way_index){
  #ifdef ENABLE_TMU_HARDWARE
    long slot_idx = (set_index * CACHE_WAYS) + way_index;
    long ret;
    TMU_INSN_R(F7_TMU_SET_VALID, ret, slot_idx, 0); 
  #else
    valid_metadata[set_index][way_index] = true;
  #endif
}
static inline bool is_block_valid(index_t set_index, index_t way_index){
  #ifdef ENABLE_TMU_HARDWARE
    long slot_idx = (set_index * CACHE_WAYS) + way_index;
    long ret;
    TMU_INSN_R(F7_TMU_IS_VALID, ret, slot_idx, 0); 
    return (bool)ret;
  #else
  return valid_metadata[set_index][way_index];
  #endif
}



// --- 軽量タグチェック (読み取り専用、ヒット/ミスのみ判定) ---
// 高速化のため、ヒットしたかと、空いているwayの探索のみを行う and 追い出しても良さそうなwayの探索
typedef struct {
    bool hit;
    int8_t way;
} light_tag_info_t;
static inline light_tag_info_t light_tag_check(dram_addr_t dram_addr){
  #ifndef ENABLE_TMU_HARDWARE
  index_t set_index = get_cache_set_index(dram_addr);
  uint32_t lru_counter_max = 0;
  int8_t way_index = -1;
    // wayを決定
  for (index_t i = 0; i < CACHE_WAYS; ++i) {
    if (valid_metadata[set_index][i]) {
      if (block_addr_metadata[set_index][i] == dram_addr) {
        light_tag_info_t info = {true, i};
        return info;
      } else if (ref_count_metadata[set_index][i] == 0 && !mac_updated_metadata[set_index][i] && !dirty_metadata[set_index][i]) {
        uint32_t access_count = (access_count_metadata[set_index][i] + 1) & 0xF; // 4bitのアクセス数
        if (access_count > lru_counter_max && access_count > 10) { // ある程度古いもののみ候補
            lru_counter_max = access_count;
            way_index = i;
        }
      }
    } else {
        // 空きwayが見つかった場合、そのwayを使用
        light_tag_info_t info = {false, i};
        valid_metadata[set_index][i] = true; // 明示的に有効化
        return info;
    }
  }
  if (way_index != -1){
    printf("[Cache] Light tag check miss for addr=%016llx, selected way=%d\n", dram_addr, way_index);
    block_addr_metadata[set_index][way_index] = dram_addr;
    access_count_metadata[set_index][way_index] = 0; // カウンターリセット
    dirty_metadata[set_index][way_index] = false; // dirtyクリア
    mac_updated_metadata[set_index][way_index] = true; // mac updatedクリア
  }
  light_tag_info_t info = {false, way_index};
  return info;
  #endif
}


void update_counter_on_access(index_t set_index, index_t way_index){
  #ifndef ENABLE_TMU_HARDWARE
  for (index_t i = 0; i < CACHE_WAYS; ++i) {
    if (valid_metadata[set_index][i] &&  i != way_index && ref_count_metadata[set_index][i] == 0) {
        uint32_t access_count = (access_count_metadata[set_index][i] + 1) & 0xF; // 4bitのアクセス数
        access_count_metadata[set_index][i] = access_count;
    }
    if (i == way_index) {
        // 選ばれたwayのカウンターをリセット
        access_count_metadata[set_index][i] = 0;
    }
  }
  #endif
}


static inline dma_id_t ensureBlockInSpm(dram_addr_t required_dram_addr, struct Info tag_info,dma_id_t id){
  dma_id_t read_id = id;
  index_t set_index = get_cache_set_index(required_dram_addr);
  if (tag_info.dirty) {
    if (!swappable_cache_block(set_index, tag_info.way)){
      exit(1);
    }
    spm_write_back(tag_info.spm_offset, tag_info.block_addr, 64,0);
  }
  #ifdef ENABLE_TMU_HARDWARE
    long slot_idx = (set_index * CACHE_WAYS) + tag_info.way;
    long ret;
    TMU_INSN_R(F7_TMU_SET_TAG, ret, slot_idx, required_dram_addr);
  #else
    valid_metadata[set_index][tag_info.way] = true;
    dirty_metadata[set_index][tag_info.way] = false;
    ref_count_metadata[set_index][tag_info.way] = 0;
    access_count_metadata[set_index][tag_info.way] = 0;
    block_addr_metadata[set_index][tag_info.way] = required_dram_addr;
  #endif
  spm_copy_to_local(required_dram_addr, tag_info.spm_offset, 64,read_id);
  loaded_metadata[set_index][tag_info.way] = false;
  return read_id;
}
static inline void swapp_temp_cache(dram_addr_t dram_addr, struct Info tag_info, spm_offset_t spm_offset,bool dirty){
  if (tag_info.dirty){
    spm_write_back(tag_info.spm_offset, tag_info.block_addr, 64, 0);
  }
  index_t set_index = get_cache_set_index(dram_addr);
  loaded_metadata[set_index][tag_info.way] = true;
  #ifdef ENABLE_TMU_HARDWARE
    long slot_idx = (set_index * CACHE_WAYS) + tag_info.way;
    long ret;
    TMU_INSN_R(F7_TMU_SET_TAG, ret, slot_idx, dram_addr); 
    TMU_INSN_R(F7_TMU_SET_SPM, ret, slot_idx, spm_offset); 
    if (dirty){
      TMU_INSN_R(F7_TMU_SET_D, ret, slot_idx, 0); 
    } else {
      TMU_INSN_R(F7_TMU_CLEAR_D, ret, slot_idx, 0); 
    }
  #else
    valid_metadata[set_index][tag_info.way] = true;
    dirty_metadata[set_index][tag_info.way] = dirty;
    access_count_metadata[set_index][tag_info.way] = 0;
    block_addr_metadata[set_index][tag_info.way] = dram_addr;
    spm_offset_metadata[set_index][tag_info.way] = spm_offset;
    ref_count_metadata[set_index][tag_info.way] = 0;
  #endif
  push_temp_buffer(tag_info.spm_offset);
}
// ------------------------
// ソフトウェア側で管理するメタデータ操作関数
// ------------------------
static inline bool is_mac_updated(index_t set_index, index_t way_index){
  return mac_updated_metadata[set_index][way_index];
}
static inline void setParentUpdated(index_t set_index,index_t way_index){
  // 親のタグが更新されている=evictionしても良い
  mac_updated_metadata[set_index][way_index] = true;
}
static inline void clearParentUpdated(index_t set_index,index_t way_index){
  // 更新した最大の高さ
  mac_updated_metadata[set_index][way_index] = false;
}

static inline void set_loaded(index_t set_index,index_t way_index){
  loaded_metadata[set_index][way_index] = true;
}
static inline void clear_loaded(index_t set_index,index_t way_index){
  loaded_metadata[set_index][way_index] = false;
}
static inline bool is_loaded(index_t set_index,index_t way_index){
  return loaded_metadata[set_index][way_index];
}

// --- 初期化関数 (mainの最初で呼ぶ) ---
void init_cache_system() {
    // 1. キャッシュメタデータの初期化 (初期配置をセット)
    #ifdef ENABLE_TMU_HARDWARE
      for (int s=0; s<CACHE_SETS; s++){
          for(int w=0; w<CACHE_WAYS; w++){
            loaded_metadata[s][w] = false;
            mac_updated_metadata[s][w] = true;
            access_count_metadata[s][w] = 0;
          }
      };
    #else
    spm_offset_t current_offset = CACHE_DATA_SPM_BASE;
    for(int s=0; s<CACHE_SETS; s++){
        for(int w=0; w<CACHE_WAYS; w++){
            valid_metadata[s][w] = false;
            dirty_metadata[s][w] = false;
            spm_offset_metadata[s][w] = current_offset; // 初期位置
            access_count_metadata[s][w] = 0;
            block_addr_metadata[s][w] = 0;
            mac_updated_metadata[s][w] = true;
            loaded_metadata[s][w] = false;
            current_offset += 64;
        }
    };
    #endif
}


// --- タグチェック関数 (ヒット/ミス判定および置換way決定、カウンター更新) ---
struct Info tag_check(dram_addr_t dram_addr){
  index_t set_index = get_cache_set_index(dram_addr);
  struct Info tag_info = {false, false, 0, 0, 0};
  #ifdef ENABLE_TMU_HARDWARE
    long ret;
    long rs1 = ((uint64_t)(set_index * CACHE_WAYS) << 32) | (uint64_t)(CACHE_WAYS);
    TMU_INSN_R(F7_TMU_CHECK_TAG, ret,  rs1,dram_addr); 
    tag_info.hit = (bool)(ret & 0x1);
    tag_info.way = (int8_t)((ret >> 32) & 0xFF);
    if (tag_info.way >= CACHE_WAYS){
      printf("Error: Invalid way index %d returned from TMU for addr=%016llx\n", tag_info.way, dram_addr);
      exit(1);
    }
    if (tag_info.hit){
      TMU_INSN_R(F7_TMU_IS_D, ret, set_index * CACHE_WAYS + tag_info.way, 0);
      tag_info.dirty = (bool)(ret & 0x1);
      // SPMオフセット取得
      tag_info.spm_offset = (spm_offset_t)get_cache_block_spm_offset(set_index, tag_info.way);
      // ブロックアドレス取得
      TMU_INSN_R(F7_TMU_GET_TAG, ret, set_index * CACHE_WAYS + tag_info.way, 0);
      tag_info.block_addr = (dram_addr_t)ret;
      // ヒット時はaccess_count更新
      for (int i = 0; i < CACHE_WAYS; ++i) {
        bool is_valid = is_block_valid(set_index, i);
        if (i != tag_info.way && is_valid) {
            uint32_t access_count = (access_count_metadata[set_index][i] + 1) & 0xF; // 4bitのアクセス数
            access_count_metadata[set_index][i] += 1;
        } else if (i == tag_info.way) {
            // 選ばれたwayのカウンターをリセット
            access_count_metadata[set_index][i] = 0;
        } 
      }
    } else if (tag_info.way >= 0) {
      // miss but found invalid way
      tag_info.dirty = false;
      tag_info.block_addr = 0;
      tag_info.spm_offset = (spm_offset_t)get_cache_block_spm_offset(set_index, tag_info.way);
      // validを立てる
      set_block_valid(set_index, tag_info.way);
      clear_loaded(set_index, tag_info.way);
    } else {
      // miss and need to select victim way
      // カウンターに基づいて置換wayを決定
      uint32_t lru_counter_max = 0;
      int8_t way_index = -1;
      for (index_t i = 0; i < CACHE_WAYS; ++i) {
          bool is_valid = is_block_valid(set_index, i);
          bool swappable = swappable_cache_block(set_index, i);
          if (is_valid && swappable) {
            if (lru_counter_max < access_count_metadata[set_index][i]) {
                lru_counter_max = access_count_metadata[set_index][i];
                way_index = i;
            }
          }
      }
      tag_info.way = way_index;
      if (way_index == -1){
        tag_info.dirty = false;
        tag_info.spm_offset = 0;
        tag_info.block_addr = 0;
      } else {
        // 置換wayの情報を取得
        tag_info.dirty = is_block_dirty(set_index, way_index);
        tag_info.spm_offset = (spm_offset_t)get_cache_block_spm_offset(set_index, way_index);
        TMU_INSN_R(F7_TMU_GET_TAG, ret, set_index * CACHE_WAYS + way_index, 0);
        tag_info.block_addr = (dram_addr_t)ret;
      }
    }
  #else
  int8_t way_index = -1;
  uint32_t lru_counter_max = 0;
    // wayを決定
  for (index_t i = 0; i < CACHE_WAYS; ++i) {
        if (valid_metadata[set_index][i]) {
          if (block_addr_metadata[set_index][i] == dram_addr) {
            way_index = i;
            tag_info.dirty = dirty_metadata[set_index][i];
            tag_info.hit = true;
            tag_info.spm_offset = spm_offset_metadata[set_index][i];
            tag_info.block_addr = dram_addr;
            tag_info.way = i;
            break;
          } else if (ref_count_metadata[set_index][i] == 0) {
            uint32_t access_count = (access_count_metadata[set_index][i] + 1) & 0xF; // 4bitのアクセス数
            if (access_count > lru_counter_max) {
                lru_counter_max = access_count;
                way_index = i;
            }
          }
        } else {
            // 空きwayが見つかった場合、そのwayを使用
            way_index = i;
            valid_metadata[set_index][i] = true; // 明示的に有効化
            // invalid_found = true;
            break;
        }
    }
  // 各セットはCACHE_WAYS分のラインを持つため、適切なオフセットを計算
  // カウンターをインクリメント
  for (uint64_t i = 0; i < CACHE_WAYS; ++i) {
      if (valid_metadata[set_index][i] &&  i != way_index && ref_count_metadata[set_index][i] == 0) {
          uint32_t access_count = (access_count_metadata[set_index][i] + 1) & 0xF; // 4bitのアクセス数
          access_count_metadata[set_index][i] = access_count;
      }
      if (i == way_index) {
          // 選ばれたwayのカウンターをリセット
          access_count_metadata[set_index][i] = 0;
      }
  }
  if (!tag_info.hit) {
    tag_info.spm_offset = spm_offset_metadata[set_index][way_index];
    tag_info.block_addr = block_addr_metadata[set_index][way_index];
    tag_info.dirty = dirty_metadata[set_index][way_index];
    tag_info.way = way_index;
  }
  #endif
  return tag_info;
}