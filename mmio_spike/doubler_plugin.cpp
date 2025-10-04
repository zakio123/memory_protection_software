#include <iostream>
#include <riscv/mmio_plugin.h>
#include "abstract_device.h" // abstract_device_tを継承するために必要

// MMIOレジスタマップを定義
namespace doubler_reg {
    constexpr reg_t INPUT_REG  = 0x00; // 入力レジスタ (Write Only)
    constexpr reg_t OUTPUT_REG = 0x08; // 出力レジスタ (Read Only)
}

// abstract_device_tを継承したdoublerデバイスクラス
class doubler_device_t : public abstract_device_t {
public:
    // コンストラクタ
    doubler_device_t(std::string name);

    // CPUからのMMIO Readを処理する (オーバーライド)
    bool load(reg_t addr, size_t len, uint8_t* bytes) override;

    // CPUからのMMIO Writeを処理する (オーバーライド)
    bool store(reg_t addr, size_t len, const uint8_t* bytes) override;

private:
    // 計算結果を保持する内部状態
    uint64_t m_output_value = 0;
};

// --- クラスメソッドの実装 ---

doubler_device_t::doubler_device_t(std::string name) {
    // プラグインがロードされたことを示すメッセージ
    std::cout << "[Doubler Plugin] Loaded with name: " << name << std::endl;
}

bool doubler_device_t::load(reg_t addr, size_t len, uint8_t* bytes) {
    if (len != 8) return false; // 64bitアクセスのみをサポート

    // 出力レジスタが読み出された場合
    if (addr == doubler_reg::OUTPUT_REG) {
        // 内部に保持している計算結果をbytesバッファにコピーする
        *(reinterpret_cast<uint64_t*>(bytes)) = m_output_value;
    } else {
        // それ以外のアドレスは0を返す
        *(reinterpret_cast<uint64_t*>(bytes)) = 0;
    }
    return true;
}

bool doubler_device_t::store(reg_t addr, size_t len, const uint8_t* bytes) {
    if (len != 8) return false; // 64bitアクセスのみをサポート

    // 入力レジスタに書き込まれた場合
    if (addr == doubler_reg::INPUT_REG) {
        // bytesバッファから64bit値を読み出す
        uint64_t input_value = *(reinterpret_cast<const uint64_t*>(bytes));
        
        // 値を2倍して内部変数に保存
        m_output_value = input_value * 2;

        std::cout << "[Doubler Plugin] Received " << input_value 
                  << ", Output set to " << m_output_value << std::endl;
    }
    return true;
}

// 作成したプラグインクラスを "doubler" という名前でSpikeに登録
static mmio_plugin_registration_t<doubler_device_t> doubler_registration("doubler");