package dpi_mem_pkg;
  // words: 64bitワード個数（例: 2^25 = 33,554,432 words = 256MiB）
  import "DPI-C" context function void dpi_mem_init_words(input longint unsigned words);

  // ワードインデックスで読み書き（64bit）
  import "DPI-C" context function longint unsigned dpi_mem_read64_idx(input int unsigned idx);

  // 8bitマスク付き書込み（AXIのWSTRB相当）
  import "DPI-C" context function void dpi_mem_write64_mask_idx(
      input int unsigned idx, input longint unsigned data, input byte mask);
endpackage
