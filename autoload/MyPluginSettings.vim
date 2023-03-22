" ================================================================================
" 各プラグインの設定
" NOTE: 関数の命名規則
" - "hookの種類_プラグインの名前"とする
" - 以下は省略する
"   - "vim-"
"   - "nvim-"
"   - ".vim"
"   - ".nvim"
"   - ".lua"
" - ハイフンはアンダーバーに変更
" ================================================================================
"
" nvim-treesitter
"
function! MyPluginSettings#hook_source_treesitter() abort
" NOTE: lua << EOF〜EOFのインデントを深くするとエラーとなるため注意
lua << EOF
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true,         -- syntax highlightを有効にする
      disable = {            -- デフォルトの方が見やすい場合は無効に
        'toml',
        'css',
        'sql'
      }
    },
    indent = {
      enable = true
    },
    ensure_installed = 'all' -- :TSInstall allと同じ
  }
EOF
endfunction

"
" vim-quickrun
"
function! MyPluginSettings#hook_add_quickrun() abort
  nnoremap <F5> :QuickRun<CR>
  vnoremap <F5> :QuickRun<CR>
endfunction

"
" nvim-base16
"
function! MyPluginSettings#hook_add_base16() abort
  " colorscheme base16-ayu-dark
  " colorscheme base16-decaf
  colorscheme base16-atlas
  " colorscheme base16-spacemacs " emacsのテーマ
  " colorscheme base16-tender " 良いけどコメントが究極的に見づらい...
  " colorscheme base16-da-one-sea
  " colorscheme base16-onedark " atomのテーマ。これもコメントが見づらい...
endfunction

"
" blamer.nvim
"
function! MyPluginSettings#hook_add_blamer() abort
  let g:blamer_date_format = '%Y/%m/%d %H:%M'
  let g:blamer_show_in_visual_modes = 0
  if expand('%') != ''
    " タイマー遅延
    call timer_start(500, function("s:CallBlamerShow"))
  endif
endfunction

function! s:CallBlamerShow(timer) abort
  silent BlamerShow
endfunction

"
" vim-airline-themes
"
function! MyPluginSettings#hook_add_airline_themes() abort
  " let g:airline_theme = 'kalisi'
  " let g:airline_theme = 'sol'
  let g:airline_theme = 'deus'
endfunction

"
" vim-airline
"
function! MyPluginSettings#hook_add_airline() abort
  let g:airline_deus_bg = 'dark'
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#branch#enabled = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  let g:airline#extensions#tabline#show_buffers = 1
  let g:airline#extensions#tabline#tab_nr_type = 1
  let g:airline_extensions = ['branch', 'tabline']
endfunction

"
" indent-blankline.nvim
"
function! MyPluginSettings#hook_source_indent_blankline() abort
lua << EOF
  vim.opt.list = true
  vim.opt.listchars:append({
    space = "⋅",
    tab = »-,
    trail = -,
    eol = ↲,
    extends = »,
    precedes = «,
    nbsp = %
  })
  require("indent_blankline").setup {
    show_end_of_line = true,
    space_char_blankline = " "
  }
EOF
endfunction

"
" vim-commentary
"
function! MyPluginSettings#hook_source_commentary() abort
  augroup UserCommentstring
    autocmd!
    autocmd FileType php setlocal commentstring=//\ %s
  augroup END
endfunction

"
" vim-autoclose
"
function! MyPluginSettings#hook_add_autoclose() abort
  let g:autoclose#disable_nextpattern_autoclosing_brackets = []
  let g:autoclose#disable_nextpattern_autoclosing_quots = []
  let g:autoclose#autoformat_newline_enable = 0
  " 補完キャンセル機能をオン
  let g:autoclose#cancel_completion_enable = 1
  " <C-c>で補完をキャンセル
  inoremap <expr> <C-c> autoclose#is_completion() ? autoclose#cancel_completion() : "\<Esc>"
endfunction

"
" nvim-colorizer.lua
"
function! MyPluginSettings#hook_source_colorizer() abort
  augroup UserColorizer
    autocmd!
    autocmd FileType css,html,less,sass,scss,stylus,vim,blade,vue,eruby,toml ColorizerAttachToBuffer
    autocmd BufEnter *.css,*.html,*.sass,*.scss,*.vim,*.blade.php,*.vue,*.erb,*.toml ColorizerAttachToBuffer
  augroup END
endfunction

"
" vimhelpgenerator
"
function! MyPluginSettings#hook_source_vimhelpgenerator() abort
  let g:vimhelpgenerator_defaultlanguage = 'ja'
  let g:vimhelpgenerator_version = ''
  let g:vimhelpgenerator_author = 'Author  : ukiuki-engineer'
  let g:vimhelpgenerator_contents = {
    \ 'contents': 1, 'introduction': 1, 'usage': 1, 'interface': 1,
    \ 'variables': 1, 'commands': 1, 'key-mappings': 1, 'functions': 1,
    \ 'setting': 0, 'todo': 1, 'changelog': 0
    \}
endfunction

"
" nerdtree
"
function! MyPluginSettings#hook_add_nerdtree() abort
  " 隠しファイルを表示
  let g:NERDTreeShowHidden = 1
  " ファイル、ディレクトリ両方共シングルクリックで開く。
  let g:NERDTreeMouseMode=3
  " NERDTree表示/非表示切り替え
  nnoremap <C-n> :NERDTreeToggle<CR>
  " NERDTreeを開き、現在開いているファイルの場所にジャンプ
  nnoremap <expr> <C-w>t bufname() != "" ? ":NERDTreeFind<CR>" : ":NERDTreeFocus<CR>"
endfunction

"
" fzf.vim
"
function! MyPluginSettings#hook_add_fzf() abort
  nnoremap <C-p> :Files<CR>
  nnoremap gb :Buffers<CR>
  " NOTE: Rgはそのまま:Rgで
endfunction

"
" eskk.vim
" (今は未使用)
"
function! MyPluginSettings#hook_add_eskk() abort
  " 辞書ファイルをダウンロード
  if !filereadable(expand('~/.config/eskk/SKK-JISYO.L'))
    call mkdir('~/.config/eskk', 'p')
    call system('cd ~/.config/eskk/ && wget http://openlab.jp/skk/dic/SKK-JISYO.L.gz && gzip -d SKK-JISYO.L.gz')
  endif
  " 辞書ファイルを読み込む設定
  let g:eskk#directory = "~/.config/eskk"
  let g:eskk#dictionary = { 'path': "~/.config/eskk/my_jisyo", 'sorted': 1, 'encoding': 'utf-8',}
  let g:eskk#large_dictionary = {'path': "~/.config/eskk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp',}
endfunction

"
" coc.nvim
"
function! MyPluginSettings#hook_add_coc() abort
  " coc-extensions
  let g:coc_global_extensions = [
    \ 'coc-word',
    \ 'coc-sh',
    \ 'coc-yaml',
    \ 'coc-json',
    \ 'coc-docker',
    \ 'coc-sql',
    \ 'coc-tsserver',
    \ 'coc-vetur',
    \ 'coc-vimlsp',
    \ 'coc-xml',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-cssmodules',
    \ '@yaegassy/coc-intelephense',
    \ 'coc-blade',
    \ 'coc-solargraph',
    \ 'coc-eslint',
    \ 'coc-snippets',
    \ 'coc-spell-checker',
  \ ]
  " 補完の選択をEnterで決定
  inoremap <expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
  " 定義ジャンプ
  nnoremap <space>d <Plug>(coc-definition)
  " 関数とかの情報を表示する
  nnoremap <space>h :<C-u>call CocAction('doHover')<CR>
  " 参照箇所表示
  nnoremap <space>r <Plug>(coc-references)
  " ウィンドウのスクロール
  nnoremap <nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<C-j>"
  nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\<C-k>"
  nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <nowait><expr> <C-i> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 1)\<cr>" : "\<Right>"
  inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 1)\<cr>" : "\<Left>"
  inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  " 指摘箇所へジャンプ
  try
    nnoremap <silent> ]c :call CocAction('diagnosticNext')<cr>
    nnoremap <silent> [c :call CocAction('diagnosticPrevious')<cr>
  endtry
  " フォーマッターを呼び出す
  command! -nargs=0 Format :call CocAction('format')
  " ハイライト色を変更
  hi! CocFadeOut ctermfg=7 ctermbg=242 guifg=LightGrey guibg=DarkGrey
  hi! CocHintSign ctermfg=7 guifg=LightGrey
endfunction

