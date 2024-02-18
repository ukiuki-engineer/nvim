# My Neovim Settings

基本的には Mac(iTerm2)で使用。たまに Windows の WSL(Windows Terminal)で使用。
![image](https://github.com/ukiuki-engineer/nvim/assets/101523180/3aebf65a-4200-43fb-a921-b2eac3eb585c)

## 起動速度

- WSL2 で測定した結果

```
vim-startuptime -vimpath nvim
Extra options: []
Measured: 10 times

Total Average: 11.868900 msec
Total Max:     12.151000 msec
Total Min:     11.633000 msec
```

→[log](https://github.com/ukiuki-engineer/nvim/blob/master/vim-startuptime.log)

- ハードウェアスペック

|        |                                            |
| ------ | ------------------------------------------ |
| CPU    | AMD Ryzen 5 3500 6-Core Processor 3.59 GHz |
| MEMORY | 16G                                        |

## Required

事前に下記をインストールしておく。

- [Deno](https://deno.com/)
- Node

## 仕事集中モード

仕事に集中したいときは、この`nvim/`直下に`working`というファイルを配置する。  
→Neovim設定を開いても強制的に閉じるようになっている。

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
- luaでテーブルの中身を見たいときは`vim.print()`
- 基本的に`neovim nightly`を使用する  
→Macの場合以下を参照  
https://github.com/austinliuigi/brew-neovim-nightly

## vimrc読書会

- [x] `init.lua`  
Vim scriptとのキメラになってる

```lua
vim.cmd("let &runtimepath = '" .. dein_repo_dir .. "'.','. &runtimepath")
```

- [x] `init.lua`  
多分`== 0`としないと機能しない

```lua
if not fn.isdirectory(cache) then
```

- [x] `scss.vim`  

```vim
echo "Warning: 'sass' command is not available."
```

- [x] `init.lua`  
表記揺れ

```lua
if fn.isdirectory(dein_repo_dir) == 0 then
  if vim.fn.isdirectory(dein_repo_dir) == 0 then
```

- [ ] `autocmds.lua`  
BufNewFileも付けておくと便利できそう

```lua
-- env系はshとして開く
```

- [ ] vimscriptの二重読み込み防止処理をそのままluaに移行したやつ、全部消す
→requireだとやってくれてるらしい

- [ ] insert modeのmappingはInsertEnterにする

- [ ] `keymappings.lua`  
silentのせい

```lua
-- FIXME: 上の書き方だと何故か効かないので一旦vimscriptの書き方で
```

- [ ] `options.lua`  

```lua
opt.encoding = 'utf-8'
```

- [ ] `gin.lua`
gin.vimにwait機能あるからそれで行けないかしら

```lua
-- NOTE: 普通にcommand実行するだけだとなんか時々上手くいかないのでtimer遅延を
```
