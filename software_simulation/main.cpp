#include <iostream>
#include <vector>
#include <iomanip>
#include <cstring>
#include <random>
#include <map>

// すべてのハードウェアコンポーネントの定義をインクルード
#include "memory_map.hpp"
#include "dram.hpp"
#include "spm.hpp"
#include "bus.hpp"
#include "riscv_core.hpp"
#include "spm_module.hpp"
#include "hash_module.hpp"
#include "aes_module.hpp"
#include "axi_manager_module.hpp"

// =================================================================
// テストベンチクラス
// =================================================================
class Testbench {
public:
    // テスト対象のハードウェアコンポーネントへの参照を受け取る
    Testbench(AxiManagerModule& axi_mgr, RiscVCore& core)
        : m_axi_mgr(axi_mgr), m_core(core) {}

    // テストシナリオをキューに追加
    void addWriteTest(uint64_t addr, const AxiManagerModule::DataBlock& data) {
        m_test_queue.push({ TestOp::Type::Write, addr, data });
    }
    void addReadTest(uint64_t addr, const AxiManagerModule::DataBlock& expected_data) {
        m_test_queue.push({ TestOp::Type::Read, addr, expected_data });
    }

    // 全てのテストを実行
    void run() {
        while (!m_test_queue.empty() || !m_outstanding_requests.empty()) {
            // 新しいリクエストを発行できる状態なら、キューからテストを取り出して実行
            if (!m_test_queue.empty()) {
                issueNextRequest();
            }
            // コアに処理を実行させる (これによりコールバックがトリガーされる可能性がある)
            m_core.runMainLoop();
        }
        
        // --- 最終結果の表示 ---
        std::cout << "\n--- Test Suite Finished ---\n";
        std::cout << "Total Passed: " << m_passed_count << "\n";
        std::cout << "Total Failed: " << m_failed_count << "\n";
    }

private:
    // テスト操作を定義する内部構造体
    struct TestOp {
        enum class Type { Read, Write };
        Type type;
        uint64_t addr;
        AxiManagerModule::DataBlock data; // Write時は書き込みデータ, Read時は期待データ
    };

    // 次のリクエストを発行
    void issueNextRequest() {
        TestOp op = m_test_queue.front();
        m_test_queue.pop();
        uint64_t req_id = m_next_req_id++;

        std::cout << "\n[TB] Issuing request ID " << req_id << " (Addr: 0x" << std::hex << op.addr << std::dec << ")...\n";
        m_outstanding_requests[req_id] = op;

        if (op.type == TestOp::Type::Write) {
            m_axi_mgr.receiveLlcWriteRequest(op.addr, req_id, op.data,
                [this, req_id](bool success){ this->onWriteAck(req_id, success); }
            );
        } else { // Read
            m_axi_mgr.receiveLlcReadRequest(op.addr, req_id,
                [this, req_id](const AxiManagerModule::DataBlock& data){ this->onReadResponse(req_id, data); }
            );
        }
    }

    // Writeリクエストのコールバック
    void onWriteAck(uint64_t req_id, bool success) {
        std::cout << "[TB] Write Ack received for ID " << req_id << ".\n";
        if (success) {
            m_passed_count++;
        } else {
            m_failed_count++;
        }
        m_outstanding_requests.erase(req_id);
    }

    // Readリクエストのコールバック
    void onReadResponse(uint64_t req_id, const AxiManagerModule::DataBlock& received_data) {
        std::cout << "[TB] Read Response received for ID " << req_id << ".\n";
        auto it = m_outstanding_requests.find(req_id);
        if (it != m_outstanding_requests.end()) {
            if (it->second.data == received_data) {
                std::cout << "  ✅ Data matches expected value.\n";
                m_passed_count++;
            } else {
                std::cout << "  ❌ Data MISMATCH!\n";
                m_failed_count++;
                std::cout << "    Expected: ";
                for (const auto& byte : it->second.data) { std::cout << std::hex << static_cast<int>(byte) << " "; }
                std::cout << "\n    Received: ";
                for (const auto& byte : received_data) { std::cout << std::hex << static_cast<int>(byte) << " "; }
                std::cout << std::dec << "\n";
                exit(1);
            }
            m_outstanding_requests.erase(it);
        }
    }

    // メンバ変数
    AxiManagerModule& m_axi_mgr;
    RiscVCore& m_core;
    std::queue<TestOp> m_test_queue;
    std::map<uint64_t, TestOp> m_outstanding_requests;
    uint64_t m_next_req_id = 1;
    int m_passed_count = 0;
    int m_failed_count = 0;
};

// =================================================================
// メイン関数
// =================================================================
int main() {
    // --- 1. ハードウェアのセットアップ ---
    Dram dram;
    Spm spm;
    SpmModule spm_mod(dram, spm);
    HashModule hash_mod(spm);
    AxiManagerModule axi_mgr_mod(spm);
    AesModule aes_mod(axi_mgr_mod);
    Bus bus(dram, spm);
    RiscVCore core(bus);
    bus.connectSpmModule(spm_mod);
    bus.connectHashModule(hash_mod);
    bus.connectAesModule(aes_mod);
    bus.connectAxiManagerModule(axi_mgr_mod);
    
    std::cout << "--- System Initialized ---\n";

    // --- 2. テストベンチを初期化 ---
    Testbench tb(axi_mgr_mod, core);
    
    // --- 3. テストシナリオを生成 (40回のランダムなRead/Write) ---
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<uint32_t> addr_dist(0, 0x04000000 / 64 - 1); // 64Bアラインされたアドレス範囲
    std::vector<std::pair<uint64_t, AxiManagerModule::DataBlock>> test_plan;
    std::map<uint64_t, AxiManagerModule::DataBlock> final_memory_state;
    const int NUM_TESTS = 40000;
    std::cout << "\n[TB] Generating " << NUM_TESTS << " test cases...\n";
    for (int i = 0; i < NUM_TESTS; ++i) {
        uint64_t addr = addr_dist(gen) * 64;
        AxiManagerModule::DataBlock data;
        for(size_t j=0; j<data.size(); ++j) data[j] = i+j; // 簡単なデータパターン
        test_plan.push_back({addr, data});
        final_memory_state[addr] = data; // 最終的にこのアドレスにはこのデータがあるはず
    }
    // write
    for (const auto& test_case : test_plan) {
        tb.addWriteTest(test_case.first, test_case.second);
    }
    // read
    for (const auto& test_case : test_plan) {
        tb.addReadTest(test_case.first, final_memory_state[test_case.first]);
    }
    // --- 4. テストスイートを実行 ---
    tb.run();
    
    return 0;
}