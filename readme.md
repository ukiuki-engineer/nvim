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

## TODO

- [ ] diffview の時だけ coc-tsserver をオフにできないか？(よくバグるから)
- [ ] `:mksession`で diffview のタブを保存しないように
- [ ] telescope: normal モード時、検索->n でジャンプできるようにできないか？
- [ ] telescope.git_branches をもっとカラフルにできないか？
- [ ] coc-outline: markdown で効かない...
- gitsigns.nvim
  - [ ] coc の diagnostics が被って gitsigns が見えなくなるのをどうにかできないか？
  - [ ] stage した行もそれが分るように表示できないか？
- [ ] `utils#refresh_git_infomations()`を非同期化したい
- [ ] colorscheme をランダムに切り替えるコマンド`:ChangeColorscheme`を作る(飽きるから)
- [ ] nordfox のコメントが若干見づらい
- [ ] tokyonight の色調整
  - [ ] gitsigns
  - [ ] bufferline のブッファ名、タブ番号
- [ ] 外部ツールインストールが必要な場合のインストール処理を書く
      → 今のところ結構放置してるところも多いはず...
