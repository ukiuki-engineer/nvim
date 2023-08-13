# 各プラグインの設定(vimscript)
プラグインの設定はこのディレクトリ内に配置する。
基本はluaで書く方針。
vimscriptで書いた設定は`autoload/plugins.vim`に集めてる。
`init.lua->lua/*.lua->(必要があれば)->autoload/*.vim`という流れで統一して見通し良くするために、
vimscriptで書いた設定はlua側をエントリーポイントにしてlua側から呼ぶようにしている。
例) plugins.coc.lua_source_coc()->plugins#hook_source_coc() など

## 関数の命名規則
- "hookの種類_プラグイン名"とする
- ハイフンはアンダーバーに変更
- 以下は省略する。ただし、省略するとわかりづらい場合は除く。
  - "vim-"
  - "nvim-"
  - ".vim"
  - ".nvim"
  - ".lua"
