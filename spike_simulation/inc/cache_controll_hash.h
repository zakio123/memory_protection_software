#include "config.h"
#include "mem_layout.h"
#include <stdio.h>
spm_offset_t temp_pool_stack[TEMP_POOL_SIZE];
int temp_pool_top = -1;
// キャッシュメタデータの配列　SoA形式
bool valid_metadata[TOTAL_SLOTS] = {0};
bool dirty_metadata[TOTAL_SLOTS] = {0};
bool mac_updated_metadata[TOTAL_SLOTS] = {0};
dram_addr_t block_addr_metadata[TOTAL_SLOTS] = {0};
spm_offset_t spm_offset_metadata[TOTAL_SLOTS] = {0};
uint32_t ref_count_metadata[TOTAL_SLOTS] = {0};
bool loaded_metadata[TOTAL_SLOTS] = {0};
int access_count_metadata[TOTAL_SLOTS] = {0};
struct Info {
    bool valid;
    bool dirty;
    bool hit;
    spm_offset_t spm_offset;
    dram_addr_t block_addr;
};

static inline index_t get_cache_hash_index(dram_addr_t dram_addr) {
    uint64_t key = dram_addr >> 6; // 64byteオフセットを捨てる
    key += 0x9e3779b97f4a7c15ULL;
    key = (key ^ (key >> 30)) * 0xbf58476d1ce4e5b9ULL;
    key = (key ^ (key >> 27)) * 0x94d049bb133111ebULL;
    key = key ^ (key >> 31);
    // key ^= (key >> 13);
    // key ^= (key >> 7);
    // key ^= (key >> 17);
    if (dram_addr < COUNTER_BASE) {
        return key % DATA_TAG_SLOTS_DM; 
    } else {
        return DATA_TAG_SLOTS_DM + (key % TREE_SLOTS_DM);
    }
}

static inline void setBlockdirty(index_t set_index){
  dirty_metadata[set_index] = true;
}

static inline void clearBlockdirty(index_t set_index){
  dirty_metadata[set_index] = false;
}

static inline bool is_mac_updated(index_t set_index){
  //
  // return cache_metadata[set_index][way_index].mac_updated;
  return mac_updated_metadata[set_index];
}
static inline void setParentUpdated(index_t set_index){
  // 親のタグが更新されている=evictionしても良い
  // cache_metadata[set_index][way_index].mac_updated = true;
  mac_updated_metadata[set_index] = true;
}
static inline void clearParentUpdated(index_t set_index){
  // 更新した最大の高さ
  // cache_metadata[set_index][way_index].mac_updated = false;
  mac_updated_metadata[set_index] = false;
}

static inline void set_loaded(index_t set_index){
  loaded_metadata[set_index] = true;
}
static inline void clear_loaded(index_t set_index){
  loaded_metadata[set_index] = false;
}
static inline bool is_loaded(index_t set_index){
  return loaded_metadata[set_index];
}

static inline bool acquire_cache_block(index_t set_index){
  // printf("Acquiring cache block S:%u, current ref_count=%u\n", set_index, ref_count_metadata[set_index]);
  // printf("set 240 ref count %u\n", ref_count_metadata[240]);
  access_count_metadata[set_index] += 1;
  if (valid_metadata[set_index] == false){
      printf("Error: Attempt to acquire invalid cache block S:%u\n", set_index);
      exit(1);
      return false;
  } else {
    ref_count_metadata[set_index] += 1;
    // printf("Cache block S:%u acquired, new ref_count=%u\n", set_index, ref_count_metadata[set_index]);
      return true;
    }
}
static inline void release_cache_block(index_t set_index){
  // printf("Releasing cache block S:%u, current ref_count=%u\n", set_index, ref_count_metadata[set_index]);
  // printf("set 240 ref count %u\n", ref_count_metadata[240]);
  if (valid_metadata[set_index] == false){
        printf("Error: Attempt to release invalid cache block S:%u\n", set_index);
        exit(1);
        return;
    }
    if (ref_count_metadata[set_index] == 0){
        printf("Error: Attempt to release cache block S:%u with ref_count 0\n", set_index);
        exit(1);
        return;
    }
    ref_count_metadata[set_index] -= 1;
}
void printf_access(){
  for (int i = 0; i < TOTAL_SLOTS; i++) {
      if (access_count_metadata[i] > 0) {
          printf("Cache Slot %d accessed %d times\n", i, access_count_metadata[i]);
      }
  }
}


static inline bool swappable_cache_block(index_t set_index){
  return (ref_count_metadata[set_index] == 0);
}

// --- 初期化関数 (mainの最初で呼ぶ) ---
void init_cache_system() {
    // 1. キャッシュメタデータの初期化 (初期配置をセット)
    spm_offset_t current_offset = CACHE_DATA_SPM_BASE;
    for(int s=0; s<TOTAL_SLOTS; s++){
      valid_metadata[s] = false;
      dirty_metadata[s] = false;
      spm_offset_metadata[s] = current_offset; // 初期位置
      block_addr_metadata[s] = 0;
      mac_updated_metadata[s] = true;
      loaded_metadata[s] = false;
      current_offset += 64;
    }
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


// --- タグチェック関数 (ヒット/ミス判定) ---
struct Info tag_check(dram_addr_t dram_addr){
  struct Info tag_info = {true,false, false, 0, 0};
  index_t set_index = get_cache_hash_index(dram_addr);
  if (valid_metadata[set_index]) {
      if (block_addr_metadata[set_index] == dram_addr) {
        tag_info.hit = true;
      } else {
        tag_info.hit = false;
      }
      tag_info.dirty = dirty_metadata[set_index];
      tag_info.spm_offset = spm_offset_metadata[set_index];
      tag_info.block_addr = block_addr_metadata[set_index];
  } else {
      // ミス、かつ無効行
      tag_info.hit = false;
      tag_info.spm_offset = spm_offset_metadata[set_index];
      tag_info.block_addr = block_addr_metadata[set_index];
      tag_info.dirty = false;
      valid_metadata[set_index] = true; // 明示的に有効化
  }
  if (ref_count_metadata[set_index] > 0 && tag_info.hit == false){
      tag_info.valid = false;
  }
  return tag_info;
}

// --- 軽量タグチェック (読み取り専用、ヒット/ミスのみ判定) ---
// 高速化のため、ヒットしたかと、空いているwayの探索のみを行う and 追い出しても良さそうなwayの探索
// typedef struct {
//     bool hit;
// } light_tag_info_t;
// static inline bool light_tag_check(dram_addr_t dram_addr){
//   index_t set_index = get_cache_set_index(dram_addr);
//   return info;
// }

spm_offset_t get_cache_block_spm_offset(index_t set_index){
  return spm_offset_metadata[set_index];
}
bool is_cache_block_dirty(index_t set_index){
  return dirty_metadata[set_index];
}

static inline dma_id_t ensureBlockInSpm(dram_addr_t required_dram_addr, struct Info tag_info,dma_id_t id){
  dma_id_t read_id = id;
  index_t set_index = get_cache_hash_index(required_dram_addr);
  if (ref_count_metadata[set_index] > 0){
    printf("Error: Attempt to evict cache block S:%u which is still in use (ref_count=%u) dram_addr %016llx\n", set_index, ref_count_metadata[set_index],required_dram_addr);
    exit(1);
  }
  if (tag_info.dirty) {

    spm_write_back(tag_info.spm_offset, tag_info.block_addr, 64,0);
  }
  spm_copy_to_local(required_dram_addr, tag_info.spm_offset, 64,read_id);
  valid_metadata[set_index] = true;
  dirty_metadata[set_index] = false;
  block_addr_metadata[set_index] = required_dram_addr;
  ref_count_metadata[set_index] = 0;
  loaded_metadata[set_index] = false;
  return read_id;
}


static inline void swapp_temp_cache(dram_addr_t dram_addr, struct Info tag_info, spm_offset_t spm_offset,bool dirty){
  index_t set_index = get_cache_hash_index(dram_addr);
  if (tag_info.dirty){
    spm_write_back(tag_info.spm_offset, tag_info.block_addr, 64, 0);
  }
  valid_metadata[set_index] = true;
  dirty_metadata[set_index] = dirty;
  block_addr_metadata[set_index] = dram_addr;
  spm_offset_metadata[set_index] = spm_offset;
  ref_count_metadata[set_index] = 0;
  loaded_metadata[set_index] = true;
  push_temp_buffer(tag_info.spm_offset);
}
