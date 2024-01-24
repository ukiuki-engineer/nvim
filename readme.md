# My Neovim Settings

基本的には Mac(iTerm2)で使用。たまに Windows の WSL(Windows Terminal)で使用。

## 起動速度

- WSL2 で測定した結果

```
vim-startuptime -vimpath nvim
Extra options: []
Measured: 10 times

Total Average: 19.229900 msec
Total Max:     19.818000 msec
Total Min:     18.839000 msec
```

- ハードウェアスペック

|        |                                            |
| ------ | ------------------------------------------ |
| CPU    | AMD Ryzen 5 3500 6-Core Processor 3.59 GHz |
| MEMORY | 16G                                        |

## Required

- [Deno](https://deno.com/)
- Node
- [fzf](https://github.com/junegunn/fzf)
- SKK で使ってる辞書ファイル類(TODO: あとでちゃんとまとめる)

## NOTE

自分用メモ

- Fonts  
  [Cica](https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip)とか HackGen を使用。  
  icon を設定するときなどは[ここ](https://www.nerdfonts.com/cheat-sheet)見たりとか。
- coc.nvim の拡張機能を探す場所
  - [github の wiki](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions)
  - [npm module を検索するサイト](https://www.npmjs.com/search?q=keywords%3Acoc.nvim)
- 時々見たいけど忘れがちなヘルプタグ
  - `:h key-notation`
  - `:h map-table`
  - `:h autocmd-events`
  - `:h encoding-values`
- 基本的に`neovim nightly`を使用する  
→Macの場合以下を参照  
https://github.com/austinliuigi/brew-neovim-nightly

## TODO
- [ ] keyをエラーコードにする。エラー表示にもエラーコードを出す。
→`const.lua`のTODOコメントを参照
- [ ] `utils#refresh_git_infomations()`中で発生しているバグを修正  
→FIXME コメントを参照
- [ ] nordfox のコメントが若干見づらい
- [ ] 色々例外処理を入れておきたい(特に git 操作周り)
- telescope
  - [ ] normal モード時、検索->n でジャンプできるようにできないか？
  - [ ] git_branches をもっとカラフルにできないか？
- gitsigns.nvim
  - [ ] coc の diagnostics が被って gitsigns が見えなくなるのをどうにかできないか？
  - [ ] stage した行もそれが分るように表示できないか？
- [ ] `utils#refresh_git_infomations()`を非同期化したい
