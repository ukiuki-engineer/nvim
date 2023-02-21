" ================================================================================
" 各プラグインの設定
" NOTE: 命名規則
" - "hookの種類_プラグインの名前"とする
" - 以下は省略する
"   - vim-
"   - nvim-
"   - .vim
"   - .nvim
"   - .lua
" - ハイフンはアンダーバーに変更
" ================================================================================
" nvim-treesitter
function! MyPluginSettings#hook_source_treesitter() abort
lua << EOF
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true,  -- syntax highlightを有効にする
      disable = {     -- デフォルトの方が見やすい場合は無効に
        'toml',
        'css'
      }
    },
    indent = {
      enable = true
    },
    ensure_installed = 'all' -- :TSInstall allと同じ
  }
EOF
endfunction

" nvim-base16
function! MyPluginSettings#hook_add_base16() abort
  " colorscheme base16-ayu-dark
  " colorscheme base16-woodland
  " colorscheme base16-still-alive
  " colorscheme base16-decaf
  colorscheme base16-atlas
  " colorscheme base16-spacemacs
  " colorscheme base16-tender
endfunction

" blamer.nvim

function! s:CallBlamerShow(timer) abort
  BlamerShow
endfunction

function! MyPluginSettings#hook_add_blamer() abort
  let g:blamer_date_format = '%Y/%m/%d %H:%M'
  let g:blamer_show_in_visual_modes = 0
  if expand('%') != ''
    " タイマー遅延
    call timer_start(500, function("s:CallBlamerShow"))
  endif
endfunction

" vim-airline-themes
function! MyPluginSettings#hook_add_airline_themes() abort
  " let g:airline_theme = 'kalisi'
  " let g:airline_theme = 'sol'
  let g:airline_theme = 'deus'
endfunction

" vim-airline
function! MyPluginSettings#hook_add_airline() abort
  let g:airline_deus_bg = 'dark'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_powerline_fonts = 1
  let g:airline_extensions = ['branch', 'tabline']
  let g:airline#extensions#branch#enabled = 1
endfunction

function! MyPluginSettings#hook_source_indent_blankline() abort
lua << EOF
  vim.opt.list = true
  vim.opt.listchars:append "space:⋅"
  vim.opt.listchars:append "eol:↓"
  require("indent_blankline").setup {
    show_end_of_line = true,
    space_char_blankline = " "
  }
  -- indent-rainbowライクな設定
  -- FIXME: 空行もハイライトされてしまう
  -- FIXME: ビジュアルモードの選択範囲よりインデントハイライトが優先されてしまう(ビジュアルモードの選択範囲が見えなくなる)
  -- vim.opt.termguicolors = true
  -- vim.cmd [[highlight IndentBlanklineIndent1 guibg=#3E1014 gui=nocombine]]
  -- vim.cmd [[highlight IndentBlanklineIndent2 guibg=#3E3014 gui=nocombine]]
  -- vim.cmd [[highlight IndentBlanklineIndent3 guibg=#3E4214 gui=nocombine]]
  -- vim.cmd [[highlight IndentBlanklineIndent4 guibg=#0C2914 gui=nocombine]]
  -- vim.cmd [[highlight IndentBlanklineIndent5 guibg=#0C4246 gui=nocombine]]
  -- vim.cmd [[highlight IndentBlanklineIndent6 guibg=#0C1046 gui=nocombine]]
  -- vim.cmd [[highlight IndentBlanklineIndent7 guibg=#25102D gui=nocombine]]
  -- vim.opt.listchars:append "space:⋅"
  -- vim.opt.listchars:append "eol:↓"

  -- require("indent_blankline").setup {
    -- char = "",
    -- char_highlight_list = {
      -- -- "IndentBlanklineIndent1",
      -- "IndentBlanklineIndent2",
      -- -- "IndentBlanklineIndent3",
      -- "IndentBlanklineIndent4",
      -- -- "IndentBlanklineIndent5",
      -- "IndentBlanklineIndent6",
      -- "IndentBlanklineIndent7",
    -- },
    -- space_char_highlight_list = {
      -- -- "IndentBlanklineIndent1",
      -- "IndentBlanklineIndent2",
      -- -- "IndentBlanklineIndent3",
      -- "IndentBlanklineIndent4",
      -- -- "IndentBlanklineIndent5",
      -- "IndentBlanklineIndent6",
      -- "IndentBlanklineIndent7",
    -- },
    -- show_trailing_blankline_indent = false,
    -- show_end_of_line = true,
    -- space_char_blankline = "",
    -- space_char_blankline_highlight_list = {},
  -- }
EOF
endfunction


" caw.vim
function! MyPluginSettings#hook_source_caw() abort
  " コメントアウト(ノーマルモード)
  nnoremap <C-/>        <Plug>(caw:hatpos:toggle)
  " コメントアウト(ビジュアルモード)
  vnoremap <C-/>        <Plug>(caw:hatpos:toggle)
endfunction

" vim-commentary
function! MyPluginSettings#hook_source_commentary() abort
  augroup UserCommentstring
    autocmd!
    autocmd FileType php setlocal commentstring=//\ %s
  augroup END
endfunction


" nvim-colorizer.lua
function! MyPluginSettings#hook_source_colorizer() abort
  augroup UserColorizer
    autocmd!
    autocmd FileType css,html,less,sass,scss,stylus,vim,blade,vue,eruby,toml ColorizerAttachToBuffer
    autocmd BufEnter *.css,*.html,*.sass,*.scss,*.vim,*.blade.php,*.vue,*.erb,*.toml ColorizerAttachToBuffer
  augroup END
endfunction

" vimhelpgenerator
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

" nerdtree
function! MyPluginSettings#hook_add_nerdtree() abort
  let g:NERDTreeShowHidden = 1 " 隠しファイルを表示
  "1 : ファイル、ディレクトリ両方共ダブルクリックで開く。
  "2 : ディレクトリのみシングルクリックで開く。
  "3 : ファイル、ディレクトリ両方共シングルクリックで開く。
  let g:NERDTreeMouseMode=3
  " NERDTree表示/非表示切り替え
  nnoremap <C-n>        :NERDTreeToggle<CR>
  " FIXME 無名バッファの時(bufname() == "")は下のmapをしないようにする
  " NERDTreeを開き、現在開いているファイルの場所にジャンプ
  nnoremap              <C-w>t :NERDTreeFind<CR>
endfunction

" fzf.vim
function! MyPluginSettings#hook_add_fzf() abort
  nnoremap <C-p>        :Files<CR>
  nnoremap gb           :Buffers<CR>
  " NOTE: Rgはそのまま:Rgで
endfunction

" coc.nvim
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
    \ 'coc-markdownlint',
    \ 'coc-eslint',
    \ 'coc-snippets',
    \ 'coc-spell-checker',
  \ ]
  " 補完の選択をEnterで決定
  inoremap <expr> <CR>  coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
  " 定義ジャンプ
  nnoremap <space>d     <Plug>(coc-definition)
  " 関数とかの情報を表示する
  nnoremap <space>h     :<C-u>call CocAction('doHover')<CR>
  " フォーマッターを呼び出す
  command! -nargs=0 Format :call CocAction('format')
  " ウィンドウのスクロール
  nnoremap <nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<C-j>"
  nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\<C-k>"
  nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <nowait><expr> <C-i> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 1)\<cr>" : "\<Right>"
  inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 1)\<cr>" : "\<Left>"
  inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  " ハイライト色を変更
  hi! CocFadeOut ctermfg=7 ctermbg=242 guifg=LightGrey guibg=DarkGrey
  hi! CocHintSign ctermfg=7 guifg=LightGrey
endfunction

