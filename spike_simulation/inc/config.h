#ifdef __cplusplus
extern "C" {
#endif
// SPM内でのキャッシュメタデータ領域のベースアドレス (例: SPMの 56 * 64 から開始)
#include "mem_layout.h"

#define PROTECTION_BASE  MAIN_PROTECTION_BASE
#define HEIGHT  MAIN_HEIGHT
#define PROTECTION_SIZE MAIN_PROTECTION_SIZE
#define DATA_TAG_BASE  (PROTECTION_BASE + PROTECTION_SIZE) // 0x04000000
#define DATA_TAG_SIZE  (PROTECTION_SIZE / 8) // 8MB
#define COUNTER_BASE (DATA_TAG_BASE + DATA_TAG_SIZE) // 0x04800000
#define DATA_SPM_OFFSET (0x40)
#define TOTAL_SLOTS (512)
#define DATA_TAG_SLOTS_DM (64)
#define TREE_SLOTS_DM (TOTAL_SLOTS - DATA_TAG_SLOTS_DM)
#define CACHE_WAYS_LOG2 (2)
#define CACHE_WAYS (1 << CACHE_WAYS_LOG2) // 4way
#define CACHE_SETS (TOTAL_SLOTS / CACHE_WAYS) // 128line
#define CACHE_DATA_SPM_BASE (64 * 8) // データ領域のベースアドレス
#define SPM_METADATA_BASE (CACHE_DATA_SPM_BASE + (CACHE_SETS * CACHE_WAYS * 64)) // メタデータ領域のベースアドレス
#define DATA_TAG_SETS (64 / CACHE_WAYS) // 32line
#define TREE_SETS (CACHE_SETS - DATA_TAG_SETS)

#define PHYSICAL_WAYS_LOG2 (3)
#define PHYSICAL_WAYS (1 << PHYSICAL_WAYS_LOG2) // 8way


#define TEMP_POOL_SIZE (16)
typedef uint64_t  dram_addr_t;
typedef uint32_t  dma_id_t;
typedef int  spm_offset_t;
typedef uint64_t mac_t;
typedef uint32_t index_t;
/* =========================================================
   【設定】ここをコメントアウトすると「ソフトウェア実装」になります
   ========================================================= */
#define ENABLE_TMX_HARDWARE
#define ENABLE_TMU_HARDWARE
#ifdef __cplusplus
}
#endif