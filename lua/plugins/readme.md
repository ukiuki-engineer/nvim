# 各プラグインの設定(vimscript)
vimscriptで書くプラグインの設定はこのディレクトリ内に配置する。
## ディレクトリ構成
```
plugins/
       ├── ui.lua
       ├── code_editting.lua
       ├── lsp_and_completion.lua
       ├── git.lua
       └── others.lua
```
## 関数の命名規則
- "hookの種類_プラグイン名"とする
- ハイフンはアンダーバーに変更
- 以下は省略する。ただし、省略するとわかりづらい場合は除く。
  - "vim-"
  - "nvim-"
  - ".vim"
  - ".nvim"
  - ".lua"
