#include "config.h"
#include "mem_layout.h"
#include "temp_controll.h"
#include <stdio.h>
spm_offset_t temp_pool_stack[TEMP_POOL_SIZE];
int temp_pool_top = -1;
struct CacheMetadata{
    bool valid;
    bool dirty;
    bool mac_updated; // trueなら親ノード更新ずみ、falseなら未更新
    bool locked;
    uint32_t access_count;
    dram_addr_t block_addr;
    spm_offset_t spm_offset;
    uint32_t ref_count;
};
// キャッシュメタデータの配列　SoA形式
bool valid_metadata[CACHE_SETS][CACHE_WAYS] = {0};
bool dirty_metadata[CACHE_SETS][CACHE_WAYS] = {0};
bool mac_updated_metadata[CACHE_SETS][CACHE_WAYS] = {0};
uint32_t access_count_metadata[CACHE_SETS][CACHE_WAYS] = {0};
dram_addr_t block_addr_metadata[CACHE_SETS][CACHE_WAYS] = {0};
spm_offset_t spm_offset_metadata[CACHE_SETS][CACHE_WAYS] = {0};
uint32_t ref_count_metadata[CACHE_SETS][CACHE_WAYS] = {0};
bool loaded_metadata[CACHE_SETS][CACHE_WAYS] = {0};

struct Info {
    bool dirty;
    bool hit;
    spm_offset_t spm_offset;
    dram_addr_t block_addr;
    int8_t way;
};
// struct CacheMetadata cache_metadata[CACHE_SETS][CACHE_WAYS] = {0};
static inline index_t get_cache_set_index(dram_addr_t dram_addr) {
    if (dram_addr < COUNTER_BASE) {
        // Data Tag領域
        return ((dram_addr) / 64) % DATA_TAG_SETS;
    } else {
        // Counter Tree領域
        return ((dram_addr) / 64) % TREE_SETS + DATA_TAG_SETS;
    }
}

static inline void setBlockdirty(index_t set_index,index_t way_index){
  // index_t set_index = get_cache_set_index(dram_addr);
  // cache_metadata[set_index][way_index].dirty = true;
  dirty_metadata[set_index][way_index] = true;
}
static inline void clearBlockdirty(index_t set_index,index_t way_index){
  // index_t set_index = get_cache_set_index(dram_addr);
  // cache_metadata[set_index][way_index].dirty = false;
  dirty_metadata[set_index][way_index] = false;
}

static inline bool is_mac_updated(index_t set_index, index_t way_index){
  //
  // return cache_metadata[set_index][way_index].mac_updated;
  return mac_updated_metadata[set_index][way_index];
}
static inline void setParentUpdated(index_t set_index,index_t way_index){
  // 親のタグが更新されている=evictionしても良い
  // index_t set_index = get_cache_set_index(dram_addr);
  // cache_metadata[set_index][way_index].mac_updated = true;
  mac_updated_metadata[set_index][way_index] = true;
}
static inline void clearParentUpdated(index_t set_index,index_t way_index){
  // 更新した最大の高さ
  // index_t set_index = get_cache_set_index(dram_addr);
  // cache_metadata[set_index][way_index].mac_updated = false;
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

static inline bool acquire_cache_block(index_t set_index, index_t way_index){
  if (valid_metadata[set_index][way_index] == false){
    printf("Error: Attempt to acquire invalid cache block S:%u W:%u\n", set_index, way_index);
      return false;
  } else {
    ref_count_metadata[set_index][way_index] += 1;
      return true;
    }
}
static inline void release_cache_block(index_t set_index, index_t way_index){
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
}

static inline bool swappable_cache_block(index_t set_index, index_t way_index){
  return (ref_count_metadata[set_index][way_index] == 0);
}



// --- 初期化関数 (mainの最初で呼ぶ) ---
void init_cache_system() {
    // 1. キャッシュメタデータの初期化 (初期配置をセット)
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
}


// --- タグチェック関数 (ヒット/ミス判定および置換way決定、カウンター更新) ---
struct Info tag_check(dram_addr_t dram_addr){
  struct Info tag_info = {false, false, 0, 0, 0};
  index_t set_index = get_cache_set_index(dram_addr);
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
  // if (invalid_found){
  //   valid_metadata[set_index][way_index] = true;
  // }
  return tag_info;
}

// --- 軽量タグチェック (読み取り専用、ヒット/ミスのみ判定) ---
// 高速化のため、ヒットしたかと、空いているwayの探索のみを行う and 追い出しても良さそうなwayの探索
typedef struct {
    bool hit;
    int8_t way;
} light_tag_info_t;
static inline light_tag_info_t light_tag_check(dram_addr_t dram_addr){
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
}

spm_offset_t get_cache_block_spm_offset(index_t set_index, index_t way_index){
  return spm_offset_metadata[set_index][way_index];
}
bool is_cache_block_dirty(index_t set_index, index_t way_index){
  return dirty_metadata[set_index][way_index];
}

void update_counter_on_access(index_t set_index, index_t way_index){
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
}

index_t way_search_for_dram_addr(dram_addr_t dram_addr, index_t set_index){

  int8_t way_index = -1;
  uint32_t lru_counter_max = 0;
  // wayを決定
  for (index_t i = 0; i < CACHE_WAYS; ++i) {
        if (valid_metadata[set_index][i]) {
          if (block_addr_metadata[set_index][i] == dram_addr) {
            way_index = i;
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
  return way_index;
}

static inline dma_id_t ensureBlockInSpm(dram_addr_t required_dram_addr, struct Info tag_info,dma_id_t id){
  dma_id_t read_id = id;
  index_t set_index = get_cache_set_index(required_dram_addr);
  if (tag_info.dirty) {
    if (ref_count_metadata[set_index][tag_info.way] > 0){
      exit(1);
    }
    spm_write_back(tag_info.spm_offset, tag_info.block_addr, 64,0);
  }
  spm_copy_to_local(required_dram_addr, tag_info.spm_offset, 64,read_id);
  valid_metadata[set_index][tag_info.way] = true;
  dirty_metadata[set_index][tag_info.way] = false;
  access_count_metadata[set_index][tag_info.way] = 0;
  block_addr_metadata[set_index][tag_info.way] = required_dram_addr;
  ref_count_metadata[set_index][tag_info.way] = 0;
  loaded_metadata[set_index][tag_info.way] = false;
  return read_id;
}


static inline void swapp_temp_cache(dram_addr_t dram_addr, struct Info tag_info, spm_offset_t spm_offset,bool dirty){
  index_t set_index = get_cache_set_index(dram_addr);
  if (tag_info.dirty){
    dram_addr_t debug_addr = 0x0000000510001940;
    spm_write_back(tag_info.spm_offset, tag_info.block_addr, 64, 0);
  }
  valid_metadata[set_index][tag_info.way] = true;
  dirty_metadata[set_index][tag_info.way] = dirty;
  access_count_metadata[set_index][tag_info.way] = 0;
  block_addr_metadata[set_index][tag_info.way] = dram_addr;
  spm_offset_metadata[set_index][tag_info.way] = spm_offset;
  ref_count_metadata[set_index][tag_info.way] = 0;
  loaded_metadata[set_index][tag_info.way] = true;
  push_temp_buffer(tag_info.spm_offset);
}
