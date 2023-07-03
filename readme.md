# My Neovim Settings
自分用Neovim設定ファイル。  
まだNeovimを使い始めたばかりですが、なんとかそれなりに使える環境にはなってきたのかな...  
基本的にはMac(iTerm2)で使用。たまにWindowsのWSL(Windows Terminal)で使用。  
![image](https://github.com/ukiuki-engineer/nvim/assets/101523180/2bce9011-06d4-499c-9a19-bc38f7ff8c23)

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

- 高速化のために気をつけている事
  - プラグインの遅延ロード
  - 設定の遅延ロード  
  →例えばTerminalモードに関する設定を`autocmd TermOpen * ++once source 設定ファイル名`のように、使用するタイミングでロードするようにしたりなど。
  - プラグイン設定をロードするタイミングにも気を遣う  
  →(dein.vimを使用している場合)hook_sourceやhook_post_sourceなどでなるべくロードするタイミングを遅らせる
  - 不要な標準プラグインを読み込まないように制御(場合によっては代替プラグインを探す)
  - なるべく軽いプラグインを使用する  
  →これで起動速度が倍くらい速くなったこともあるから結構大事...
  - WSLの場合、固有の事情を考慮する  
  →WSLは、Windows領域へのI/Oが遅いため、起動時には行わないようにする。  
  例えば
  ```vim
  if exepath('zenhan.exe') != ""
  ```
  のようなifは、Windows領域へファイルを探しにいくので起動速度への影響が大きい。  
  そのため、こういった処理は起動時ではなく後から行うようにする。

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
