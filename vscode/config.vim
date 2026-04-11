" ================================================================================
" プラグイン以外の設定
" ================================================================================
" ------------------------------------------------------------------------------
" options
" ------------------------------------------------------------------------------
" オートインデント
set autoindent
" クリップボード連携
set clipboard+=unnamed
" カーソル行、列を表示
set cursorline cursorcolumn
" 検索時の挙動
set ignorecase smartcase incsearch hlsearch nowrapscan
" ------------------------------------------------------------------------------
" highlights
" ------------------------------------------------------------------------------
hi CursorColumn guibg=#414041
" ------------------------------------------------------------------------------
" autocmd
" ------------------------------------------------------------------------------
augroup MyVSCodeInitVim
  autocmd!
  " 日本語入力切り替え {{{
  if has('mac') && exepath('im-select') != ""
    " MacOS用
    " NOTE: im-selectをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter * :call jobstart('im-select com.apple.keylayout.ABC')
  endif
  if has('win32') && exepath('zenhan.exe') != ""
    " Windows用
    " NOTE: zenhanをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter * :call jobstart('zenhan.exe 0')
  endif
  " }}}
augroup END
" ------------------------------------------------------------------------------
" keymaps
" ------------------------------------------------------------------------------
" markはあまり使わないので潰してleaderにする
let g:mapleader = "m"

" Escを2回押すと検索結果ハイライトを非表示にする
nnoremap <silent> <Esc><Esc> :nohlsearch<CR><Esc>

" VSCode側の機能を呼び出すmapping {{{
" NOTE:
" https://code.visualstudio.com/docs/getstarted/keybindings

" gitの差分へジャンプ
nnoremap ]c :call VSCodeNotify('workbench.action.editor.nextChange')<CR>
nnoremap [c :call VSCodeNotify('workbench.action.editor.previousChange')<CR>
" 選択範囲をstage
nnoremap <leader>hs :call VSCodeNotify('git.stageSelectedRanges')<CR>
" 選択範囲をunstage
nnoremap <leader>hu :call VSCodeNotify('git.unstageSelectedRanges')<CR>
" 選択範囲を元に戻す
nnoremap <leader>hr :call VSCodeNotify('git.revertSelectedRanges')<CR>
" 定義ジャンプ
nnoremap gd :call VSCodeNotify('editor.action.revealDefinition')<CR>
" hover表示
nnoremap K :call VSCodeNotify('editor.action.showHover')<CR>
" }}}

" 日本語へのジャンプ、加工がしやすくなるように
lua << END
  require("config.keymappings").set_jump_to_zenkaku()
END
