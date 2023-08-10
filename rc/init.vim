" ================================================================================
" vimrc.vim
" ================================================================================
" ------------------------------------------------------------------------------
" 読み込み
" ------------------------------------------------------------------------------
let s:options     = g:rc_dir .. '/options.vim'
let s:autocmd     = g:rc_dir .. '/autocmd.vim'
let s:commands    = g:rc_dir .. '/commands.vim'
let s:keymap      = g:rc_dir .. '/keymap.vim'
let s:terminal    = g:rc_dir .. '/terminal.vim'
let s:ime         = g:rc_dir .. '/ime.vim'
let s:clipboard   = g:rc_dir .. '/clipboard.vim'
let s:paste_image = g:rc_dir .. '/paste_image.vim'

" 通常ロード
execute 'source ' .. s:options
execute 'source ' .. s:autocmd
" 遅延ロード
augroup MyLazyLoad
  autocmd!
  " command定義
  autocmd CmdlineEnter * ++once execute 'source ' .. s:commands
  " keymap
  autocmd InsertEnter,BufRead * ++once execute 'source ' .. s:keymap
  " :terminal設定の読み込み1
  autocmd TermOpen * ++once execute 'source ' .. s:terminal
  " :terminal設定の読み込み2
  autocmd CmdUndefined Terminal,Term,TermV,TermHere,TermHereV ++once execute 'source ' .. s:terminal
  " IME切り替え設定の読み込み(WSLの場合Windows領域へのI/Oが遅く、それが起動時間に影響するため遅延ロードする)
  autocmd InsertEnter,CmdlineEnter * ++once execute 'source ' .. s:ime
  " クリップボード設定の遅延読み込み(WSLの場合Windows領域へのI/Oが遅く、それが起動時間に影響するため遅延ロードする)
  autocmd InsertEnter,CursorMoved * ++once execute 'source ' .. s:clipboard
  " markdownで、画像をクリップボードから貼り付けする設定の読み込み
  autocmd CmdUndefined PasteImage ++once execute 'source ' .. s:paste_image
augroup END
" ------------------------------------------------------------------------------
" 標準プラグインの制御
" ------------------------------------------------------------------------------
let g:did_indent_on             = 1
let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
let g:did_load_ftplugin         = 1
let g:loaded_gzip               = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
let g:loaded_matchparen         = 1
let g:loaded_netrw              = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_remote_plugins     = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1
" 標準プラグインの遅延読み込み
" call utils#lazy_load()
" ------------------------------------------------------------------------------
" FIXME: 応急処置。いつか消す。
" 最近macの時だけvimが落ちるようになったので、応急処置として保存時にmksessionする
" ------------------------------------------------------------------------------
if has('mac')
  let g:pwd_in_startup = $PWD
  augroup PwdInStartup
    autocmd!
    autocmd BufWrite * execute 'mksession! ' .. expand(g:pwd_in_startup) .. '/Session.vim'
  augroup END
endif
