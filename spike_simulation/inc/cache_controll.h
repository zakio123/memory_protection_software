#include "config.h"
#include "mem_layout.h"
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
};
struct Info {
    bool dirty;
    bool hit;
    spm_offset_t spm_offset;
    dram_addr_t block_addr;
    uint8_t way;
};
struct CacheMetadata cache_metadata[CACHE_SETS][CACHE_WAYS] = {0};
static inline index_t get_cache_set_index(dram_addr_t dram_addr) {
    if (dram_addr < COUNTER_BASE) {
        // Data Tag領域
        return ((dram_addr) / 64) % DATA_TAG_SETS;
    } else {
        // Counter Tree領域
        return ((dram_addr) / 64) % TREE_SETS + DATA_TAG_SETS;
    }
}

static inline void setBlockdirty(dram_addr_t dram_addr,index_t way_index){
  index_t set_index = get_cache_set_index(dram_addr);
  cache_metadata[set_index][way_index].dirty = true;
}
static inline void clearBlockdirty(dram_addr_t dram_addr,index_t way_index){
  index_t set_index = get_cache_set_index(dram_addr);
  cache_metadata[set_index][way_index].dirty = false;
}

static inline bool is_mac_updated(dram_addr_t dram_addr, index_t way_index){
  index_t set_index = get_cache_set_index(dram_addr);
  return cache_metadata[set_index][way_index].mac_updated;
}
static inline void setParentUpdated(dram_addr_t dram_addr,index_t way_index){
  // 親のタグが更新されている=evictionしても良い
  index_t set_index = get_cache_set_index(dram_addr);
  cache_metadata[set_index][way_index].mac_updated = true;
}
static inline void clearParentUpdated(dram_addr_t dram_addr,index_t way_index){
  // 更新した最大の高さ
  index_t set_index = get_cache_set_index(dram_addr);
  cache_metadata[set_index][way_index].mac_updated = false;
}

// --- 初期化関数 (mainの最初で呼ぶ) ---
static inline void init_cache_system() {
    // 1. キャッシュメタデータの初期化 (初期配置をセット)
    spm_offset_t current_offset = CACHE_DATA_SPM_BASE;
    for(int s=0; s<CACHE_SETS; s++){
        for(int w=0; w<CACHE_WAYS; w++){
            cache_metadata[s][w].valid = false;
            cache_metadata[s][w].dirty = false;
            cache_metadata[s][w].spm_offset = current_offset; // 初期位置
            cache_metadata[s][w].access_count = 0;
            cache_metadata[s][w].block_addr = 0;
            cache_metadata[s][w].mac_updated = true;
            cache_metadata[s][w].locked = false;
            current_offset += 64;
        }
    };
    // 2. Temp Poolの初期化 (キャッシュに使われていない領域をプールに積む)
    temp_pool_top = -1;
    for(int i=0; i<TEMP_POOL_SIZE; i++){
        temp_pool_stack[++temp_pool_top] = current_offset + (i * 64);
    }
    temp_pool_top = TEMP_POOL_SIZE - 1;
}

// --- Pool操作関数 ---
static inline spm_offset_t pop_temp_buffer() {
    if (temp_pool_top < 0) {
        // エラーハンドリング: ここに来ることは設計上ないはず
        return 0;
    }
    return temp_pool_stack[temp_pool_top--];
}

static inline void push_temp_buffer(spm_offset_t spm_addr) {
    if (temp_pool_top >= TEMP_POOL_SIZE - 1) {
        printf("Error: Temp pool overflow!\n");
        return;
    }
    temp_pool_stack[++temp_pool_top] = spm_addr;
}

// tempアレイの管理
typedef struct {
    bool        valid;
    bool        dirty;
    dram_addr_t dram_addr;
    spm_offset_t spm_offset;
} temp_entry_t;

static temp_entry_t temp_table[TEMP_POOL_SIZE];
void temp_system_init(spm_offset_t temp_region_base){
    // temp_table を無効化
    for (int i = 0; i < TEMP_POOL_SIZE; i++) {
        temp_table[i].valid = false;
        temp_table[i].dirty = false;
        temp_table[i].dram_addr = 0;
        temp_table[i].spm_offset = 0;
    }
    // free stack に SPM オフセットを積む
    temp_pool_top = -1;
    for (int i = 0; i < TEMP_POOL_SIZE; i++) {
        temp_pool_stack[++temp_pool_top] = temp_region_base + i*64;
    }
}
static int find_temp_entry(dram_addr_t dram_addr) {
    for (int i = 0; i < TEMP_POOL_SIZE; i++) {
        if (temp_table[i].valid && temp_table[i].dram_addr == dram_addr) {
            return i;
        }
    }
    return -1; // 見つからなかった
}
static spm_offset_t get_temp_spm_offset(int idx) {
    return temp_table[idx].spm_offset;
}
static int alloc_temp_entry(dram_addr_t dram_addr, spm_offset_t spm_offset) {
    for (int i = 0; i < TEMP_POOL_SIZE; i++) {
        if (!temp_table[i].valid) {
            temp_table[i].valid = true;
            temp_table[i].dirty = false;
            temp_table[i].dram_addr = dram_addr;
            temp_table[i].spm_offset = spm_offset;
            return i;
        }
    }
    return -1; // 空きエントリがない
}
static void invalidate_temp_entry_by_index(int idx){
    if (idx < 0 || temp_table[idx].valid == false) {
      printf("Error: Attempt to invalidate invalid temp entry index %d\n", idx);
      return;
    }
    temp_table[idx].valid = false;
    temp_table[idx].dirty = false;
}
static void dirty_temp_entry_by_index(int idx){
    if (idx < 0 || temp_table[idx].valid == false) {
      printf("Error: Attempt to dirty invalid temp entry index %d\n", idx);
      return;
    }
    temp_table[idx].dirty = true;
}
static bool is_dirty_temp_entry_by_index(int idx){
    if (idx < 0 || temp_table[idx].valid == false) {
      printf("Error: Attempt to check dirty status of invalid temp entry index %d\n", idx);
      return false;
    }
    return temp_table[idx].dirty;
}
// --- タグチェック関数 (ヒット/ミス判定および置換way決定、カウンター更新) ---
struct Info tag_check(dram_addr_t dram_addr){
  struct Info tag_info = {false, false, 0, 0, 0};
  index_t set_index = get_cache_set_index(dram_addr);
  uint32_t count = 0;
  index_t way_index = 0;
  uint32_t lru_counter_max = 0;
    // wayを決定
  for (index_t i = 0; i < CACHE_WAYS; ++i) {
        if (cache_metadata[set_index][i].valid) {
          if (cache_metadata[set_index][i].block_addr == dram_addr) {
            // タグが一致した場合、そのwayを使用
            way_index = i;
            tag_info.dirty = cache_metadata[set_index][i].dirty;
            tag_info.hit = true;
            tag_info.spm_offset = cache_metadata[set_index][i].spm_offset;
            tag_info.block_addr = dram_addr;
            tag_info.way = i;
            break;
          } else {
            uint32_t access_count = (cache_metadata[set_index][i].access_count + 1) & 0xF; // 4bitのアクセス数
            if (access_count > lru_counter_max) {
                lru_counter_max = access_count;
                way_index = i;
            }
          }
        } else {
          // 空きwayが見つかった場合、そのwayを使用
          way_index = i;
          cache_metadata[set_index][i].valid = true; // 明示的に有効化
          break;
        }
    }
  // 各セットはCACHE_WAYS分のラインを持つため、適切なオフセットを計算
  // カウンターをインクリメント
  for (uint64_t i = 0; i < CACHE_WAYS; ++i) {
      if (cache_metadata[set_index][i].valid &&  i != way_index) {
          uint32_t access_count = (cache_metadata[set_index][i].access_count + 1) & 0xF; // 4bitのアクセス数
          cache_metadata[set_index][i].access_count = access_count;
      }
      if (i == way_index) {
          // 選ばれたwayのカウンターをリセット
          cache_metadata[set_index][i].access_count = 0;
      }
  }
  if (!tag_info.hit) {
    tag_info.spm_offset = cache_metadata[set_index][way_index].spm_offset;
    tag_info.block_addr = cache_metadata[set_index][way_index].block_addr;
    tag_info.dirty = cache_metadata[set_index][way_index].dirty;
    tag_info.way = way_index;
  }
  return tag_info;
}

// --- 軽量タグチェック (読み取り専用、ヒット/ミスのみ判定) ---
static inline bool light_tag_check(dram_addr_t dram_addr){
  index_t set_index = get_cache_set_index(dram_addr);
  for (index_t i = 0; i < CACHE_WAYS; ++i) {
    if (cache_metadata[set_index][i].valid) {
      if (cache_metadata[set_index][i].block_addr == dram_addr) {
        return true;
      }
    }
  }
  return false;
}

