
構成
- 64B単位の暗号化と整合性検証
- 全部で512MBの保護領域 0x0000_0000-0x0x1FFFFFFF
- タグは8B
- SPMは4096B=4KB
    - 64Bごとの保存・格納
    - 8Bで1ラインの情報管理
        - |タグ(58bit)|未使用(4bit)|dirty(1bit)|valid(1bit)|
    - 56line使用可能
    - 0line:暗号文
    - 1line:タグ
    - 2line:カウンターライン
    - 3-55line:とりあえず未使用(ツリーのためにとっておく)
    - 56-63line:管理ビット
- カウンターライン内のカウンターの構成
    - カウンターが64個入る
    - major counter:64bit
    - minor counter:6bit
    - tagに64bit空いている
