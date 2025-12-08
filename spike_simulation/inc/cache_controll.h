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

static inline void setBlockdirty(dram_addr_t dram_addr,index_t way_index){
  index_t set_index = get_cache_set_index(dram_addr);
  // cache_metadata[set_index][way_index].dirty = true;
  dirty_metadata[set_index][way_index] = true;
}
static inline void clearBlockdirty(dram_addr_t dram_addr,index_t way_index){
  index_t set_index = get_cache_set_index(dram_addr);
  // cache_metadata[set_index][way_index].dirty = false;
  dirty_metadata[set_index][way_index] = false;
}

static inline bool is_mac_updated(dram_addr_t dram_addr, index_t way_index){
  index_t set_index = get_cache_set_index(dram_addr);
  //
  // return cache_metadata[set_index][way_index].mac_updated;
  return mac_updated_metadata[set_index][way_index];
}
static inline void setParentUpdated(dram_addr_t dram_addr,index_t way_index){
  // 親のタグが更新されている=evictionしても良い
  index_t set_index = get_cache_set_index(dram_addr);
  // cache_metadata[set_index][way_index].mac_updated = true;
  mac_updated_metadata[set_index][way_index] = true;
}
static inline void clearParentUpdated(dram_addr_t dram_addr,index_t way_index){
  // 更新した最大の高さ
  index_t set_index = get_cache_set_index(dram_addr);
  // cache_metadata[set_index][way_index].mac_updated = false;
  mac_updated_metadata[set_index][way_index] = false;
}

static inline void set_loaded(dram_addr_t dram_addr,index_t way_index){
  index_t set_index = get_cache_set_index(dram_addr);
  loaded_metadata[set_index][way_index] = true;
}
static inline void clear_loaded(dram_addr_t dram_addr,index_t way_index){
  index_t set_index = get_cache_set_index(dram_addr);
  loaded_metadata[set_index][way_index] = false;
}
static inline bool is_loaded(dram_addr_t dram_addr,index_t way_index){
  index_t set_index = get_cache_set_index(dram_addr);
  return loaded_metadata[set_index][way_index];
}

static inline bool acquire_cache_block(dram_addr_t dram_addr, index_t way_index){
  index_t set_index = get_cache_set_index(dram_addr);
    if (valid_metadata[set_index][way_index] == false){
        return false;
    } else {
      ref_count_metadata[set_index][way_index] += 1;
      return true;
    }
}
static inline void release_cache_block(dram_addr_t dram_addr, index_t way_index){
    index_t set_index = get_cache_set_index(dram_addr);
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

// --- Pool操作関数 ---
static inline spm_offset_t pop_temp_buffer() {
    // if (temp_pool_top < 0) {
    //     // エラーハンドリング: ここに来ることは設計上ないはず
    //     return 0;
    // }
    return temp_pool_stack[temp_pool_top--];
}

static inline void push_temp_buffer(spm_offset_t spm_addr) {
    // if (temp_pool_top >= TEMP_POOL_SIZE - 1) {
    //     printf("Error: Temp pool overflow!\n");
    //     return;
    // }
    temp_pool_stack[++temp_pool_top] = spm_addr;
}

// tempアレイの管理
typedef struct {
    bool        valid;
    bool        dirty;
    int     ref_count;
    dram_addr_t dram_addr;
    spm_offset_t spm_offset;
    bool loaded; // データがSPMにロード済みか
} temp_entry_t;

// static temp_entry_t temp_table[TEMP_POOL_SIZE];
static bool temp_valid[TEMP_POOL_SIZE] = {0};
static bool temp_dirty[TEMP_POOL_SIZE] = {0};
static int temp_ref_count[TEMP_POOL_SIZE] = {0};
static dram_addr_t temp_dram_addr[TEMP_POOL_SIZE] = {0};
static spm_offset_t temp_spm_offset[TEMP_POOL_SIZE] = {0};
static bool temp_loaded[TEMP_POOL_SIZE] = {0};

// ★追加: 高速化用管理構造
static int free_indices[TEMP_POOL_SIZE];    // 空きスロットのインデックススタック
static int free_indices_top = -1;

static int active_indices[TEMP_POOL_SIZE];  // 使用中スロットのインデックスリスト
static int active_count = 0;                // 現在の使用数

static int pos_in_active_list[TEMP_POOL_SIZE]; // 逆引き: temp_tableのindex -> active_indicesの場所


static inline void temp_system_init(spm_offset_t temp_region_base){
    // テーブル初期化
    for (int i = 0; i < TEMP_POOL_SIZE; i++) {
        // { temp_table[i].valid = false;
          // temp_table[i].dirty = false;
          // temp_table[i].dram_addr = 0;
          // temp_table[i].spm_offset = 0;
          // temp_table[i].ref_count = 0;
          // temp_table[i].loaded = false;}
        temp_valid[i] = false;
        temp_dirty[i] = false;
        temp_dram_addr[i] = 0;
        temp_spm_offset[i] = 0;
        temp_ref_count[i] = 0;
        temp_loaded[i] = false;
        // ★空きスタックに全てのインデックスを積む
        free_indices[i] = i;
        // 逆引きマップ初期化（念のため-1）
        pos_in_active_list[i] = -1;
    }
    free_indices_top = TEMP_POOL_SIZE - 1; // スタックトップ
    active_count = 0;
    // SPMオフセットスタックの初期化（既存通り）
    temp_pool_top = -1;
    for (int i = 0; i < TEMP_POOL_SIZE; i++) {
        temp_pool_stack[++temp_pool_top] = temp_region_base + i*64;
    }
}

static inline int find_temp_entry(dram_addr_t dram_addr) {
    for (int k = 0; k < active_count; k++) {
        int idx = active_indices[k]; // 有効なインデックスを取り出す
        if (temp_dram_addr[idx] == dram_addr) {
            return idx;
        }
    }
    return -1; // 見つからなかった
}
static inline spm_offset_t get_temp_spm_offset(int idx) {
    return temp_spm_offset[idx];
}
static inline int alloc_temp_entry(dram_addr_t dram_addr, spm_offset_t spm_offset) {
  if (free_indices_top < 0) {
        return -1; // 空きがない
    }
    // 1. 空きスタックからインデックスをポップ
    int idx = free_indices[free_indices_top--];
    // 2. データをセット
    temp_valid[idx] = true;
    temp_dirty[idx] = false;
    temp_dram_addr[idx] = dram_addr;
    temp_spm_offset[idx] = spm_offset;
    temp_ref_count[idx] = 0;
    // 3. Activeリストの末尾に追加
    active_indices[active_count] = idx;
    pos_in_active_list[idx] = active_count; // 逆引き情報の記録
    active_count++;
    return idx;
}
static inline void invalidate_temp_entry_by_index(int idx){
    if (idx < 0 || temp_valid[idx] == false) {
      printf("Error: Attempt to invalidate invalid temp entry index %d\n", idx);
      return;
    }
    if (temp_ref_count[idx] > 0) {
      printf("Error: Attempt to invalidate temp entry index %d which is still in use (ref_count=%d)\n", idx, temp_ref_count[idx]);
      return;
    }
    temp_valid[idx] = false;
    temp_dirty[idx] = false;
    temp_loaded[idx] = false;
    // 2. Activeリストから削除 (Swap removal)
    int pos = pos_in_active_list[idx];     // 削除対象のリスト内の位置
    int last_idx = active_indices[active_count - 1]; // リストの最後の要素
    // 削除対象の場所に、最後の要素を移動させる
    active_indices[pos] = last_idx;
    pos_in_active_list[last_idx] = pos; // 移動させた要素の逆引きも更新
    active_count--; // サイズを減らす
    // 3. 空きスタックにプッシュ（再利用可能にする）
    free_indices[++free_indices_top] = idx;
}
static void dirty_temp_entry_by_index(int idx){
    // if (idx < 0 || temp_table[idx].valid == false) {
    //   printf("Error: Attempt to dirty invalid temp entry index %d\n", idx);
    //   return;
    // }
    temp_dirty[idx] = true;
}
static bool is_dirty_temp_entry_by_index(int idx){
    // if (idx < 0 || temp_valid[idx] == false) {
    //   printf("Error: Attempt to check dirty status of invalid temp entry index %d\n", idx);
    //   return false;
    // }
    return temp_dirty[idx];
}
static bool acquire_temp_entry_by_index(int idx){
    // if (idx < 0 || temp_valid[idx] == false) {
    //   printf("Error: Attempt to acquire invalid temp entry index %d\n", idx);
    //   return false;
    // }
    temp_ref_count[idx] += 1;
    return true;
  }
static bool release_temp_entry_by_index(int idx){
    // if (idx < 0 || temp_valid[idx] == false) {
    //   printf("Error: Attempt to release invalid temp entry index %d\n", idx);
    //   return false;
    // }
    // if (temp_ref_count[idx] == 0) {
    //   printf("Error: Attempt to release temp entry index %d which has ref_count 0\n", idx);
    //   return false;
    // }
    temp_ref_count[idx] -= 1;
    return true;
  }


static inline void set_loaded_temp_entry_by_index(int idx){
    // if (idx < 0 || temp_valid[idx] == false) {
    //   printf("Error: Attempt to set loaded status of invalid temp entry index %d\n", idx);
    //   return;
    // }
    temp_loaded[idx] = true;
}
static inline bool is_loaded_temp_entry_by_index(int idx){
    // if (idx < 0 || temp_valid[idx] == false) {
    //   printf("Error: Attempt to check loaded status of invalid temp entry index %d\n", idx);
    //   return false;
    // }
    return temp_loaded[idx];
}

static inline bool swappable_temp_entry_by_index(int idx){
    // if (idx < 0 || temp_valid[idx] == false) {
    //   printf("Error: Attempt to check swappable status of invalid temp entry index %d\n", idx);
    //   return false;
    // }
    return (temp_ref_count[idx] == 0);
}

void printf_temp_table_status(int idx){
    if (idx < 0 || temp_valid[idx] == false) {
      printf("Temp Entry %d is invalid.\n", idx);
      return;
    }
    printf("Temp Entry %d Status:\n", idx);
    printf("  Valid: %d\n", temp_valid[idx]);
    printf("  Dirty: %d\n", temp_dirty[idx]);
    printf("  Dram Addr: %016llx\n", temp_dram_addr[idx]);
    printf("  SPM Offset: %016llx\n", temp_spm_offset[idx]);
    printf("  Ref Count: %d\n", temp_ref_count[idx]);
    printf("  Loaded: %d\n", temp_loaded[idx]);
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
        block_addr_metadata[set_index][i] = dram_addr;
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