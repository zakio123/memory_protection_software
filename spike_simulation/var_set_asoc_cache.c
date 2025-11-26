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
#include "mem_layout.h"
#include "util.h"
#define PROTECTION_BASE  MAIN_PROTECTION_BASE
#define HEIGHT  MAIN_HEIGHT
#define PROTECTION_SIZE MAIN_PROTECTION_SIZE
#define DATA_TAG_BASE  (PROTECTION_BASE + PROTECTION_SIZE) // 0x04000000
#define DATA_TAG_SIZE  (PROTECTION_SIZE / 8) // 8MB
#define COUNTER_BASE (DATA_TAG_BASE + DATA_TAG_SIZE) // 0x04800000
// SPM内でのキャッシュメタデータ領域のベースアドレス (例: SPMの 56 * 64 から開始)
#define DATA_SPM_OFFSET (0x40)
#define CACHE_WAYS (4)
#define CACHE_SETS (128) // 768line
#define CACHE_DATA_SPM_BASE (64 * 4) // データ領域のベースアドレス
#define SPM_METADATA_BASE (CACHE_DATA_SPM_BASE + (CACHE_SETS * CACHE_WAYS * 64)) // メタデータ領域のベースアドレス
#define DATA_TAG_SETS (8)
#define TREE_SETS (120)

#define TEMP_POOL_SIZE (16)
uint32_t temp_pool_stack[TEMP_POOL_SIZE];
int temp_pool_top = -1;
struct CacheMetadata{
    bool valid;
    bool dirty;
    bool parent_updated; // trueなら親ノード更新ずみ、falseなら未更新
    bool locked;
    uint32_t access_count;
    uint64_t block_addr;
    uint32_t spm_offset;
};
struct CacheMetadata cache_metadata[CACHE_SETS][CACHE_WAYS] = {0};
// --- 初期化関数 (mainの最初で呼ぶ) ---
void init_cache_system() {
    // 1. キャッシュメタデータの初期化 (初期配置をセット)
    uint64_t current_offset = CACHE_DATA_SPM_BASE;
    for(int s=0; s<CACHE_SETS; s++){
        for(int w=0; w<CACHE_WAYS; w++){
            cache_metadata[s][w].valid = false;
            cache_metadata[s][w].dirty = false;
            cache_metadata[s][w].spm_offset = current_offset; // 初期位置
            cache_metadata[s][w].access_count = 0;
            cache_metadata[s][w].block_addr = 0;
            cache_metadata[s][w].parent_updated = true;
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
uint64_t pop_temp_buffer() {
    if (temp_pool_top < 0) {
        // エラーハンドリング: ここに来ることは設計上ないはず
        printf("Error: Temp pool empty!\n");
        return 0;
    }
    return temp_pool_stack[temp_pool_top--];
}

void push_temp_buffer(uint64_t spm_addr) {
    if (temp_pool_top >= TEMP_POOL_SIZE - 1) {
        printf("Error: Temp pool overflow!\n");
        return;
    }
    temp_pool_stack[++temp_pool_top] = spm_addr;
}


struct Info {
    bool valid;
    bool dirty;
    bool hit;
    uint32_t spm_offset;
    uint64_t block_addr;
    uint8_t way;
};
static inline uint32_t get_cache_set_index(uint64_t dram_addr) {
    if (dram_addr < COUNTER_BASE) {
        // Data Tag領域
        return ((dram_addr) / 64) % DATA_TAG_SETS;
    } else {
        // Merkle Tree領域
        return ((dram_addr) / 64) % TREE_SETS + DATA_TAG_SETS;
    }
}

static inline void setBlockdirty(uint64_t dram_addr,uint32_t way_index){
  uint32_t set_index = get_cache_set_index(dram_addr);
  cache_metadata[set_index][way_index].dirty = true;
}
static inline void clearBlockdirty(uint64_t dram_addr,uint32_t way_index){
  uint32_t set_index = get_cache_set_index(dram_addr);
  cache_metadata[set_index][way_index].dirty = false;
}

static inline void setParentUpdated(uint64_t dram_addr,uint32_t way_index){
  // 親のタグが更新されている=evictionしても良い
  uint32_t set_index = get_cache_set_index(dram_addr);
  cache_metadata[set_index][way_index].parent_updated = true;
}
static inline void clearParentUpdated(uint64_t dram_addr,uint32_t way_index){
  // 更新した最大の高さ
  uint32_t set_index = get_cache_set_index(dram_addr);
  cache_metadata[set_index][way_index].parent_updated = false;
}

bool is_parent_update(uint32_t dram_addr, uint32_t way_index){
  uint32_t set_index = get_cache_set_index(dram_addr);
  return cache_metadata[set_index][way_index].parent_updated;
}

uint64_t ensureBlockInSpm(uint64_t required_block_addr, struct Info tag_info,uint64_t id){
  uint64_t read_id = id;
  uint64_t tmp = 0x000000049035ba80;
  if (tag_info.dirty) {
    // Dirtyなら書き戻し
    spm_write_back(tag_info.spm_offset, tag_info.block_addr, 64,0);
  }
  spm_copy_to_local(required_block_addr, tag_info.spm_offset, 64,read_id);
  int way_index = tag_info.way;
  int set_index = get_cache_set_index(required_block_addr);
  cache_metadata[set_index][way_index].valid = true;
  cache_metadata[set_index][way_index].dirty = false;
  cache_metadata[set_index][way_index].access_count = 0;
  cache_metadata[set_index][way_index].block_addr = required_block_addr;
  return read_id;
}

static inline void swapp_temp_cache(uint64_t dram_addr, struct Info tag_info, uint32_t spm_offset,bool dirty){
  uint32_t set_index = get_cache_set_index(dram_addr);
  if (tag_info.valid && tag_info.dirty){
    spm_write_back(tag_info.spm_offset, tag_info.block_addr, 64, 0);
  }    
  cache_metadata[set_index][tag_info.way].spm_offset = spm_offset;
  cache_metadata[set_index][tag_info.way].valid = true;
  cache_metadata[set_index][tag_info.way].dirty = dirty;
  cache_metadata[set_index][tag_info.way].access_count = 0;
  cache_metadata[set_index][tag_info.way].block_addr = dram_addr;
  push_temp_buffer(tag_info.spm_offset);
}


static inline struct Info tag_check(uint64_t dram_addr){
  struct Info tag_info = {false, false, false, 0, 0, 0};
  uint32_t set_index = get_cache_set_index(dram_addr);
  uint64_t count = 0;
  uint64_t way_index = 0;
  uint32_t lru_counter_max = 0;
    // wayを決定
  for (uint64_t i = 0; i < CACHE_WAYS; ++i) {
        if (cache_metadata[set_index][i].valid) {
          if (cache_metadata[set_index][i].block_addr == dram_addr) {
            // タグが一致した場合、そのwayを使用
            way_index = i;
            tag_info.valid = true;
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
    tag_info.valid = cache_metadata[set_index][way_index].valid;
    tag_info.dirty = cache_metadata[set_index][way_index].dirty;
    tag_info.way = way_index;
  }
  return tag_info;
}

uint64_t calculate_level_base_addr(uint64_t level) {
    uint64_t offset = 64 * ((1 << (5 * (level-1))) - 1) / (32 - 1);
    return offset;
}

uint64_t get_counterblock_addr(uint64_t request_addr){
    uint64_t counterblock_addr = COUNTER_BASE + (((request_addr - PROTECTION_BASE) / (64 * 32))) * 64 + calculate_level_base_addr(HEIGHT);
    return counterblock_addr;
}

uint64_t get_datamacblock_addr(uint64_t request_addr){
    uint64_t datamacblock_addr = DATA_TAG_BASE + (((request_addr - PROTECTION_BASE) / (64 * 8))) * 64;
    return datamacblock_addr;
}

bool verify_one_height(uint32_t child_spm_offset, uint32_t parent_spm_offset, uint64_t node_index, uint64_t child_id){
  mac_init();
  if (parent_spm_offset == 0){
      mac_buffer_set(0);
      mac_update(0,63);
  } else {
      uint64_t start_bit = 64 + (node_index / 32) % 32 * 8;
      mac_buffer_set(parent_spm_offset);
      mac_update(start_bit, start_bit + 7);
  }
  spm_wait(child_id);
  mac_buffer_set(child_spm_offset);
  mac_update(0, 447);
  uint64_t computed_mac = mac_final();
  uint64_t stored_mac = spm_ld64(child_spm_offset + 56);
  if (computed_mac != stored_mac){
    printf("[Core FW] MAC verification failed: computed=%016llx, stored=%016llx\n", computed_mac, stored_mac);
    return false;
  }
  return true;
}

void update_one_height(uint32_t child_spm_offset, uint32_t parent_spm_offset, uint64_t node_index, bool update_counter){
  mac_init();
  if (parent_spm_offset == 0){
      uint64_t root = spm_ld64(parent_spm_offset);
      root += 1;
      spm_sd64(parent_spm_offset, root);
      mac_buffer_set(0);
      mac_update(0,63);
  } else {
      uint64_t start_bit = 64 + (node_index / 32) % 32 * 8;
      mac_buffer_set(parent_spm_offset);
      mac_update(start_bit, start_bit + 7);
  }
  // ブロックの更新
  if (update_counter){
    uint64_t major_counter = spm_ld64(child_spm_offset);
    uint64_t minor_counter_byte_address = child_spm_offset + 8 + (node_index % 32) / 8 * 8;
    uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
    // ここから過去のminor counterを取り出す
    uint8_t minor_counter_value = (minor_counter >> ((node_index % 8) * 8)) & 0xFF;
    uint8_t new_minor_counter = 0;
    if (minor_counter_value == 0xFF){
        uint64_t new_major_counter = major_counter + 1;
        spm_sd64(child_spm_offset, new_major_counter);
        new_minor_counter = 0; 
    } else {
        new_minor_counter = minor_counter_value + 1;
    }
    uint64_t shift_amount = (node_index % 8) * 8;
    uint64_t clear_mask = ~(0xFFULL << shift_amount);
    uint64_t cleared_minor_counter = minor_counter & clear_mask;
    uint64_t shifted_new_value = (new_minor_counter);
    shifted_new_value <<= shift_amount;
    uint64_t final_word = cleared_minor_counter | shifted_new_value;
    // 書き戻し
    spm_sd64(minor_counter_byte_address, final_word);
  }
  mac_buffer_set(child_spm_offset);
  mac_update(0, 447);
  uint64_t computed_mac = mac_final();
  spm_sd64(child_spm_offset + 56, computed_mac);
}

// ===========================================================================
// Tree Notation (ツリー構造の定義)
// ===========================================================================
// Level 0: [ ROOT ] (SPM offset 0)
// Level 1: [ Node ] ...
//   ...
// Level V: [ Victim ] (今回処理する対象。Dirtyなので書き戻しが必要)
//   ...
// Level H: [ Leaf ] (Data Counters)
// ===========================================================================

uint64_t evicted_node_update(struct Info tag_info, uint64_t id) {
  printf("[Core FW] Evicted Node Update: addr=0x%016llx, way=%u\n", tag_info.block_addr, tag_info.way);
    // ---------------------------------------------------------
    // 1. Victimのレベル(階層)とインデックスを特定
    // ---------------------------------------------------------
    uint32_t v_level = 0; // Victimのレベル (0=Root)
    uint64_t v_level_base_addr = 0;

    // アドレスマップを上(L1)からスキャンして、Victimがどの深さにいるか探す
    // (Rootは固定なのでL1からチェック)
    for (int l = 1; l <= HEIGHT; l++) {
        uint64_t base = calculate_level_base_addr(l);
        uint64_t next_base = calculate_level_base_addr(l + 1);
        if (tag_info.block_addr >= (COUNTER_BASE + base)) { // アドレス境界を見て階層を判定
            // 最終レベル、または次のレベルの手前なら確定
            if (l == HEIGHT || tag_info.block_addr < (COUNTER_BASE + next_base)) {
                v_level = l;
                v_level_base_addr = base;
                break;
            }
        }
    }
    // ガード: Root(Lv.0)はEvictされないはずなので無視
    if (v_level == 0) return id;
    // Victimのインデックス (そのレベル内での通し番号)
    uint64_t v_index = (tag_info.block_addr - COUNTER_BASE - v_level_base_addr) / 64;
    // ---------------------------------------------------------
    // 2. パス情報の準備 (Root -> Victim)
    // ---------------------------------------------------------
    struct PathNode {
        uint64_t dram_addr;
        uint32_t spm_offset;
        uint64_t node_index; // 親への書き込み位置特定用
        bool hit;
        bool needs_wb;
    } path[HEIGHT+1];

    // ループ: Level 0 (Root) から Level v_level (Victim) まで
    for (int l = 0; l <= v_level; l++) {
      if (l == 0) {
          path[l].node_index = 0; // Rootのインデックスは0
          path[l].dram_addr = 0; // Rootはアクセスしないのでダミー
          path[l].spm_offset = 0;
          path[l].hit = true;
          path[l].needs_wb = false;
      } else {
        // インデックス計算: Victimから逆算
        // Level l のインデックス = VictimIndex >> (5 * (v_level - l))
        uint64_t current_index = v_index >> (5 * (v_level - l));
        path[l].node_index = current_index;
        // DRAMアドレス計算
        if (l == 0) {
            path[l].dram_addr = 0; // Rootはアクセスしないのでダミー
        } else {
            path[l].dram_addr = COUNTER_BASE + calculate_level_base_addr(l) + (current_index * 64);
        }
      }
    }
    // ---------------------------------------------------------
    // 3. ロードフェーズ (Top-Down: Root -> Victim)
    // ---------------------------------------------------------
    for (int l = 1; l <= v_level; l++) {
        struct Info info = tag_check(path[l].dram_addr);
        if (info.hit) {
            path[l].spm_offset = info.spm_offset;
            path[l].hit = true;
            path[l].needs_wb = false;
        } else {
            // キャッシュミス: Temp Poolにロード
            path[l].spm_offset = pop_temp_buffer();
            path[l].hit = false;
            path[l].needs_wb = true;
            id++;
            spm_copy_to_local(path[l].dram_addr, path[l].spm_offset, 64, id);
        }
    }
    spm_wait(id); // ロード完了待ち
    // ---------------------------------------------------------
    // 4. 更新フェーズ (Top-Down: Root -> Victim)
    // ---------------------------------------------------------
    // l=1 (Rootの子) から開始 (Root自体は更新起点)
    for (int l = 1; l <= v_level; l++) {
      int parent_lvl = l - 1;
      // 親の情報を使って子のMACを再計算・更新
      // update_counter=false: Evictionなのでカウンタは進めず、MAC整合のみ取る
      bool update = (l == v_level) ? false : true;
      update_one_height(
          path[l].spm_offset,          // Child
          path[parent_lvl].spm_offset, // Parent
          path[l].node_index,          // Child Index
          update                      // update_counter
      );

      // キャッシュ上のノードを変更した場合はDirtyにする
      if (path[l].hit) {
        struct Info info = tag_check(path[l].dram_addr);   
        if (path[parent_lvl].hit) {
            setParentUpdated(path[l].dram_addr, info.way);
        } else {
            clearParentUpdated(path[l].dram_addr, info.way);
        }
        setBlockdirty(path[l].dram_addr, info.way);
      }
    }
    // ---------------------------------------------------------
    // 5. 書き戻しフェーズ (Temp Pool -> DRAM)
    // ---------------------------------------------------------
    for (int l = 0; l <= v_level; l++) {
        if (path[l].needs_wb) {
          spm_write_back(path[l].spm_offset, path[l].dram_addr, 64, 0);
          push_temp_buffer(path[l].spm_offset);
        }
    }
    return id;
}


uint64_t Authentication(uint64_t id, uint64_t request_addr){
  // HEIGHT-1がリーフ、0が高さ1
  uint64_t path_indecis[HEIGHT];
  struct Info info_array[HEIGHT];
  uint32_t spm_offset_array[HEIGHT];
  uint64_t dram_addr_array[HEIGHT];
  uint64_t start_level = 0;
  bool hit_found = false;
  for(uint64_t i=0; i<HEIGHT; ++i){
      uint64_t index = (request_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * i)));
      path_indecis[HEIGHT - 1 - i ] = index;
      uint64_t dram_addr = COUNTER_BASE + index / 32 * 64 + calculate_level_base_addr(HEIGHT - i);
      struct Info info = tag_check(dram_addr);
      info_array[HEIGHT - 1 - i] = info;
      if (info.hit){
        hit_found = true;
        start_level = HEIGHT - 1 - i;
        spm_offset_array[HEIGHT - 1 - i] = info.spm_offset;
        dram_addr_array[HEIGHT - 1 - i] = dram_addr;
        break;
      } else {
        spm_offset_array[HEIGHT - 1 - i] = pop_temp_buffer();
        dram_addr_array[HEIGHT - 1 - i] = dram_addr;
      }
  }
  uint64_t load_start_index = hit_found ? (start_level + 1) : 0;
  uint64_t tmp_id = id;
  // 上から順にSPMにロード
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    if (!info_array[i].hit){
      tmp_id += 1;
      uint64_t dram_addr = COUNTER_BASE + path_indecis[i] / 32 * 64 + calculate_level_base_addr(i+1);
      spm_copy_to_local(dram_addr, spm_offset_array[i], 64, tmp_id);
    }
  }
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    uint32_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    id += 1;
    bool verify = verify_one_height(spm_offset_array[i], parent_spm, path_indecis[i], id);
    if (verify == false){
      printf("[Core FW] Verification failed at level %llu\n", i);
      exit(1);
    }
  }
  // 木の更新：ルートから葉まで降りていく
  for (uint64_t i=load_start_index;i<HEIGHT;i++){
    update_one_height(spm_offset_array[i], (i==0)?0:spm_offset_array[i-1], path_indecis[i], true);
    if (i == load_start_index){
      clearParentUpdated(dram_addr_array[i], info_array[i].way);
      setBlockdirty(dram_addr_array[i], info_array[i].way);
    }
  }
  // スワップ
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    bool parent_updated = (i == 0) ? true : is_parent_update(dram_addr_array[i], info_array[i].way);
    // if (info_array[i].dirty && !parent_updated){
    //   // 親が更新されていない場合は、evicted node updateを行う
    //   id = evicted_node_update(info_array[i], id);
    // }
    if (parent_updated){
      // swappして良い
      spm_write_back(spm_offset_array[i], dram_addr_array[i], 64, 0);
      swapp_temp_cache(dram_addr_array[i], info_array[i], spm_offset_array[i],false);
      setParentUpdated(dram_addr_array[i], info_array[i].way);
    } else{
      spm_write_back(spm_offset_array[i], dram_addr_array[i], 64, 0);
      push_temp_buffer(spm_offset_array[i]);
    }

  }
  uint64_t major_counter;
  uint64_t minor_counter_byte_address;
  uint64_t minor_counter;
  uint8_t minor_counter_value;
  major_counter = spm_ld64(spm_offset_array[HEIGHT-1]);
  // axim_copy(DATA_SPM_OFFSET);
  // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
  uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
  minor_counter_byte_address = spm_offset_array[HEIGHT-1] + (counter_bit_offset / 64) * 8;
  minor_counter = spm_ld64(minor_counter_byte_address);
  minor_counter_value = (minor_counter >> ((counter_bit_offset % 64))) & 0xFF;
  // --- 手順2: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
  set_seed(major_counter, minor_counter_value, request_addr);
  uint64_t datamacblock_addr = DATA_TAG_BASE + (((request_addr - PROTECTION_BASE) / (64 * 8))) * 64;
  struct Info tag_info = tag_check(datamacblock_addr);
  uint64_t tag_id = id;
  if (!tag_info.hit){
    tag_id += 1;
    ensureBlockInSpm(datamacblock_addr, tag_info, tag_id);
  }
  while(AES_START_REG);
  // write_xor(DATA_SPM_OFFSET);
  xor_start(true, false);
  copy_xor(DATA_SPM_OFFSET);
  // ハッシュ関数の内部状態を初期化
  // SPMに当該MACブロックがあればそのままmodify,なければ今あるブロックをDRAMにwrite backしてから適切なブロックをSPMにDRAMコピー
  mac_init();
  mac_buffer_set(DATA_SPM_OFFSET); 
  mac_update(0, 511);
  mac_buffer_set(spm_offset_array[HEIGHT-1]);
  mac_update(counter_bit_offset, counter_bit_offset + 7); // 
  // MAC計算完了
  uint64_t computed_mac = mac_final();
  if (!tag_info.hit){
    spm_wait(tag_id);
  }
  uint64_t tmp = 0x000000049035ba80;
  uint64_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
  spm_sd64(tag_info.spm_offset + dmac_byte_offset, computed_mac);
  setBlockdirty(datamacblock_addr, tag_info.way);
  // if (tmp == datamacblock_addr){
  //   printf("computed_mac: %016llx\n", computed_mac);
  //   printf("dmac_byte_offset: %016llx\n", dmac_byte_offset);
  //   for (int i=0;i<8;i++){
  //     uint64_t val = spm_ld64(tag_info.spm_offset + i*8);
  //     printf("tag_data[%d]: %016llx\n", i, val);
  //   }
  //   // for (int i=0;i<8;i++){
  //   //   uint64_t val = spm_ld64(spm_offset_array[HEIGHT-1] + i*8);
  //   //   printf("data_block[%d]: %016llx\n", i, val);
  //   // }
  //   // for (int i=0;i<8;i++){
  //   //   uint64_t val = spm_ld64(DATA_SPM_OFFSET + i*8);
  //   //   printf("data_after_xor[%d]: %016llx\n", i, val);
  //   // }
  //   // tag_infoの情報を表示
  //   printf("Tag Info - valid: %d, dirty: %d, hit: %d, spm_offset: %u, block_addr: %016llx, way: %u\n",
  //          tag_info.valid, tag_info.dirty, tag_info.hit, tag_info.spm_offset, tag_info.block_addr, tag_info.way);
  //   // キャッシュ周りの情報を表示
  //   uint32_t set_index = get_cache_set_index(datamacblock_addr);
  //   printf("Cache Metadata for set %u:\n", set_index);
  //   for (int w = 0; w < CACHE_WAYS; w++) {
  //       struct CacheMetadata meta = cache_metadata[set_index][w];
  //       printf("  Way %d - valid: %d, dirty: %d, parent_updated: %d, locked: %d, access_count: %u, block_addr: %016llx, spm_offset: %u\n",
  //              w, meta.valid, meta.dirty, meta.parent_updated, meta.locked, meta.access_count, meta.block_addr, meta.spm_offset);
  //   }
  // }
  spm_write_back(DATA_SPM_OFFSET, request_addr, 64, 0);
  axim_write_return();
  return tag_id;
}

uint64_t Verification(uint64_t id, uint64_t request_addr){
  // HEIGHT-1がリーフ、0が高さ1
  uint64_t path_indecis[HEIGHT];
  struct Info info_array[HEIGHT];
  uint32_t spm_offset_array[HEIGHT];
  uint64_t dram_addr_array[HEIGHT];
  uint64_t start_level = 0;
  bool hit_found = false;
  for(uint64_t i=0; i<HEIGHT; ++i){
      uint64_t index = (request_addr - PROTECTION_BASE) / (64 * (1ULL << (5 * i)));
      path_indecis[HEIGHT - 1 - i ] = index;
      uint64_t dram_addr = COUNTER_BASE + index / 32 * 64 + calculate_level_base_addr(HEIGHT - i);
      struct Info info = tag_check(dram_addr);
      info_array[HEIGHT - 1 - i] = info;
      if (info.hit){
        hit_found = true;
        start_level = HEIGHT - 1 - i;
        spm_offset_array[HEIGHT - 1 - i] = info.spm_offset;
        dram_addr_array[HEIGHT - 1 - i] = dram_addr;
        break;
      } else {
        spm_offset_array[HEIGHT - 1 - i] = pop_temp_buffer();
        dram_addr_array[HEIGHT - 1 - i] = dram_addr;
      }
  }
  uint64_t load_start_index = hit_found ? (start_level + 1) : 0;
  uint64_t tmp_id = id;
  // 上から順にSPMにロード
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    if (!info_array[i].hit){
      tmp_id += 1;
      uint64_t dram_addr = COUNTER_BASE + path_indecis[i] / 32 * 64 + calculate_level_base_addr(i+1);
      spm_copy_to_local(dram_addr, spm_offset_array[i], 64, tmp_id);
    }
  }
  for (uint64_t i = load_start_index;i<HEIGHT;i++){
    uint32_t parent_spm = (i == 0) ? 0 : spm_offset_array[i-1];
    id += 1;
    bool verify = verify_one_height(spm_offset_array[i], parent_spm, path_indecis[i], id);
    if (verify == false){
      printf("[Core FW] Verification failed at level %llu\n", i);
      exit(1);
    }
  }
  uint64_t data_id = id+1;
  spm_copy_to_local(request_addr, DATA_SPM_OFFSET, 64,data_id);
  uint64_t major_counter = spm_ld64(spm_offset_array[HEIGHT-1]);
  // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
  uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
  uint64_t minor_counter = spm_ld64(spm_offset_array[HEIGHT-1] + (counter_bit_offset / 64) * 8);
  uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64) )) & 0xFF;
  set_seed(major_counter, minor_counter_value, request_addr);
  // SPMに当該MACブロックがあるかを確認。なければコピー。
  for (uint64_t i = start_level;i<HEIGHT;i++){
    if (!info_array[i].hit){
      bool parent_updated = (i == 0) ? true : is_parent_update(dram_addr_array[i], info_array[i].way);
      if (parent_updated){
        // 親が更新されていない場合は、evicted node updateを行う
        // id = evicted_node_update(info_array[i], id);
        swapp_temp_cache(dram_addr_array[i], info_array[i], spm_offset_array[i],false);
      } else {
        push_temp_buffer(spm_offset_array[i]);
      }
    }
  }
  uint64_t datamacblock_addr = get_datamacblock_addr(request_addr);
  struct Info tag_info = tag_check(datamacblock_addr);
  uint64_t tag_id = data_id;
  if (!tag_info.hit){
    tag_id += 1;
    ensureBlockInSpm(datamacblock_addr, tag_info,tag_id);
  }
  // --- 手順3: SPM DMAを起動し、DRAMから暗号文をSPMにコピー ---
  spm_wait(data_id);
  mac_init();
  mac_buffer_set(DATA_SPM_OFFSET);
  mac_update(0, 511);
  // SPMからカウンターブロックをコピーし、update
  mac_buffer_set(spm_offset_array[HEIGHT-1]);
  mac_update(counter_bit_offset, counter_bit_offset + 7); 
  uint64_t mac_result = mac_final();
  if (!tag_info.hit){
    spm_wait(tag_id);
  }
  uint64_t dmac_byte_offset = ((request_addr - PROTECTION_BASE) / 64) % 8 * 8;
  uint64_t expected_mac = spm_ld64(tag_info.spm_offset + dmac_byte_offset);
  if (mac_result != expected_mac) {
    printf("address=%016llx %016llx\n", request_addr,datamacblock_addr);
    for (int i=0;i<8;i++){
      uint64_t val = spm_ld64(tag_info.spm_offset + i*8);
      printf("DMAC[%d]=%016llx\n", i, val);
    }
    for (int i=0;i<8;i++){
      uint64_t val = spm_ld64(DATA_SPM_OFFSET + i*8);
      printf("DATA[%d]=%016llx\n", i, val);
    }
    for (int i=0;i<8;i++){
      uint64_t val = spm_ld64(spm_offset_array[HEIGHT-1] + i*8);
      printf("COUNTER[%d]=%016llx\n", i, val);
    }
    // tag_infoの情報も表示
    printf("Tag Info: valid=%d, dirty=%d, hit=%d, spm_offset=%u, block_addr=%016llx, way=%u\n",
        tag_info.valid,
        tag_info.dirty,
        tag_info.hit,
        tag_info.spm_offset,
        tag_info.block_addr,
        tag_info.way
    );
    // キャッシュ周りの情報を表示
    uint32_t set_index = get_cache_set_index(datamacblock_addr);
    printf("Cache Metadata for set %u:\n", set_index);
    for (int w = 0; w < CACHE_WAYS; w++) {
        struct CacheMetadata meta = cache_metadata[set_index][w];
        printf("  Way %d - valid: %d, dirty: %d, parent_updated: %d, locked: %d, access_count: %u, block_addr: %016llx, spm_offset: %u\n",
               w, meta.valid, meta.dirty, meta.parent_updated, meta.locked, meta.access_count, meta.block_addr, meta.spm_offset);
    }
    printf("[Core FW] Data MAC verification failed: computed=%016llx, expected=%016llx\n", mac_result, expected_mac);
    exit(1);
  }
  // --- 手順7: AXI managerに対し、read bufferにあるデータをリターンするように指示 ---
  while(AES_START_REG); // busy待ち
  write_xor(DATA_SPM_OFFSET);
  xor_start(false, true);
  // copy_xor(DATA_SPM_OFFSET);
  // axim_write(DATA_SPM_OFFSET);
  axim_read_return();
  return tag_id;
}

// uint64_t decryption_only(uint64_t id, uint64_t request_addr){
//   uint64_t counterblock_addr = get_counterblock_addr(request_addr);
//   struct Info tag_info = tag_check(counterblock_addr);
//     // --- 手順1: アドレスとカウンター値を元にSeed値を計算し、AES_moduleに書き込み起動する ---
//   // printf("[Core FW] Decryption: spm_offset=%016llx\n", spm_offset);
//   uint64_t counter_id = id;
//   if (!tag_info.hit){
//     counter_id += 1;
//     counter_id = ensureBlockInSpm(counterblock_addr, tag_info, counter_id);
//   }
//   uint64_t data_id = counter_id + 1;
//   spm_copy_to_local(request_addr, DATA_SPM_OFFSET, 64,data_id);
//   if (!tag_info.hit){
//     spm_wait(counter_id);
//   }
//   uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
//   uint64_t major_counter = spm_ld64(tag_info.spm_offset);
//   uint64_t minor_counter_byte_address = tag_info.spm_offset + (counter_bit_offset / 64) * 8;
//   uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
//   uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64) )) & 0xFF;
//   set_seed(major_counter, minor_counter_value, request_addr);
//   // --- 手順2: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
//   // SPM DMAを起動し、DRAMから暗号文をSPMにコピー
//   while(AES_START_REG); // busy待ち    
//   spm_wait(data_id);
//   write_xor(DATA_SPM_OFFSET);
//   xor_start();
//   copy_xor(DATA_SPM_OFFSET);
//   axim_write(DATA_SPM_OFFSET);
//   // // --- 手順3: SPM DMAを起動し、SPMからDRAMへ暗号文をwrite back ---
//   axim_read_return();
//   return data_id;
// }
// uint64_t encryption_only(uint64_t id, uint64_t request_addr){
//   uint64_t counterblock_addr = get_counterblock_addr(request_addr);
//     struct Info tag_info = tag_check(counterblock_addr);
//     uint64_t counter_id = id;
//     if (!tag_info.hit){
//       counter_id += 1;
//       counter_id = ensureBlockInSpm(counterblock_addr, tag_info, counter_id);
//       spm_wait(counter_id);
//     }
//     uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
//     uint64_t major_counter = spm_ld64(tag_info.spm_offset);
//     // minor_counterのload
//     // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
//     uint64_t minor_counter_byte_address = tag_info.spm_offset + (counter_bit_offset / 64) * 8;
//     uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
//     uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64) )) & 0xFF;
//     minor_counter_value += 1; // インクリメント
//     set_seed(major_counter, minor_counter_value, request_addr);
//     // minor counterの書き戻し
//     uint64_t shift_amount = (counter_bit_offset % 64);
//     uint64_t clear_mask = ~(0xFFULL << shift_amount);
//     uint64_t cleared_minor_counter = minor_counter & clear_mask;
//     // --- 新しい値を正しい位置へシフトする ---
//     uint64_t shifted_new_value = (minor_counter_value);
//     shifted_new_value <<= shift_amount;
//     uint64_t final_word = cleared_minor_counter | shifted_new_value;
//     // 書き戻し
//     spm_sd64(minor_counter_byte_address, final_word);
//     // ブロックをdirtyに設定する
//     setBlockdirty(tag_info.spm_offset);
//     // --- 手順2: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
//     // SPM DMAを起動し、DRAMから平文をSPMにコピー
//     axim_copy(DATA_SPM_OFFSET);
//     while(AES_START_REG); // busy待ち
//     write_xor(DATA_SPM_OFFSET);
//     xor_start();
//     copy_xor(DATA_SPM_OFFSET);
//     // --- 手順3: SPM DMAを起動し、SPMからDRAMへ暗号文をwrite back ---
//     spm_write_back(DATA_SPM_OFFSET, request_addr, 64,counter_id + 1);
//     axim_write_return();
//     return counter_id + 1;
// }
// uint64_t write_only(uint64_t id, uint64_t request_addr){
//     axim_copy(DATA_SPM_OFFSET);
//     // --- 手順3: SPM DMAを起動し、SPMからDRAMへ暗号文をwrite back ---
//     // id += 1;
//     spm_write_back(DATA_SPM_OFFSET, request_addr, 64,0);
//     axim_write_return();
//     return id;
// }
// uint64_t read_only(uint64_t id, uint64_t request_addr){
//     // struct AddressContext ctx = setupAddressContext();
//     id += 1;
//     spm_copy_to_local(request_addr, DATA_SPM_OFFSET, 64,id);
//     spm_wait(id);
//     axim_write(DATA_SPM_OFFSET);
//     axim_read_return();
//     return id;
// }
// uint64_t decryption_tag(uint64_t id, uint64_t request_addr){
//   uint64_t counterblock_addr = get_counterblock_addr(request_addr);
//   struct Info tag_info = tag_check(counterblock_addr);
//   uint64_t counter_id = id;
//   if (!tag_info.hit){
//     counter_id += 1;
//     counter_id = ensureBlockInSpm(counterblock_addr, tag_info, counter_id);
//   }
//   uint64_t data_id = counter_id + 1;
//   spm_copy_to_local(request_addr, DATA_SPM_OFFSET, 64,data_id);
//   if (!tag_info.hit){
//     spm_wait(counter_id);
//   }
//   uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
//   uint64_t major_counter = spm_ld64(tag_info.spm_offset);
//   // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
//   uint64_t minor_counter_byte_address = tag_info.spm_offset + (counter_bit_offset / 64) * 8;
//   uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
//   uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64) )) & 0xFF;
//   set_seed(major_counter, minor_counter_value, request_addr);
//   struct Info data_tag_info = tag_check(get_datamacblock_addr(request_addr));
//     uint64_t tag_id = data_id;
//     if (!data_tag_info.hit){
//       tag_id += 1;
//       tag_id = ensureBlockInSpm(get_datamacblock_addr(request_addr), data_tag_info, tag_id);
//     }
//     spm_wait(data_id);
//     while(AES_START_REG); // busy待ち
//     mac_init();
//     mac_buffer_set(DATA_SPM_OFFSET);
//     mac_update(0, 511);
//     // SPMからカウンターブロックをコピーし、update
//     mac_buffer_set(tag_info.spm_offset);
//     mac_update(counter_bit_offset, counter_bit_offset + 7); 
//     // --- 手順6: Hashモジュールの計算完了を待ち、結果を取得しSPMから正しい結果をload ---
//     // SPMに当該MACブロックがあるかを確認。なければコピー。
//     uint64_t mac_result = mac_final();
//     if (!data_tag_info.hit){
//       spm_wait(tag_id);
//     }
//     uint64_t dmac_byte_offset = (request_addr / 64) % 8 * 8;
//     uint64_t expected_mac = spm_ld64(data_tag_info.spm_offset + dmac_byte_offset);
//     if (mac_result != expected_mac) {
//         exit(1);
//     }
//     write_xor(DATA_SPM_OFFSET);
//     xor_start();
//     copy_xor(DATA_SPM_OFFSET);
//     axim_write(DATA_SPM_OFFSET);
//     axim_read_return();
//     return tag_id;
// }
// uint64_t encryption_tag(uint64_t id, uint64_t request_addr){
//   uint64_t counterblock_addr = get_counterblock_addr(request_addr);
//   struct Info tag_info = tag_check(counterblock_addr);
//   uint64_t counter_id = id;
//   if (!tag_info.hit){
//     counter_id += 1;
//     counter_id = ensureBlockInSpm(counterblock_addr, tag_info, counter_id);
//     spm_wait(counter_id);
//   }
//   axim_copy(DATA_SPM_OFFSET);
//   // bitオフセットを元にアドレスを8Bにアライメントして、minor counterを含む64ビットを読み出す.
//   uint64_t major_counter = spm_ld64(tag_info.spm_offset);
//   uint64_t counter_bit_offset = 64 + (request_addr / 64) % 32 * 8;
//   uint64_t minor_counter_byte_address = tag_info.spm_offset + (counter_bit_offset / 64) * 8;
//   uint64_t minor_counter = spm_ld64(minor_counter_byte_address);
//   uint8_t minor_counter_value = (minor_counter >> ((counter_bit_offset % 64))) & 0xFF;
//   uint8_t new_minor_counter_value = minor_counter_value + 1; // インクリメント
//   // minor counterの書き戻し
//   uint64_t shift_amount = (counter_bit_offset % 64);
//   uint64_t clear_mask = ~(0xFFULL << shift_amount);
//   uint64_t cleared_minor_counter = minor_counter & clear_mask;
//   // --- 新しい値を正しい位置へシフトする ---
//   uint64_t shifted_new_value = (new_minor_counter_value) << shift_amount;
//   uint64_t final_word = cleared_minor_counter | shifted_new_value;
//   // 書き戻し
//   spm_sd64(minor_counter_byte_address, final_word);
//   set_seed(major_counter, new_minor_counter_value, request_addr);
//   setBlockdirty(tag_info.spm_offset);    
//   // --- 手順3: AXI ManagerにOTPとともにXORを実行し、暗号化を指示 ---
//   uint64_t datamacblock_addr = get_datamacblock_addr(request_addr);
//   struct Info data_tag_info = tag_check(datamacblock_addr);
//   uint64_t tag_id = counter_id;
//   if (!data_tag_info.hit){
//     tag_id += 1;
//     tag_id = ensureBlockInSpm(datamacblock_addr, data_tag_info, tag_id);
//   }
//     while(AES_START_REG); // busy待ち
//     write_xor(DATA_SPM_OFFSET);
//     xor_start();
//     copy_xor(DATA_SPM_OFFSET);
//     spm_write_back(DATA_SPM_OFFSET, request_addr, 64,tag_id + 1);
//     axim_write_return();
//     // --- 手順5: HashモジュールにSPM上の暗号文と書き込んだカウンターを元にMAC計算を指示 ---
//     // ハッシュ関数の内部状態を初期化
//     // SPMに当該MACブロックがあればそのままmodify,なければ今あるブロックをDRAMにwrite backしてから適切なブロックをSPMにDRAMコピー
//     mac_init();
//     mac_buffer_set(DATA_SPM_OFFSET); 
//     mac_update(0, 511);
//     mac_buffer_set(tag_info.spm_offset);
//     mac_update(counter_bit_offset, counter_bit_offset + 7); // 8bit = 1B
//     // MAC計算完了
//     uint64_t computed_mac = mac_final();
//     if (!data_tag_info.hit){
//       spm_wait(tag_id);
//     }
//     // --- 手順6: Hashモジュールの計算完了を待ち、結果をSPMに保存 ---
//     uint64_t dmac_byte_offset = (request_addr / 64) % 8 * 8;
//     spm_sd64(data_tag_info.spm_offset + dmac_byte_offset, computed_mac);
//     // SPM上のMACブロックをDirtyに設定する
//     setBlockdirty(data_tag_info.spm_offset);
//     return tag_id+1;
// }
int main(void){
  // SPMの初期化
  for (uint64_t i=0; i<512; i++){
    spm_sd64(i*8, 0); 
  }
  // rootノードの初期化
  spm_sd64(0,1);
  init_cache_system();
  uint64_t dma_id = 0;
  while(1){
    for(;;){
      if(AXIM_STATUS_REG & 1) break; // リクエストが来るまで待つ
    }
    uint64_t addr = AXIM_REQ_ADDR_REG;
    // printf("addr=%016llx\n", addr);
    if (addr == 0xFFFFFFFFFFFFFFFF){
      return 0;
    } else {
      if(AXIM_STATUS_REG & 2){ // writeリクエスト
        // dma_id = write_only(dma_id, addr);
        // dma_id = encryption_only(dma_id, addr);
        // dma_id = encryption_tag(dma_id, addr);
        dma_id = Authentication(dma_id, addr);
      } else {
        // printf("[Core FW] Read request\n");
        // dma_id = read_only(dma_id, addr);
        // dma_id = decryption_only(dma_id, addr);
        // dma_id = decryption_tag(dma_id, addr);
        dma_id = Verification(dma_id, addr);
      }
    }
  }
}
