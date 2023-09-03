# 各プラグインの設定

プラグインの設定はこのディレクトリ内に配置する。
基本は lua で書く方針。
vimscript で書いた設定は`autoload/plugins.vim`に集めてる。
`init.lua->lua/*.lua->(必要があれば)->autoload/*.vim`という流れで統一して見通し良くするために、
vimscript で書いた設定は lua 側をエントリーポイントにして lua 側から呼ぶようにしている。
例) plugins.coc.lua_source_coc()->plugins#hook_source_coc() など

## 関数の命名規則

- "hook の種類\_プラグイン名"とする
- ハイフンはアンダーバーに変更
- 以下は省略する。ただし、省略するとわかりづらい場合は除く。
  - "vim-"
  - "nvim-"
  - ".vim"
  - ".nvim"
  - ".lua"
