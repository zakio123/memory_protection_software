int mac_lock = 0;
int dma_lock = 0;
int axim_lock = 0;
int xor_lock = 0;
int spm_lock = 0;
int print_lock = 0;
void lock_print() {
    while (__sync_lock_test_and_set(&print_lock, 1)) {
    }
}
void unlock_print() {
    __sync_lock_release(&print_lock);
}
void lock_mac() {
    while (__sync_lock_test_and_set(&mac_lock, 1)) {
    }
}
void unlock_mac() {
    __sync_lock_release(&mac_lock);
}
void lock_dma() {
    // 失敗したらノップを入れたい
    while (__sync_lock_test_and_set(&dma_lock, 1)) {
    }
}
void unlock_dma() {
    __sync_lock_release(&dma_lock);
}
void lock_axim() {
    while (__sync_lock_test_and_set(&axim_lock, 1)) {
    }
}
void unlock_axim() {
    __sync_lock_release(&axim_lock);
}
void lock_xor() {
    while (__sync_lock_test_and_set(&xor_lock, 1)) {
    }
}
void unlock_xor() {
    __sync_lock_release(&xor_lock);
}
void lock_spm() {
    while (__sync_lock_test_and_set(&spm_lock, 1)) {
    }
}
void unlock_spm() {
    __sync_lock_release(&spm_lock);
}
// Readers-Writer Lock (RWLock) の導入
// --- 変数定義 ---
// RWロックの管理変数を保護するための小さなスピンロック
volatile int rw_ctrl_lock = 0; 
// 現在のアクティブなReader（Verification）の数
volatile int reader_count = 0; 
// Writer（Authentication）が待機中、または実行中かどうか
volatile int writer_active = 0; 
// --- 内部利用：管理変数保護用スピンロック ---
// 提示された lock_spm と同じ仕組みですが、RW制御専用に使います
void internal_ctrl_lock() {
    while (__sync_lock_test_and_set(&rw_ctrl_lock, 1)) {
    }
}
void internal_ctrl_unlock() {
    __sync_lock_release(&rw_ctrl_lock);
}

// ==========================================
//  Reader用（Verification側）
// ==========================================
void lock_tree_read() {
    while (1) {
        internal_ctrl_lock();
        // Writerが活動中（書き込み中、または書き込み待機中）なら
        // ロックを取らずに譲る（Writer優先）
        if (writer_active) {
            internal_ctrl_unlock();
            // Writerがいなくなるまで少し待ってからリトライ
            while(writer_active) { asm volatile("nop"); }
            continue;
        }
        // WriterがいなければReaderとして登録
        reader_count++;
        internal_ctrl_unlock();
        break;
    }
}
void unlock_tree_read() {
    internal_ctrl_lock();
    reader_count--;
    internal_ctrl_unlock();
}

// ==========================================
//  Writer用（Authentication側）
// ==========================================
void lock_tree_write() {
    // 1. まず「書き込みたい」という意志を表明して席を確保する
    while (1) {
        internal_ctrl_lock();
        
        // もし既に別のWriterがいるなら待つ（Writer同士の排他）
        if (writer_active) {
            internal_ctrl_unlock();
            while(writer_active) { asm volatile("nop"); }
            continue;
        }
        
        // Writer権限を確保（これで新規Readerはブロックされる）
        writer_active = 1;
        internal_ctrl_unlock();
        break;
    }
    // 2. 既に中にいるReaderがいなくなるのを待つ
    //    (新規Readerはwriter_activeを見て入ってこないので、既存分が減るのを待つだけ)
    while (1) {
        // reader_countの読み取りだけなのでロックなしでチェックしても良いが、
        // 厳密にはロックした方が安全（ただし頻繁なロック取得を避けるため簡易チェック）
        internal_ctrl_lock();
        if (reader_count == 0) {
            internal_ctrl_unlock();
            break;
        }
        internal_ctrl_unlock();
        asm volatile("nop");
    }
    // ここで完全に独占状態
}

void unlock_tree_write() {
    internal_ctrl_lock();
    writer_active = 0; // 書き込み終了。待機していたReaderたちが解放される
    internal_ctrl_unlock();
}