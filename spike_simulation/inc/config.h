// SPM内でのキャッシュメタデータ領域のベースアドレス (例: SPMの 56 * 64 から開始)
#define DATA_SPM_OFFSET (0x40)
#define CACHE_WAYS (4)
#define CACHE_SETS (128) // 768line
#define CACHE_DATA_SPM_BASE (64 * 4) // データ領域のベースアドレス
#define SPM_METADATA_BASE (CACHE_DATA_SPM_BASE + (CACHE_SETS * CACHE_WAYS * 64)) // メタデータ領域のベースアドレス
#define DATA_TAG_SETS (8)
#define TREE_SETS (120)

#define TEMP_POOL_SIZE (16)
typedef uint64_t  dram_addr_t;
typedef uint64_t  dma_id_t;
typedef uint32_t  spm_offset_t;
typedef uint64_t mac_t;
typedef uint32_t index_t;