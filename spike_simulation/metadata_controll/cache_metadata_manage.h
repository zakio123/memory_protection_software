#ifndef CACHE_METADATA_MANAGER_H
#define CACHE_METADATA_MANAGER_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include "config.h"       // CACHE_SETS, CACHE_WAYS 等
#include "spm_reg.h"      // spm_ld64, spm_sd64 等 (自作のアクセサが必要)
#include "temp_controll.h" // push_temp_buffer 等

/* =========================================================
   設定: どちらか一方を有効化
   ========================================================= */
// #define ENABLE_SPM_METADATA  // SPM上にメタデータを置く場合
#define ENABLE_RAM_AOS_METADATA // RAM上にAoS配列で置く場合
// #define ENABLE_RAM_SOA_METADATA // RAM上にSoA配列で置く場合

/* --- 共通型定義 --- */
// メタデータ構造体
typedef struct {
    dram_addr_t block_addr; // 8B
    spm_offset_t spm_offset; // 4B
    uint32_t access_count;   // 4B
    uint32_t ref_count;      // 4B
    bool valid;              // 1B
    bool dirty;              // 1B
    bool mac_updated;        // 1B
bool loaded;                 // 1B
    // Total: 24 Bytes
} CacheLineMeta;

// 戻り値用構造体
struct Info {
    bool dirty;
    bool hit;
    spm_offset_t spm_offset;
    dram_addr_t block_addr;
    int8_t way;
};

// --- グローバル変数宣言 (AoSモード用) ---
#ifdef ENABLE_RAM_AOS_METADATA
extern CacheLineMeta cache_meta[CACHE_SETS][CACHE_WAYS];
#endif

// --- SPMベースアドレス (SPMモード用) ---
#ifdef ENABLE_SPM_METADATA
extern spm_offset_t META_SPM_BASE;
// 1ライン分のメタデータサイズ (24B)
#define META_LINE_SIZE 24
#endif


/* =========================================================
   ヘルパー関数 (Set Index計算)
   ========================================================= */
static inline index_t get_cache_set_index(dram_addr_t dram_addr) {
    if (dram_addr < COUNTER_BASE) {
        return ((dram_addr) / 64) % DATA_TAG_SETS;
    } else {
        return ((dram_addr) / 64) % TREE_SETS + DATA_TAG_SETS;
    }
}


/* =========================================================
   メタデータアクセス抽象化レイヤー
   ========================================================= */

// --- 読み書きヘルパー (Internal) ---

static inline void write_meta(index_t s, index_t w, const CacheLineMeta* val) {
#ifdef ENABLE_RAM_AOS_METADATA
    cache_meta[s][w] = *val;
#else
    // SPMモード: 構造体を分解してSPMへ書き込む
    spm_offset_t addr = META_SPM_BASE + (s * CACHE_WAYS + w) * META_LINE_SIZE;
    spm_sd64(addr + 0, val->block_addr);
    uint64_t packed = ((uint64_t)val->spm_offset << 32) | (val->access_count);
    spm_sd64(addr + 8, packed);
    // 32bit/8bit変数をパック
    uint64_t packed_1 = 0;
    packed_1 |= ((uint64_t)val->ref_count << 32);
    packed_1 |= (val->valid       ? 1 : 0);
    packed_1 |= (val->dirty       ? 2 : 0);
    packed_1 |= (val->mac_updated ? 4 : 0);
    packed_1 |= (val->loaded      ? 8 : 0);
    spm_sd64(addr + 16, packed_1);
#endif
}

static inline void read_meta(index_t s, index_t w, CacheLineMeta* val) {
#ifdef ENABLE_RAM_AOS_METADATA
    *val = cache_meta[s][w];
#else
    spm_offset_t addr = META_SPM_BASE + (s * CACHE_WAYS + w) * META_LINE_SIZE;
    val->block_addr = spm_ld64(addr + 0);
    uint64_t packed = spm_ld64(addr + 8);
    val->spm_offset = (uint32_t)(packed >> 32);
    val->access_count = (uint32_t)(packed & 0xFFFFFFFF);
    
    uint64_t packed_1 = spm_ld64(addr + 16);
    val->ref_count    = (uint32_t)(packed_1 >> 32);
    val->valid       = (packed_1 & 1);
    val->dirty       = (packed_1 & 2);
    val->mac_updated = (packed_1 & 4);
    val->loaded      = (packed_1 & 8);
#endif
}

/* =========================================================
   キャッシュ操作関数 (API)
   ========================================================= */

// --- 初期化 ---
static inline void init_cache_system(spm_offset_t spm_base_for_meta) {
#ifdef ENABLE_SPM_METADATA
    META_SPM_BASE = spm_base_for_meta;
#endif
    spm_offset_t current_data_offset = CACHE_DATA_SPM_BASE;

    CacheLineMeta init_val = {0};
    init_val.mac_updated = true; // 初期値

    for(int s=0; s<CACHE_SETS; s++){
        for(int w=0; w<CACHE_WAYS; w++){
            init_val.spm_offset = current_data_offset;
            write_meta(s, w, &init_val);
            current_data_offset += 64;
        }
    }
}

// --- フラグ操作系 ---

static inline void setBlockdirty(index_t set_index, index_t way_index){
    CacheLineMeta meta;
    read_meta(set_index, way_index, &meta);
    meta.dirty = true;
    write_meta(set_index, way_index, &meta);
}

static inline void clearBlockdirty(index_t set_index, index_t way_index){
    CacheLineMeta meta;
    read_meta(set_index, way_index, &meta);
    meta.dirty = false;
    write_meta(set_index, way_index, &meta);
}

static inline bool is_mac_updated(index_t set_index, index_t way_index){
    CacheLineMeta meta;
    read_meta(set_index, way_index, &meta);
    return meta.mac_updated;
}

static inline void setParentUpdated(index_t set_index, index_t way_index){
    CacheLineMeta meta;
    read_meta(set_index, way_index, &meta);
    meta.mac_updated = true;
    write_meta(set_index, way_index, &meta);
}

static inline void clearParentUpdated(index_t set_index, index_t way_index){
    CacheLineMeta meta;
    read_meta(set_index, way_index, &meta);
    meta.mac_updated = false;
    write_meta(set_index, way_index, &meta);
}

static inline void set_loaded(index_t set_index, index_t way_index){
    CacheLineMeta meta;
    read_meta(set_index, way_index, &meta);
    meta.loaded = true;
    write_meta(set_index, way_index, &meta);
}

static inline void clear_loaded(index_t set_index, index_t way_index){
    CacheLineMeta meta;
    read_meta(set_index, way_index, &meta);
    meta.loaded = false;
    write_meta(set_index, way_index, &meta);
}

static inline bool is_loaded(index_t set_index, index_t way_index){
    CacheLineMeta meta;
    read_meta(set_index, way_index, &meta);
    return meta.loaded;
}

static inline bool is_cache_block_dirty(index_t set_index, index_t way_index){
    CacheLineMeta meta;
    read_meta(set_index, way_index, &meta);
    return meta.dirty;
}

static inline spm_offset_t get_cache_block_spm_offset(index_t set_index, index_t way_index){
    CacheLineMeta meta;
    read_meta(set_index, way_index, &meta);
    return meta.spm_offset;
}

static inline bool swappable_cache_block(index_t set_index, index_t way_index){
    CacheLineMeta meta;
    read_meta(set_index, way_index, &meta);
    return (meta.ref_count == 0);
}

// --- リソース管理系 ---

static inline bool acquire_cache_block(index_t set_index, index_t way_index){
    CacheLineMeta meta;
    read_meta(set_index, way_index, &meta);
    
    if (meta.valid == false){
        printf("Error: Attempt to acquire invalid cache block S:%u W:%u\n", set_index, way_index);
        return false;
    }
    
    meta.ref_count++;
    write_meta(set_index, way_index, &meta);
    return true;
}

static inline void release_cache_block(index_t set_index, index_t way_index){
    CacheLineMeta meta;
    read_meta(set_index, way_index, &meta);
    
    if (meta.valid == false){
        printf("Error: Attempt to release invalid cache block S:%u W:%u\n", set_index, way_index);
        exit(1);
    }
    if (meta.ref_count == 0){
        printf("Error: Attempt to release cache block S:%u W:%u with ref_count 0\n", set_index, way_index);
        exit(1);
    }
    
    meta.ref_count--;
    write_meta(set_index, way_index, &meta);
}

// --- タグチェック & LRUロジック ---

static inline struct Info tag_check(dram_addr_t dram_addr){
    struct Info tag_info = {false, false, 0, 0, -1}; // 初期化
    index_t set_index = get_cache_set_index(dram_addr);
    
    int8_t way_index = -1;
    uint32_t lru_counter_max = 0;
    
    // 全Wayのメタデータを取得 (最適化のため一旦ローカル配列へ)
    CacheLineMeta metas[CACHE_WAYS];
    for(int i=0; i<CACHE_WAYS; i++) {
        read_meta(set_index, i, &metas[i]);
    }

    // 1. ヒット判定 & 空きWay探索 & LRU Victim探索
    bool found_empty = false;
    
    for (index_t i = 0; i < CACHE_WAYS; ++i) {
        if (metas[i].valid) {
            if (metas[i].block_addr == dram_addr) {
                // Hit!
                way_index = i;
                tag_info.hit = true;
                tag_info.dirty = metas[i].dirty;
                tag_info.spm_offset = metas[i].spm_offset;
                tag_info.block_addr = dram_addr;
                tag_info.way = i;
                break;
            } 
            
            // Miss: Victim候補探索 (Ref=0 の中で一番古いもの)
            if (metas[i].ref_count == 0) {
                // アクセスカウンタ取得 (4bit)
                uint32_t count = (metas[i].access_count + 1) & 0xF;
                
                // Victim候補更新 (最もアクセスカウントが高い=古いものを選ぶロジックと仮定)
                if (count > lru_counter_max) {
                    lru_counter_max = count;
                    if (!tag_info.hit) { // Hitが見つかっていない場合のみ更新
                        way_index = i;
                    }
                }
            }
        } else {
            // InvalidなWayを見つけた -> 最優先で確保
            if (!tag_info.hit && !found_empty) {
                way_index = i;
                found_empty = true;
                // ここで即決せず、Hit判定のためにループは続ける
            }
        }
    }

    // 2. カウンタ更新 (Hit/Missに関わらず)
    for (uint64_t i = 0; i < CACHE_WAYS; ++i) {
        bool changed = false;
        
        if (metas[i].valid && i != way_index && metas[i].ref_count == 0) {
            // 他のWayのカウンタをインクリメント
            uint32_t count = (metas[i].access_count + 1) & 0xF;
            if (metas[i].access_count != count) {
                metas[i].access_count = count;
                changed = true;
            }
        }
        
        if (i == way_index) {
            // 選ばれたWay (Hit or Victim) のカウンタをリセット
            if (metas[i].access_count != 0) {
                metas[i].access_count = 0;
                changed = true;
            }
        }
        
        // 変更があれば書き戻し
        if (changed) {
            write_meta(set_index, i, &metas[i]);
        }
    }

    // 3. 結果構築
    if (tag_info.hit) {
        // Hit時は既に情報は埋まっている
        return tag_info;
    } else {
        // Miss時: 空きWayまたはVictimを使用
        if (found_empty) {
            // 空きWayを使用: Valid化して仮登録
            metas[way_index].valid = true;
            metas[way_index].block_addr = dram_addr; // 仮のアドレス
            // その他のフラグは初期値のまま
            write_meta(set_index, way_index, &metas[way_index]);
            
            tag_info.hit = false;
            tag_info.way = way_index;
            tag_info.spm_offset = metas[way_index].spm_offset;
            tag_info.block_addr = 0; // 空きだったので追い出しデータなし
            tag_info.dirty = false;
        } else if (way_index != -1) {
            // Victimを使用 (Eviction情報を作成)
            tag_info.hit = false;
            tag_info.way = way_index;
            tag_info.spm_offset = metas[way_index].spm_offset;
            tag_info.block_addr = metas[way_index].block_addr; // 追い出すデータのアドレス
            tag_info.dirty      = metas[way_index].dirty;
        } else {
            // 全Way使用中 (エラー)
            printf("[Cache] All ways locked or full for addr=%016llx\n", dram_addr);
            tag_info.way = -1;
        }
    }
    
    return tag_info;
}

// --- 軽量タグチェック ---
typedef struct {
    bool hit;
    int8_t way;
} light_tag_info_t;

static inline light_tag_info_t light_tag_check(dram_addr_t dram_addr){
    index_t set_index = get_cache_set_index(dram_addr);
    uint32_t lru_counter_max = 0;
    int8_t way_index = -1;
    bool found_empty = false;

    // 全Way読み出し
    CacheLineMeta metas[CACHE_WAYS];
    for(int i=0; i<CACHE_WAYS; i++) {
        read_meta(set_index, i, &metas[i]);
    }

    // 検索
    for (index_t i = 0; i < CACHE_WAYS; ++i) {
        if (metas[i].valid) {
            if (metas[i].block_addr == dram_addr) {
                return (light_tag_info_t){true, (int8_t)i};
            } 
            // 候補探索 (Ref=0, Not Updated, Not Dirty の中で古いもの)
            else if (metas[i].ref_count == 0 && !metas[i].mac_updated && !metas[i].dirty) {
                uint32_t count = (metas[i].access_count + 1) & 0xF;
                if (count > lru_counter_max && count > 10) {
                    lru_counter_max = count;
                    way_index = i;
                }
            }
        } else {
            // 空きWay発見
            if (!found_empty) {
                way_index = i;
                found_empty = true;
            }
        }
    }

    if (found_empty) {
        // 空きWay使用: 仮登録して返す
        metas[way_index].valid = true;
        metas[way_index].block_addr = dram_addr;
        write_meta(set_index, way_index, &metas[way_index]);
        return (light_tag_info_t){false, way_index};
    }

    if (way_index != -1){
        // Victim使用: 上書き登録して返す
        // printf("[Cache] Light tag check miss for addr=%016llx, selected way=%d\n", dram_addr, way_index);
        metas[way_index].block_addr = dram_addr;
        metas[way_index].access_count = 0;
        metas[way_index].dirty = false;
        metas[way_index].mac_updated = true;
        write_meta(set_index, way_index, &metas[way_index]);
    }
    
    return (light_tag_info_t){false, way_index};
}

// --- Way検索 ---
static inline index_t way_search_for_dram_addr(dram_addr_t dram_addr, index_t set_index){
    int8_t way_index = -1;
    uint32_t lru_counter_max = 0;
    bool found_empty = false;

    CacheLineMeta metas[CACHE_WAYS];
    for(int i=0; i<CACHE_WAYS; i++) {
        read_meta(set_index, i, &metas[i]);
    }

    for (index_t i = 0; i < CACHE_WAYS; ++i) {
        if (metas[i].valid) {
            if (metas[i].block_addr == dram_addr) {
                way_index = i;
                break;
            } else if (metas[i].ref_count == 0) {
                uint32_t count = (metas[i].access_count + 1) & 0xF;
                if (count > lru_counter_max) {
                    lru_counter_max = count;
                    way_index = i;
                }
            }
        } else {
            if (!found_empty) {
                way_index = i;
                found_empty = true;
                // 空きがあればそれを使い、有効化
                metas[i].valid = true;
                write_meta(set_index, i, &metas[i]);
                break; 
            }
        }
    }
    return way_index;
}

// --- データ入れ替え (Swap) ---
static inline void ensureBlockInSpm(dram_addr_t required_dram_addr, struct Info tag_info, dma_id_t id){
    // 注意: 元の関数シグネチャは dma_id_t を返していたが、ここでは単純化のため省略
    // 必要なら戻り値を追加してください
    
    index_t set_index = get_cache_set_index(required_dram_addr);
    CacheLineMeta meta;
    read_meta(set_index, tag_info.way, &meta);

    if (tag_info.dirty) {
        if (meta.ref_count > 0) {
            exit(1); // Error
        }
        spm_write_back(tag_info.spm_offset, tag_info.block_addr, 64, 0);
    }
    
    spm_copy_to_local(required_dram_addr, tag_info.spm_offset, 64, id);
    
    meta.valid = true;
    meta.dirty = false;
    meta.access_count = 0;
    meta.block_addr = required_dram_addr;
    meta.ref_count = 0;
    meta.loaded = false;
    
    write_meta(set_index, tag_info.way, &meta);
}

static inline void swapp_temp_cache(dram_addr_t dram_addr, struct Info tag_info, spm_offset_t spm_new, bool dirty){
    index_t set_index = get_cache_set_index(dram_addr);
    CacheLineMeta meta;
    read_meta(set_index, tag_info.way, &meta);

    if (tag_info.dirty){
        spm_write_back(tag_info.spm_offset, tag_info.block_addr, 64, 0);
    }
    
    spm_offset_t spm_old = meta.spm_offset;

    meta.valid = true;
    meta.dirty = dirty;
    meta.access_count = 0;
    meta.block_addr = dram_addr;
    meta.spm_offset = spm_new;
    meta.ref_count = 0;
    meta.loaded = true;
    
    write_meta(set_index, tag_info.way, &meta);
    
    push_temp_buffer(spm_old);
}

#endif // CACHE_METADATA_MANAGER_H