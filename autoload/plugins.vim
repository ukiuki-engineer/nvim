" ================================================================================
" vimscriptで書いたプラグイン設定
" luaに移しきれてない設定はここに集める
" lua側をエントリーポイントにしてlua側から呼ぶ
" ================================================================================
" -----------------------------------------------------------------------------
" coc.nvim
" -----------------------------------------------------------------------------
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
    \ 'coc-jedi',
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
    \ 'coc-yank',
  \ ]
    " \ '@yaegassy/coc-laravel',

  command! PreviewCocOutline :CocCommand fzf-preview.CocOutlie
  command! ProjectFiles :CocCommand fzf-preview.ProjectFiles
  command! Changes :CocCommand fzf-preview.Changes
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
  " ウィンドウのスクロール
  nnoremap <nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "7j"
  nnoremap <nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "7k"
  nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <nowait><expr> <C-i> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 1)\<CR>" : "\<Right>"
  inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
  inoremap <nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 1)\<CR>" : "\<Left>"
  inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
  " フォーマッターを呼び出す
  command! Format :call CocAction('format')
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

" -----------------------------------------------------------------------------
" coding
" -----------------------------------------------------------------------------
"
" vim-matchup
"
function! plugins#hook_source_matchup() abort
  " TODO: bladeでtagnameonlyが効かない
  let g:matchup_matchpref = {
    \ 'html' : {'tagnameonly': 1},
    \ 'xml'  : {'tagnameonly': 1},
    \ 'blade': {'tagnameonly': 1},
    \ 'vue'  : {'tagnameonly': 1},
  \ }
endfunction

"
" vim-commentary
"
function! plugins#hook_source_commentary() abort
  augroup MyCommentstring
    autocmd!
    autocmd FileType applescript,toml setlocal commentstring=#\ %s
    autocmd FileType php setlocal commentstring=//\ %s
    autocmd FileType json setlocal commentstring=//\ %s
    autocmd FileType vue setlocal commentstring=<!--\ %s\ -->
  augroup END
endfunction

"
" vim-autoclose(自作)
"
function! plugins#hook_source_autoclose() abort
  " let g:autoclose#autoclosing_brackets_enable = 0
  " let g:autoclose#autoclosing_quots_enable = 0
  " let g:autoclose#autoclosing_eruby_tags = 0
  let g:autoclose#disable_nextpattern_autoclosing_brackets = []
  let g:autoclose#disable_nextpattern_autoclosing_quots = []
  " 改行の整形機能をオフ
  let g:autoclose#autoformat_newline_enable = 0
  " 補完キャンセル機能をオン
  let g:autoclose#cancel_completion_enable = 1
  let g:autoclose#enabled_autoclosing_tags_filetypes = [
    \ "html",
    \ "xml",
    \ "javascript",
    \ "blade",
    \ "eruby",
    \ "vue",
  \ ]
  " <C-c>で補完をキャンセル
  inoremap <silent><expr> <C-c> autoclose#is_completion() ? autoclose#cancel_completion() : "\<Esc>"
  " カスタム補完定義
  augroup autoclose#custom_completion
    autocmd!
    autocmd FileType html,vue,markdown call autoclose#custom_completion({
      \ 'prev_char' : '<',
      \ 'input_char': '!',
      \ 'output'    : '!--  -->',
      \ 'back_count': 4
    \ })
    autocmd FileType eruby call autoclose#custom_completion({
      \ 'prev_char' : '<',
      \ 'input_char': '%',
      \ 'output'    : '%%>',
      \ 'back_count': 2
    \ })
    autocmd FileType blade call autoclose#custom_completion({
      \ 'prev_char' : '{',
      \ 'input_char': '-',
      \ 'output'    : '--  --',
      \ 'back_count': 3
    \ })
  augroup END
endfunction

"
" nvim-colorizer.lua
"
function! plugins#hook_source_colorizer() abort
  augroup MyColorizer
    autocmd!
    autocmd FileType css,html,xml,less,sass,scss,stylus,vim,blade,vue,eruby,toml,lua,javascript,markdown ColorizerAttachToBuffer
  augroup END
  lua require 'colorizer'.setup()
endfunction

"
" skkeleton
"
function! plugins#hook_add_skkeleton() abort
  " 辞書ファイルダウンロード
  " TODO: 何かどっかで上手くいってないけど面倒だから必要な時に直す
  let s:skk_dir = expand('~/.skk')
  " call s:download_skk_jisyo()

  inoremap <C-j> <Plug>(skkeleton-toggle)
  cnoremap <C-j> <Plug>(skkeleton-toggle)

  augroup MySkkeleton
    autocmd!
    autocmd User skkeleton-initialize-pre call plugins#skkeleton_init()
    autocmd User skkeleton-enable-pre let b:coc_suggest_disable = v:true
    autocmd User skkeleton-disable-pre let b:coc_suggest_disable = v:false
  augroup END

endfunction

function! plugins#skkeleton_init() abort
  " NOTE: 多分、絵文字に関しては、Macならctrl+cmd+spaceを押した方が早い
  call skkeleton#config({
    \ 'eggLikeNewline'    : v:true,
    \ 'globalDictionaries': [[s:skk_dir .. "/SKK-JISYO.L", "euc-jp"], s:skk_dir .. "/SKK-JISYO.emoji.utf8", [s:skk_dir .. "/SKK-JISYO.jinmei", "euc-jp"]],
    \ 'usePopup'          : v:true
  \ })
  call skkeleton#register_kanatable('rom', {
    \ "xn"          : ['ん', ''],
    \ "&"           : ['＆', ''],
    \ "("           : ['（', ''],
    \ ")"           : ['）', ''],
    \ "_"           : ['＿', ''],
    \ "+"           : ['＋', ''],
    \ "="           : ['＝', ''],
    \ "~"           : ['〜', ''],
    \ "\'"          : ['’', ''],
    \ "\""          : ['”', ''],
    \ "z\<Space>"   : ["\u3000", ''],
  \ })
  call skkeleton#register_keymap('henkan', '<S-Space>', 'henkanBackward')
endfunction

" 辞書ファイルダウンロード
function! s:download_skk_jisyo() abort
  let s:dictionaries = [
    \ {"name": "SKK-JISYO.L", "url": "https://skk-dev.github.io/dict/SKK-JISYO.L.gz"},
    \ {"name" : "SKK-JISYO.emoji.utf8", "url": "https://raw.githubusercontent.com/uasi/skk-emoji-jisyo/master/SKK-JISYO.emoji.utf8"},
    \ {"name" : "SKK-JISYO.jinmei", "url": "https://github.com/skk-dev/dict/blob/master/SKK-JISYO.jinmei"}
  \ ]

  " ~/.skkが無ければ作成
  if isdirectory(s:skk_dir)
    call mkdir(s:skk_dir, 'p')
  endif

  for dictionary in s:dictionaries
    if filereadable(s:skk_dir .. dictionary['name'])
      continue
    endif

    if dictionary['name'] == 'SKK-JISYO.L'
      let s:output = system('cd ' .. s:skk_dir .. ' && wget ' .. dictionary['url'] .. ' && gzip -d ' .. dictionary['name'])
    else
      let s:output = system('cd ' .. s:skk_dir .. ' && curl -O ' .. dictionary['url'])
    endif

    if v:shell_error
      echo dictionary['name'] .. "のダウンロードが正常に行われませんでした"
      echo s:output
    endif
  endfor
endfunction
" -----------------------------------------------------------------------------
" others
" -----------------------------------------------------------------------------
"
" vimhelpgenerator
"
function! plugins#hook_source_vimhelpgenerator() abort
  let g:vimhelpgenerator_defaultlanguage = 'ja'
  let g:vimhelpgenerator_version = ''
  let g:vimhelpgenerator_author = 'Author  : ukiuki-engineer'
  let g:vimhelpgenerator_contents = {
    \ 'contents' : 1, 'introduction': 1, 'usage': 1, 'interface': 1,
    \ 'variables': 1, 'commands': 1, 'key-mappings': 1, 'functions': 1,
    \ 'setting'  : 0, 'todo': 1, 'changelog': 0
    \ }
endfunction

"
" previm
"
function! plugins#hook_source_previm() abort
  let g:previm_show_header = 1
  let g:previm_enable_realtime = 1
  if has('mac')
    " MacOS用
    let g:previm_open_cmd = 'open -a Google\ Chrome'
  elseif has('linux') && exists('$WSLENV')
    " TODO: WSL用
  endif
endfunction

