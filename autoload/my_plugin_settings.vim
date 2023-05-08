" ================================================================================
" 各プラグインの設定(vimscript)
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

"
" vim-matchup
"
function! my_plugin_settings#hook_source_matchup() abort
  augroup MyMatchupColor
    autocmd!
    autocmd ColorScheme * MatchParen cterm=bold gui=bold guibg=#FF0000
  augroup END
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
  nnoremap <C-w>t :NvimTreeFindFile<CR>
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
" coc.nvim
"
" FIXME: bladeでも、phpの関数のhoverが読みたい
" NOTE: coc-bladeは、"b:xxx"と打つと補完候補が出る
" NOTE: :CocCommand xx.xxで各拡張機能のコマンドを色々呼び出せる
" NOTE: スペルチェッカーの辞書登録
" .config/nvim/coc-settings.json
"   :CocCommand cSpell.addIgnoreWordToUser
" (多分)./.vim/coc-settings.json
"   :CocCommand cSpell.addIgnoreWordToWorkspace
" NOTE: Laravel固有のメソッドに対して補完やホバーを行うには、補完ヘルパーファイルを出力する必要がある
" 手順は以下の通り
" composer require --dev barryvdh/laravel-ide-helper # ライブラリをインストール
" php artisan ide-helper:generate                    # _ide_helper.phpを生成
" php artisan ide-helper:models --nowrite            # _ide_helper_models.phpを生成
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
    \ 'coc-lua',
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
  " ドキュメント表示
  nnoremap <silent> <space>h :call my_plugin_settings#show_documentation()<CR>
  " 参照箇所表示
  nnoremap <space>r <Plug>(coc-references)
  " カーソル位置のsymbolをハイライト(*でカーソル位置を検索するノリ。shiftがspaceに変わっただけ。)
  nnoremap <space>8 :call CocActionAsync('highlight')<CR>
  " 上記をダブルクリックでもできるように
  nnoremap <2-LeftMouse> :call CocActionAsync('highlight')<CR>
  " nnoremap <LeftMouse> <LeftMouse>:call CocActionAsync('highlight')<CR>
  " 指摘箇所へジャンプ
  nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
  nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
  " ウィンドウのスクロール
  nnoremap <nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<C-j>"
  nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\<C-k>"
  nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <nowait><expr> <C-i> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 1)\<CR>" : "\<Right>"
  inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
  inoremap <nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 1)\<CR>" : "\<Left>"
  inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
  " フォーマッターを呼び出す
  command! -nargs=0 Format :call CocAction('format')
  " augroup MyCocAutocmd
    " autocmd!
  " ハイライト色を変更(FIXME: 仮)
    " autocmd ColorScheme * hi! CocFadeOut ctermfg=7 ctermbg=242 guifg=LightGrey guibg="#576069"
    " autocmd ColorScheme * hi! CocHintSign ctermfg=7 guifg=LightGrey
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

