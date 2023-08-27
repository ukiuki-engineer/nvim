# My Neovim Settings

基本的には Mac(iTerm2)で使用。たまに Windows の WSL(Windows Terminal)で使用。

## 起動速度

- WSL2 で測定した結果

```
vim-startuptime -vimpath nvim
Extra options: []
Measured: 10 times

Total Average: 25.044000 msec
Total Max:     25.874000 msec
Total Min:     23.898000 msec
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

- [ ] telescope: normal モード時、n で次にジャンプできるように
- [ ] coc-outline: markdown で効かない...
- [ ] git の差分があるかどうかを lualine に表示させる
- gitsigns.nvim
  - [ ] coc の diagnostics が被って gitsigns が見えなくなるのをどうにかできないか？
  - [ ] stage した行もそれが分るように表示できないか？
- [ ] 外部ツールインストールが必要な場合のインストール処理を書く
      → 今のところ結構放置してるところも多いはず...
