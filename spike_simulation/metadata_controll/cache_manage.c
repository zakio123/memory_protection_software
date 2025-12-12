#include "cache_metadata_manage.h"
#include "config.h"
// AoSモードの配列実体
#ifdef ENABLE_RAM_AOS_METADATA
CacheLineMeta cache_meta[CACHE_SETS][CACHE_WAYS];
#endif
// SoAモードの配列実体
#ifdef ENABLE_RAM_SOA_METADATA

#endif


// SPMモードのベース変数
#ifdef ENABLE_SPM_METADATA
spm_offset_t META_SPM_BASE;
#endif