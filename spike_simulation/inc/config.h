#ifdef __cplusplus
extern "C" {
#endif
// SPM内でのキャッシュメタデータ領域のベースアドレス (例: SPMの 56 * 64 から開始)
#include "setting.h"
#define MINOR_COUNTER_WIDTH SETTING_MINOR_COUNTER_WIDTH
#define MINOR_COUNTER_COUNT SETTING_MINOR_COUNTER_COUNT
#define MINOR_COUNTER_MASK ((1ULL << MINOR_COUNTER_WIDTH) - 1)
#define ARTY_LOG2 SETTING_ARTY_LOG2
#define PROTECTION_BASE  SETTING_PROTECTION_BASE
#define HEIGHT  SETTING_HEIGHT
#define PROTECTION_SIZE SETTING_PROTECTION_SIZE
#define PROTECTION_SIZE_GRAIN SETTING_PROTECTION_SIZE_GRAIN
#define DATA_TAG_BASE  (PROTECTION_BASE + PROTECTION_SIZE) // 0x04000000
#define DATA_TAG_SIZE  (PROTECTION_SIZE / (PROTECTION_SIZE_GRAIN / 64 * 8))
#define MAC_COVERAGE_BLOCKS SETTING_MAC_COVERAGE_BLOCKS
#define COUNTER_BASE (DATA_TAG_BASE + DATA_TAG_SIZE) // 0x04800000
#define DATA_SPM_OFFSET (0x40)
#define TOTAL_SLOTS (2048) // 128KBのSPMを64Bで割った数
#define DATA_TAG_SLOTS_DM (256)
#define TREE_SLOTS_DM (TOTAL_SLOTS - DATA_TAG_SLOTS_DM)


#define CACHE_WAYS_LOG2 SETTING_CACHE_WAYS_LOG2 // 2way
#define CACHE_WAYS (1 << CACHE_WAYS_LOG2) // 8way
#define CACHE_SETS (TOTAL_SLOTS / CACHE_WAYS) // 64line
#define CACHE_DATA_SPM_BASE (64 * 8) // データ領域のベースアドレス
#define SPM_METADATA_BASE (CACHE_DATA_SPM_BASE + (CACHE_SETS * CACHE_WAYS * 64)) // メタデータ領域のベースアドレス
#define DATA_TAG_SETS (DATA_TAG_SLOTS_DM / CACHE_WAYS) // 32line
#define TREE_SETS (CACHE_SETS - DATA_TAG_SETS)

#define PHYSICAL_WAYS_LOG2 (3)
#define PHYSICAL_WAYS (1 << PHYSICAL_WAYS_LOG2) // 8way

#define TEMP_POOL_SIZE (16)
#define DRAM_ADDR_OFFSET_BASE (CACHE_DATA_SPM_BASE + (CACHE_SETS * CACHE_WAYS * 64) + TEMP_POOL_SIZE * 64) // 各キャッシュラインのDRAMアドレス格納領域のベースアドレス

typedef uint64_t  dram_addr_t;
typedef uint64_t  dma_id_t;
typedef uint64_t  spm_offset_t;
typedef uint64_t mac_t;
typedef long index_t;
/* =========================================================
   【設定】ここをコメントアウトすると「ソフトウェア実装」になります
   ========================================================= */
#define ENABLE_TMX_HARDWARE
#define ENABLE_TMU_HARDWARE
// #define DUMP
// #define EAGER
#define ENABLE_TMU_BIT_MANIPULATION
#define LOADED_BIT_POS (0)
#define MAC_UPDATED_BIT_POS (1)

#define VERIFIED_BIT_POS (2)

#define TMU_BIT_ARRAY_SIZE (32)
#ifdef __cplusplus
}
#endif