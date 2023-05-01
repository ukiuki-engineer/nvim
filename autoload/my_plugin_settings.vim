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
function! my_plugin_settings#hook_source_treesitter() abort
" NOTE: 逆にデフォルトの方が見やすい場合はtreesitterを適宜オフに設定する
" NOTE: lua << END〜ENDのインデントを深くするとエラーとなるため注意
lua << END
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true, -- syntax highlightを有効にする
      disable = {    -- デフォルトの方が見やすい場合は無効に
        -- 'toml',
        -- 'css',
        -- 'sql'
      }
    },
    indent = {
      enable = true
    },
    ensure_installed = 'all' -- :TSInstall allと同じ
  }
END
endfunction

"
" vim-quickrun
"
function! my_plugin_settings#hook_add_quickrun() abort
  nnoremap <F5> :QuickRun<CR>
  xnoremap <F5> :QuickRun<CR>
endfunction

"
" nvim-base16
"
function! my_plugin_settings#hook_add_base16() abort
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
function! my_plugin_settings#hook_add_lualine() abort
  " FIXME: filenameの横にreadonlyの記号が出るように(nvim-web-deviconsから引っ張ってくる)
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
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
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
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
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
function! my_plugin_settings#hook_add_gruvbox() abort
  " dark or light if you want light mode
  set background=dark
  colorscheme gruvbox
lua << END
  local colors = require("gruvbox.palette").colors;
  local my_functions = require("my_functions")
  local bg_color = "#282828" -- :hi Normal
  -- diffviewのハイライト色を変更
  function fix_gruvbox()
    vim.api.nvim_set_hl(0, 'DiffviewDiffAddAsDelete', { -- FIXME: 不明
      bg = "#FF0000"
    })
    vim.api.nvim_set_hl(0, 'DiffDelete', {              -- 削除された行
      bg = my_functions.transparent_color(bg_color, "#C70000", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', {      -- 行が追加された場合の左側
      bg = my_functions.transparent_color(bg_color, "#C70000", 0.90),
      fg = colors.dark2
    })
    vim.api.nvim_set_hl(0, 'DiffAdd', {                 -- 追加された行
      bg = my_functions.transparent_color(bg_color, "#009900", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffChange', {              -- 変更行
      bg = my_functions.transparent_color(bg_color, "#b9c42f", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffText', {                -- 変更行の変更箇所
      bg = my_functions.transparent_color(bg_color, "#FD7E00", 0.70)
    })
    -- coc.nvimのハイライト色を変更
    vim.api.nvim_set_hl(0, 'CocFadeOut', {
      bg = my_functions.transparent_color(bg_color, '#ADABAC', 0.50),
      fg = "LightGrey"
    })
    vim.api.nvim_set_hl(0, 'CocHintSign', { fg = "LightGrey" })
  end
  fix_gruvbox()
  vim.api.nvim_create_autocmd(
    "ColorScheme",
    { pattern = { "gruvbox" }, callback = fix_gruvbox }
  )
END
endfunction

"
" vim-nightfly-colors
"
function! my_plugin_settings#hook_add_nightfly_colors() abort
  colorscheme nightfly
lua << END
  local my_functions = require("my_functions")
  local bg_color = "#011627" -- :hi Normal
  -- diffviewのハイライト色を変更
  function fix_nightfly()
    vim.api.nvim_set_hl(0, 'DiffviewDiffAddAsDelete', { -- FIXME: 不明
      bg = "#FF0000"
    })
    vim.api.nvim_set_hl(0, 'DiffDelete', {              -- 削除された行
      bg = my_functions.transparent_color(bg_color, "#C70000", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', {      -- 行が追加された場合の左側
      bg = my_functions.transparent_color(bg_color, "#C70000", 0.90),
      fg = my_functions.transparent_color(bg_color, "#2f2f2f", 0.00)
    })
    vim.api.nvim_set_hl(0, 'DiffAdd', {                 -- 追加された行
      bg = my_functions.transparent_color(bg_color, "#00A100", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffChange', {              -- 変更行
      bg = my_functions.transparent_color(bg_color, "#b9c42f", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffText', {                -- 変更行の変更箇所
      bg = my_functions.transparent_color(bg_color, "#FD7E00", 0.70)
    })
    -- coc.nvimのハイライト色を変更
    -- vim.api.nvim_set_hl(0, 'CocFadeOut', { -- FIXME: 上手くいっていないので後で修正する
      -- bg = my_functions.transparent_color(bg_color, '#ADABAC', 0.50),
      -- fg = "LightGrey"
    -- })
    -- vim.api.nvim_set_hl(0, 'CocHintSign', { fg = "LightGrey" })
  end
  fix_nightfly()
  vim.api.nvim_create_autocmd(
    "ColorScheme",
    { pattern = { "nightfly" }, callback = fix_nightfly }
  )
END
endfunction

"
" blamer.nvim
"
function! my_plugin_settings#hook_add_blamer() abort
  " 日時のフォーマット
  let g:blamer_date_format = '%Y/%m/%d %H:%M'
  " ビジュアルモード時はオフ
  let g:blamer_show_in_visual_modes = 0
  " タイマー遅延で起動させる
  call timer_start(500, function("s:CallBlamerShow"))
endfunction

function! s:CallBlamerShow(timer) abort
  " NOTE: 多分このif文の処理にも時間がかかるので、このif自体もタイマー遅延の対象としている
  if system('git status > /dev/null 2>&1') == 0
    " gitレポジトリなら`:BlamerShow`を実行する
    silent BlamerShow
  endif
endfunction

function! my_plugin_settings#hook_source_diffview() abort
  " NOTE: マウスでスクロールする時は、差分の右側をスクロールしないとスクロールが同期されない
  " TODO: 差分をdiscardする時、confirmするようにする
lua << END
  require('diffview').setup ({
    enhanced_diff_hl = true,
    file_panel = {
      win_config = { -- diffviewのwindowの設定
        type = "split",
        position = "right",
        width = 40,
      },
    },
  })
END
endfunction

"
" indent-blankline.nvim
"
function! my_plugin_settings#hook_source_indent_blankline() abort
lua << END
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
END
endfunction

"
" vim-commentary
"
function! my_plugin_settings#hook_source_commentary() abort
  augroup MyCommentstring
    autocmd!
    autocmd FileType php setlocal commentstring=//\ %s
  augroup END
endfunction

"
" vim-autoclose(自作)
"
function! my_plugin_settings#hook_source_autoclose() abort
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
function! my_plugin_settings#hook_source_colorizer() abort
  augroup MyColorizer
    autocmd!
    autocmd FileType css,html,less,sass,scss,stylus,vim,blade,vue,eruby,toml,lua ColorizerAttachToBuffer
    autocmd BufEnter *.css,*.html,*.sass,*.scss,*.vim,*.blade.php,*.vue,*.erb,*.toml,*.lua ColorizerAttachToBuffer
  augroup END
endfunction

"
" vimhelpgenerator
"
function! my_plugin_settings#hook_source_vimhelpgenerator() abort
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
" 小指が痛いのでマウスで操作しやすいようにカスタマイズしたい...
" TODO: 画面分割しててもマウスクリックで開けるように
"       (マウスクリック時の挙動がOと同じになるように)
" TODO: マウスでツリーの開閉はできないのか？
"       クリックしたらnvim-tree-api.tree.open()を呼ぶボタンをlualineに配置すれば良いかな？
" TODO: Visual選択範囲を一括削除できるように
function! my_plugin_settings#hook_add_nvim_tree() abort
  nnoremap <C-n> :NvimTreeToggle<CR>
  " WSLで`:NvimTreeFindFile`が上手く効かないから苦肉の策...
  if has('linux') && exists('$WSLENV') && exepath('zenhan.exe') != ""
    nnoremap <C-w>t :NvimTreeFindFileToggle<CR>
  else
    nnoremap <C-w>t :NvimTreeFindFile<CR>
  endif
endfunction

function! my_plugin_settings#hook_source_nvim_tree() abort
lua << END
  require("nvim-tree").setup {
    git = {
      ignore = false,          -- .gitignoreされたファイルもtreeに表示する
    },
    -- 以下、treeのrootに関する設定
    -- prefer_startup_root = true,
    sync_root_with_cwd = true, -- `:cd`, `:tcd`と同期
    update_focused_file = {
      enable = false,          -- カレントバッファに合わせて常に更新
      update_root = true,      -- `:NvimTreeFindFile`すると更新
      ignore_list = {},
    },
  }
END
endfunction

"
" toggleterm
" FIXME: <C-w>L<C-w>Jとするとサイズがバグる
"
function! my_plugin_settings#hook_add_toggleterm() abort
  tnoremap <C-`> <Cmd>ToggleTerm<CR>
  nnoremap <C-`> :ToggleTerm<CR>
endfunction

function! my_plugin_settings#hook_source_toggleterm() abort
  " NOTE: 自分が設定した:terminalを使用したい場合もあるので、しばらく併用する
  execute 'source '. g:rc_dir . '/my_terminal.vim'
lua << END
  -- vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]])
  require("toggleterm").setup{
    persist_size = false
  }
END
  " カレントバッファのディレクトリでterminalを開く
  command! ToggleTermHere ToggleTerm dir=%:h
endfunction

"
" fzf.vim
"
function! my_plugin_settings#hook_add_fzf() abort
  let g:fzf_commands_expect = 'alt-enter,ctrl-x'
  " nnoremap <C-p> :Files<CR>
  nnoremap <space>f :Files<CR>
  nnoremap <space>b :Buffers<CR>
  nnoremap <space>g :Rg<CR>
endfunction

"
" eskk.vim
" まだ設定中のため、今は不使用
" 設定がいい感じになってきたら使いたい
"
function! my_plugin_settings#hook_add_eskk() abort
  " TODO: nvim-cmpで変換候補を表示できるようにする
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
" nvim-cmp
"
function! my_plugin_settings#hook_source_cmp() abort
  " TODO: `:ls`→`:`の時は補完しように(補完ウィンドウが出ると`:ls`の結果が全部消える...)
lua << END
  local cmp = require 'cmp'
  -- 検索
  cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline({
      ["<C-p>"] = cmp.mapping.scroll_docs(-1),
      ["<C-n>"] = cmp.mapping.scroll_docs(1),
    }),
    sources = {
      { name = 'buffer' }
    }
  })
  -- コマンド
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline({
      ["<C-p>"] = cmp.mapping.scroll_docs(-1),
      ["<C-n>"] = cmp.mapping.scroll_docs(1),
    }),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
END
endfunction

"
" coc.nvim
"
function! my_plugin_settings#hook_add_coc() abort
  " coc-extensions
  let g:coc_global_extensions = [
    \ '@yaegassy/coc-intelephense',
    \ 'coc-blade',
    \ 'coc-css',
    \ 'coc-cssmodules',
    \ 'coc-docker',
    \ 'coc-eslint',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-prettier',
    \ 'coc-sh',
    \ 'coc-snippets',
    \ 'coc-solargraph',
    \ 'coc-spell-checker',
    \ 'coc-sql',
    \ 'coc-tsserver',
    \ 'coc-vetur',
    \ 'coc-vimlsp',
    \ 'coc-word',
    \ 'coc-xml',
    \ 'coc-yaml',
  \ ]
  " NOTE: スペルチェッカーの辞書登録
  " .config/nvim/coc-settings.json
  "   :CocCommand cSpell.addIgnoreWordToUser
  " (多分)./.vim/coc-settings.json
  "   :CocCommand cSpell.addIgnoreWordToWorkspace
endfunction

function! my_plugin_settings#hook_source_coc() abort
  " 補完の選択をEnterで決定
  inoremap <expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
  " <Tab>/<S-Tab>で補完候補を選択(<C-p>/<C-n>派だけど左小指が痛い時は<Tab>を使いたい...)
  inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
  " 定義ジャンプ
  nnoremap <space>d <Plug>(coc-definition)
  " カーソル位置のsymbolをハイライト
  nnoremap gh :call CocActionAsync('highlight')<CR>
  " ドキュメント表示
  nnoremap <silent> <space>h :call my_plugin_settings#show_documentation()<CR>
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
  " augroup MyCocAutocmd
    " autocmd!
  " ハイライト色を変更(FIXME: 仮)
    autocmd ColorScheme * hi! CocFadeOut ctermfg=7 ctermbg=242 guifg=LightGrey guibg="#576069"
    autocmd ColorScheme * hi! CocHintSign ctermfg=7 guifg=LightGrey
  " カーソル位置のsymbolをハイライト
    " autocmd CursorHold * silent call CocActionAsync('highlight')
  " augroup END
endfunction

" ドキュメント表示
function! my_plugin_settings#show_documentation() abort
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

