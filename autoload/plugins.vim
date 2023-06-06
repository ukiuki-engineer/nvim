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
" ================================================================================
" UI
" ================================================================================
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
function! plugins#hook_add_nvim_tree() abort
  nnoremap <silent> <C-n> :NvimTreeToggle<CR>
  nnoremap <silent> <C-w>t :NvimTreeFindFile<CR>
endfunction

"
" nvim-base16
"
function! plugins#hook_add_base16() abort
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
" ================================================================================
" Code Editting
" ================================================================================
"
" vim-matchup
"
function! plugins#hook_source_matchup() abort
  " TODO: bladeでtagnameonlyが効かない
  let g:matchup_matchpref = {
    \ 'html': {'tagnameonly': 1},
    \ 'xml': {'tagnameonly': 1},
    \ 'blade': {'tagnameonly': 1}
  \}
endfunction

"
" vim-commentary
"
function! plugins#hook_source_commentary() abort
  augroup MyCommentstring
    autocmd!
    autocmd FileType php setlocal commentstring=//\ %s
    autocmd FileType json setlocal commentstring=//\ %s
    autocmd FileType vue setlocal commentstring=<!--\ %s\ -->
    " NOTE: <script>タグ内は、手動で
    " :set commentstring=//\ %s
    " として、
    " :set ft=vue
    " で`<!--  -->`に戻せば良い
  augroup END
endfunction

"
" vim-autoclose(自作)
"
function! plugins#hook_source_autoclose() abort
  let g:autoclose#disable_nextpattern_autoclosing_brackets = []
  let g:autoclose#disable_nextpattern_autoclosing_quots = []
  " 改行の整形機能をオフ
  let g:autoclose#autoformat_newline_enable = 0
  " 補完キャンセル機能をオン
  let g:autoclose#cancel_completion_enable = 1
  " <C-c>で補完をキャンセル
  inoremap <silent><expr> <C-c> autoclose#is_completion() ? autoclose#cancel_completion() : "\<Esc>"
endfunction

"
" nvim-colorizer.lua
"
function! plugins#hook_source_colorizer() abort
  augroup MyColorizer
    autocmd!
    autocmd FileType css,html,less,sass,scss,stylus,vim,blade,vue,eruby,toml,lua ColorizerAttachToBuffer
    autocmd BufEnter *.css,*.html,*.sass,*.scss,*.vim,*.blade.php,*.vue,*.erb,*.toml,*.lua ColorizerAttachToBuffer
  augroup END
endfunction

"
" skk.vim
"
function! plugins#hook_source_skk() abort
  let l:skk_dir = expand('~/.config/nvim/skk')
  " 辞書ファイルをダウンロード
  if !filereadable(l:skk_dir .. '/SKK-JISYO.L')
    call mkdir(l:skk_dir, 'p')
    let l:output = system('cd ' .. l:skk_dir .. ' && wget https://skk-dev.github.io/dict/SKK-JISYO.L.gz && gzip -d SKK-JISYO.L.gz')
    if v:shell_error
      " NOTE: wgetがなくてダウンロードされなかった時に何の警告も出なかったので、警告を出すようにする
      echo "SKK辞書ファイルのダウンロードが正常に行われませんでした"
      echo l:output
    endif
  endif

  imap <C-j> <Plug>(skkeleton-toggle)

  augroup MySkkeleton
    autocmd!
    autocmd User skkeleton-initialize-pre call plugins#skkeleton_init()
    autocmd User skkeleton-enable-pre let b:coc_suggest_disable = v:true
    autocmd User skkeleton-disable-pre let b:coc_suggest_disable = v:false
  augroup END

endfunction

function! plugins#skkeleton_init() abort
  call skkeleton#config({
    \ 'eggLikeNewline': v:true,
    \ 'globalDictionaries': [["~/.config/nvim/skk/SKK-JISYO.L", "euc-jp"]],
    \ 'usePopu': v:true
  \ })
  call skkeleton#register_kanatable('rom', {
    \ "xn": 'ん',
    \ "z\<Space>": ["\u3000", ''],
  \ })
  " call skkeleton#register_keymap('henkan', "\<CR>", 'kakutei')
endfunction
" ================================================================================
" LSP and Completion
" ================================================================================
"
" coc.nvim
"
" FIXME: bladeでも、phpの関数のhoverが読みたい
" NOTE: coc-bladeは、"b:xxx"と打つと補完候補が出る
" NOTE: :CocCommand xx.xxで各拡張機能のコマンドを色々呼び出せる
" NOTE: スペルチェッカーの辞書登録
" .config/nvim/coc-settings.jsonの"cSpell.userWords"に追加
"   :CocCommand cSpell.addWordToUserDictionary
" ./.vim/coc-settings.jsonの"cSpell.ignoreWords"に追加
"   :CocCommand cSpell.addIgnoreWordToWorkspace
" NOTE: Laravel固有のメソッドに対して補完やホバーを行うには、補完ヘルパーファイルを出力する必要がある
" 手順は以下の通り
" composer require --dev barryvdh/laravel-ide-helper # ライブラリをインストール
" composer require barryvdh/laravel-ide-helper:*     # ↑で上手くいかなかった場合
" php artisan ide-helper:generate                    # _ide_helper.phpを生成
" php artisan ide-helper:models --nowrite            # _ide_helper_models.phpを生成
function! plugins#hook_add_coc() abort
  " coc-extensions
  let g:coc_global_extensions = [
    \ '@yaegassy/coc-intelephense',
    \ 'coc-blade',
    \ 'coc-css',
    \ 'coc-cssmodules',
    \ 'coc-docker',
    \ 'coc-eslint',
    \ 'coc-fzf-preview',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-lua',
    \ 'coc-php-cs-fixer',
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
  " \ 'coc-nav',
endfunction

function! plugins#hook_source_coc() abort
  " 補完候補の決定
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
  " 補完候補の選択
  inoremap <silent><expr> <TAB>  coc#pum#visible() ? coc#pum#next(1) : "\<TAB>"
  inoremap <silent><expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-TAB>"
  inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : coc#refresh()
  inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : coc#refresh()
  " 定義ジャンプ
  nnoremap <silent> <space>d <Plug>(coc-definition)
  " ドキュメント表示
  nnoremap <silent> <space>h :call plugins#show_documentation()<CR>
  " float windowへジャンプ
  nnoremap <silent> <space>j <Plug>(coc-float-jump)
  " 参照箇所表示
  nnoremap <silent> <space>r <Plug>(coc-references)
  " カーソル位置のsymbolをハイライト(*でカーソル位置を検索するノリ。shiftがspaceに変わっただけ。)
  nnoremap <silent> <space>8 :call CocActionAsync('highlight')<CR>
  " 上記をダブルクリックでもできるように
  nnoremap <silent> <2-LeftMouse> :call CocActionAsync('highlight')<CR>
  " nnoremap <LeftMouse> <LeftMouse>:call CocActionAsync('highlight')<CR>
  " 指摘箇所へジャンプ
  nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
  nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
  " coc-outlineを表示
  nnoremap <silent><nowait> <space>o :call plugins#toggle_outline()<CR>
  " coc-outlineにジャンプ
  " NOTE: ジャンプ前の箇所に戻るには、普通に<C-o>で
  " NOTE: outline tree上で<space>tで、treeの開閉ができる
  nnoremap <silent><nowait> <space>t :call CocActionAsync('showOutline')<CR>
  " CocCommand fzf-preview.CocOutline
  nnoremap <silent> mo :CocCommand fzf-preview.CocOutline<CR>
  " ウィンドウのスクロール
  nnoremap <nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "10j"
  nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "10k"
  nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <nowait><expr> <C-i> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 1)\<CR>" : "\<Right>"
  inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
  inoremap <nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 1)\<CR>" : "\<Left>"
  inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
  " フォーマッターを呼び出す
  command! Format :call CocAction('format')
  " 開いているバッファをgrep
  command! BufferLines :CocCommand fzf-preview.BufferLines
endfunction

" ドキュメント表示
function! plugins#show_documentation() abort
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" coc-outlineを表示
function! plugins#toggle_outline() abort
  let winid = coc#window#find('cocViewId', 'OUTLINE')
  if winid == -1
    call CocActionAsync('showOutline', 1)
  else
    call coc#window#close(winid)
  endif
endfunction

" ================================================================================
" Git
" ================================================================================
"
" blamer.nvim
"
function! plugins#hook_add_blamer() abort
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

" ================================================================================
" Others
" ================================================================================
"
" vim-quickrun
"
function! plugins#hook_add_quickrun() abort
  nnoremap <F5> :QuickRun<CR>
  xnoremap <F5> :QuickRun<CR>
endfunction

"
" vimhelpgenerator
"
function! plugins#hook_source_vimhelpgenerator() abort
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
" toggleterm
" FIXME: <C-w>L<C-w>Jとするとサイズがバグる
"
function! plugins#hook_add_toggleterm() abort
  tnoremap <silent> <C-`> <Cmd>ToggleTerm<CR>
  nnoremap <silent> <C-`> :ToggleTerm<CR>
endfunction

function! plugins#hook_source_toggleterm() abort
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
function! plugins#hook_add_fzf() abort
  let g:fzf_commands_expect = 'alt-enter,ctrl-x'
  " nnoremap <C-p> :Files<CR>
  nnoremap <space>f :Files<CR>
  nnoremap <space>b :Buffers<CR>
  nnoremap <space>g :Rg<CR>
endfunction

