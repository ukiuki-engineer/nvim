# 各プラグインの設定(vimscript)
vimscriptで書くプラグインの設定はこのディレクトリ内に配置する。
## ディレクトリ構成
```
plugins/
       ├── ui.vim
       ├── code_editting.vim
       ├── lsp_and_completion.vim
       ├── git.vim
       └── others.vim
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
