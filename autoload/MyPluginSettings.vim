" ================================================================================
" 各プラグインの設定
" NOTE: 関数の命名規則
" - "hookの種類_プラグイン名"とする
" - ハイフンはアンダーバーに変更
" - 以下は省略する
"   - "vim-"
"   - "nvim-"
"   - ".vim"
"   - ".nvim"
"   - ".lua"
" ================================================================================
"
" nvim-treesitter
"
function! MyPluginSettings#hook_source_treesitter() abort
" NOTE: lua << EOF〜EOFのインデントを深くするとエラーとなるため注意
lua << EOF
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true, -- syntax highlightを有効にする
      disable = {    -- デフォルトの方が見やすい場合は無効に
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
  "  emacsのテーマ
  " colorscheme base16-spacemacs
  " 良いけどコメントが究極的に見づらい...
  " colorscheme base16-tender 
  " colorscheme base16-da-one-sea
  " atomのテーマ。これもコメントが見づらい...
  " colorscheme base16-onedark 
  colorscheme base16-atlas
endfunction

"
" lualine.nvim
"
function! MyPluginSettings#hook_add_lualine() abort
lua << END
  require('lualine').setup({
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'}, -- TODO: user.nameとuser.emailも表示させたい
      lualine_c = {
        {
          'filename',
          file_status = true,      -- Displays file status (readonly status, modified status)
          newfile_status = false,  -- Display new file status (new file means no write after created)
          path = 1,                -- 0: Just the filename
                                   -- 1: Relative path
                                   -- 2: Absolute path
                                   -- 3: Absolute path, with tilde as the home directory
                                   -- 4: Filename and parent dir, with tilde as the home directory
          shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                                   -- for other components. (terrible name, any suggestions?)
          symbols = {
            modified = '[+]',      -- Text to show when the file is modified.
            readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
            newfile = '[New]',     -- Text to show for newly created file before first write
          }
        }
      },
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    tabline = {
      lualine_a = {'tabs'},
      lualine_b = {
        {
          'filename',
          file_status = true,      -- Displays file status (readonly status, modified status)
          newfile_status = false,  -- Display new file status (new file means no write after created)
          path = 1,                -- 0: Just the filename
                                   -- 1: Relative path
                                   -- 2: Absolute path
                                   -- 3: Absolute path, with tilde as the home directory
                                   -- 4: Filename and parent dir, with tilde as the home directory
          shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                                   -- for other components. (terrible name, any suggestions?)
          symbols = {
            modified = '[+]',      -- Text to show when the file is modified.
            readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
            newfile = '[New]',     -- Text to show for newly created file before first write
          }
        }
      },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {'buffers'}
    }
  })
END
endfunction

" 
" gruvbox.nvim
" 
function! MyPluginSettings#hook_add_gruvbox() abort
  set background=dark " or light if you want light mode
  colorscheme gruvbox
lua << EOF
  local colors = require("gruvbox.palette").colors;
  -- diffviewの色を変更
  function FixGruvbox()
    vim.api.nvim_set_hl(0, 'DiffviewDiffAddAsDelete', { bg = "#431313" })
    vim.api.nvim_set_hl(0, 'DiffDelete', { bg = "none", fg = colors.dark2 })
    vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', { bg = "none", fg = colors.dark2 })
    vim.api.nvim_set_hl(0, 'DiffAdd', { bg = "#142a03" })
    vim.api.nvim_set_hl(0, 'DiffChange', { bg = "#3B3307" })
    vim.api.nvim_set_hl(0, 'DiffText', { bg = "#4D520D" })
  end
  FixGruvbox()
  vim.api.nvim_create_autocmd(
    "ColorScheme",
    { pattern = { "gruvbox" }, callback = FixGruvbox }
  )
EOF
endfunction

"
" blamer.nvim
"
function! MyPluginSettings#hook_add_blamer() abort
  " 日時のフォーマット
  let g:blamer_date_format = '%Y/%m/%d %H:%M'
  " ビジュアルモード時はオフ
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
" indent-blankline.nvim
"
function! MyPluginSettings#hook_source_indent_blankline() abort
lua << EOF
  vim.opt.list = true
  vim.opt.listchars:append({
    space = "⋅",
    tab = "»-",
    trail = "-",
    eol = "↲",
    extends = "»",
    precedes = "«",
    nbsp = "%"
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
  augroup MyCommentstring
    autocmd!
    autocmd FileType php setlocal commentstring=//\ %s
  augroup END
endfunction

"
" vim-autoclose(自作)
"
function! MyPluginSettings#hook_source_autoclose() abort
  let g:autoclose#disable_nextpattern_autoclosing_brackets = []
  let g:autoclose#disable_nextpattern_autoclosing_quots = []
  " 改行の整形機能をオフ
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
  augroup MyColorizer
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
" nvim-tree
"
" NOTE: tree上で`g?`とするとヘルプが開く
" TODO: treeの背景だけちょっと色変えたい
" TODO: 画面分割しててもマウスクリックで開けるように
"       (マウスクリック時の挙動がOと同じになるように)
function! MyPluginSettings#hook_add_nvim_tree() abort
  " nnoremap <C-n> :NvimTreeFindFileToggle<CR>
  nnoremap <C-n> :NvimTreeToggle<CR>
  nnoremap <C-w>t :NvimTreeFindFile<CR>
endfunction

function! MyPluginSettings#hook_source_nvim_tree() abort
lua << EOF
  require("nvim-tree").setup()
EOF
endfunction

"
" toggleterm
" FIXME: <C-w>L<C-w>Jとするとサイズがバグる
"
function! MyPluginSettings#hook_add_toggleterm() abort
  tnoremap <C-`> <Cmd>ToggleTerm<CR>
  nnoremap <C-`> :ToggleTerm<CR>
endfunction

function! MyPluginSettings#hook_source_toggleterm() abort
  " NOTE: 自分が設定した:terminalを使用したい場合もあるので、しばらく併用する
  execute 'source '. g:rc_dir . '/MyTerminal.vim'
lua << EOF
  -- vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]])
  require("toggleterm").setup{
    persist_size = false
  }
EOF
  " カレントバッファのディレクトリでterminalを開く
  command! ToggleTermHere ToggleTerm dir=%:h
endfunction

"
" fzf.vim
"
function! MyPluginSettings#hook_add_fzf() abort
  let g:fzf_commands_expect = 'alt-enter,ctrl-x'
  nnoremap <C-p> :Files<CR>
  nnoremap <space>b :Buffers<CR>
  nnoremap <space>c :Commands<CR>
endfunction

"
" eskk.vim
" まだ設定中のため、今は不使用
" 設定がいい感じになってきたら使いたい
"
function! MyPluginSettings#hook_add_eskk() abort
  " TODO: 変換候補を補完のポップアップに表示するようにする
  "       ddc.vim使うことになるのかな？
  "       でもそれだとcoc.nvimの補完とぶつかりそう...
  " TODO: <S-Space>で<Space>の逆を辿れるようにする
  " 辞書ファイルをダウンロード
  if !filereadable(expand('~/.config/eskk/SKK-JISYO.L'))
    call mkdir('~/.config/eskk', 'p')
    let s:output = system('cd ~/.config/eskk/ && wget http://openlab.jp/skk/dic/SKK-JISYO.L.gz && gzip -d SKK-JISYO.L.gz')
    if v:shell_error
      " NOTE: wgetがなくてダウンロードされなかった時に何の警告も出なかったので、警告を出すようにする
      echo "SKK辞書ファイルのダウンロードが正常に行われませんでした"
      echo s:output
    endif
  endif
  " 辞書ファイルを読み込む設定
  let g:eskk#directory = "~/.config/eskk"
  let g:eskk#dictionary = { 'path': "~/.config/eskk/my_jisyo", 'sorted': 1, 'encoding': 'utf-8',}
  let g:eskk#large_dictionary = {'path': "~/.config/eskk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp',}
  "補完を有効/無効化
  let g:eskk#enable_completion = 0
  "漢字変換を確定しても改行しない。
  let g:eskk#egg_like_newline = 1
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
endfunction

function! MyPluginSettings#hook_source_coc() abort
  " 補完の選択をEnterで決定
  inoremap <expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
  " 定義ジャンプ
  nnoremap <space>d <Plug>(coc-definition)
  " カーソル位置のsymbolをハイライト
  nnoremap gh :call CocActionAsync('highlight')<CR>
  " ドキュメント表示
  nnoremap <silent> <space>h :call MyPluginSettings#show_documentation()<CR>
  " 参照箇所表示
  nnoremap <space>r <Plug>(coc-references)
  " ウィンドウのスクロール
  nnoremap <nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<C-j>"
  nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\<C-k>"
  nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <nowait><expr> <C-i> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 1)\<CR>" : "\<Right>"
  inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
  inoremap <nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 1)\<CR>" : "\<Left>"
  inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
  " 指摘箇所へジャンプ
  nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
  nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
  " フォーマッターを呼び出す
  command! -nargs=0 Format :call CocAction('format')
  augroup MyCocAutocmd
    autocmd!
  " ハイライト色を変更
    autocmd ColorScheme * hi! CocFadeOut ctermfg=7 ctermbg=242 guifg=LightGrey guibg=DarkGrey
    autocmd ColorScheme * hi! CocHintSign ctermfg=7 guifg=LightGrey
  " カーソル位置のsymbolをハイライト
    autocmd CursorHold * silent call CocActionAsync('highlight')
  augroup END
endfunction

" ドキュメント表示
function! MyPluginSettings#show_documentation() abort
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

