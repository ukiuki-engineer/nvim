# My Neovim Settings
基本的にはMac(iTerm2)で使用。たまにWindowsのWSL(Windows Terminal)で使用。  

# このブランチについて
vimscript->luaへ移行する前の状態を残しておく用。

## 起動速度
- WSL2で測定した結果
```
vim-startuptime -vimpath nvim
Extra options: []
Measured: 10 times

Total Average: 25.044000 msec
Total Max:     25.874000 msec
Total Min:     23.898000 msec
```

- ハードウェアスペック

| | |
| ---- | ---- |
|  CPU  |  AMD Ryzen 5 3500 6-Core Processor                 3.59 GHz  |
| MEMORY | 16G |

## NOTE
自分用メモ
- Fonts  
[Cica](https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip)とかHackGenを使用。  
iconを設定するときなどは[ここ](https://www.nerdfonts.com/cheat-sheet)見たりとか。
- coc.nvimの拡張機能を探す場所
  - [githubのwiki](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions)
  - [npm moduleを検索するサイト](https://www.npmjs.com/search?q=keywords%3Acoc.nvim)
- 時々見たいけど忘れがちなヘルプタグ
  - `:h key-notation`
  - `:h map-table`
  - `:h autocmd-events`
  - `:h encoding-values`
