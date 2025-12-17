#include "config.h"

spm_offset_t temp_pool_stack[TEMP_POOL_SIZE];
int temp_pool_top;

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
        free_indices[i] = i;
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
    if (idx < 0 || temp_valid[idx] == false) {
      printf("Error: Attempt to release invalid temp entry index %d\n", idx);
      return false;
    }
    if (temp_ref_count[idx] == 0) {
      printf("Error: Attempt to release temp entry index %d which has ref_count 0\n", idx);
      return false;
    }
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

