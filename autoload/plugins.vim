" ================================================================================
" vimscriptで書いたプラグイン設定
" init.lua->lua/*.lua->(必要があれば)->autoload/*.vim
" という流れで統一して見通しを良くするため、
" lua側をエントリーポイントにしてlua側からここの設定を呼ぶようにしている
" 例) plugins.coc.lua_source_coc()->plugins#hook_source_coc() など
" ================================================================================
" -----------------------------------------------------------------------------
" coc.nvim
" -----------------------------------------------------------------------------
" TODO: lua化
function! plugins#hook_source_coc() abort
  " 補完候補の決定
  inoremap <silent><expr> <CR> coc#pum#visible()
        \ ? coc#pum#confirm()
        \ : "\<CR>"
  " 補完候補の選択
  inoremap <silent><expr> <TAB>  coc#pum#visible()
        \ ? coc#pum#next(1)
        \ : "\<TAB>"
  inoremap <silent><expr> <S-TAB> coc#pum#visible()
        \ ? coc#pum#prev(1)
        \ : "\<S-TAB>"
  inoremap <silent><expr> <C-n> coc#pum#visible()
        \ ? coc#pum#next(1)
        \ : coc#refresh()
  inoremap <silent><expr> <C-p> coc#pum#visible()
        \ ? coc#pum#prev(1)
        \ : coc#refresh()
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
  nnoremap <nowait><expr> <C-j> coc#float#has_scroll()
        \ ? coc#float#scroll(1, 1)
        \ : "7j"
  nnoremap <nowait><expr> <C-k> coc#float#has_scroll()
        \ ? coc#float#scroll(0, 1)
        \ : "7k"
  nnoremap <nowait><expr> <C-f> coc#float#has_scroll()
        \ ? coc#float#scroll(1)
        \ : "\<C-f>"
  nnoremap <nowait><expr> <C-b> coc#float#has_scroll()
        \ ? coc#float#scroll(0)
        \ : "\<C-b>"
  inoremap <nowait><expr> <C-i> coc#float#has_scroll()
        \ ? "\<c-r>=coc#float#scroll(1, 1)\<CR>"
        \ : "\<Right>"
  inoremap <nowait><expr> <C-f> coc#float#has_scroll()
        \ ? "\<c-r>=coc#float#scroll(1)\<CR>"
        \ : "\<Right>"
  inoremap <nowait><expr> <C-k> coc#float#has_scroll()
        \ ? "\<c-r>=coc#float#scroll(0, 1)\<CR>"
        \ : "\<Left>"
  inoremap <nowait><expr> <C-b> coc#float#has_scroll()
        \ ? "\<c-r>=coc#float#scroll(0)\<CR>"
        \ : "\<Left>"
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
  let g:autoclose#enabled_autoclosing_tags_filetypes = [
        \ "html",
        \ "xml",
        \ "javascript",
        \ "blade",
        \ "eruby",
        \ "vue",
        \ ]
  " 補完キャンセル機能をオン
  let g:autoclose#cancel_completion_enable = 1
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
    autocmd FileType eruby call autoclose#custom_completion({
          \ 'prev_char' : '%',
          \ 'input_char': '#',
          \ 'output'    : '#  ',
          \ 'back_count': 1
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
" skkeleton
"
" NOTE: lua化保留
let s:skk_dir = ""
function! plugins#hook_add_skkeleton() abort
  " 辞書ファイルダウンロード
  " TODO: 何かどっかで上手くいってないけど面倒だから必要な時に直す
  "       この辺面倒だから全部シェルスクリプト化しといた方が良いかも...
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

" NOTE: lua化保留
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
  let dictionaries = [
        \ {"name": "SKK-JISYO.L", "url": "https://skk-dev.github.io/dict/SKK-JISYO.L.gz"},
        \ {"name" : "SKK-JISYO.emoji.utf8", "url": "https://raw.githubusercontent.com/uasi/skk-emoji-jisyo/master/SKK-JISYO.emoji.utf8"},
        \ {"name" : "SKK-JISYO.jinmei", "url": "https://github.com/skk-dev/dict/blob/master/SKK-JISYO.jinmei"}
        \ ]

  " ~/.skkが無ければ作成
  if isdirectory(s:skk_dir)
    call mkdir(s:skk_dir, 'p')
  endif

  for dictionary in dictionaries
    if filereadable(s:skk_dir .. dictionary['name'])
      continue
    endif

    if dictionary['name'] == 'SKK-JISYO.L'
      let output = system('cd ' .. s:skk_dir .. ' && wget ' .. dictionary['url'] .. ' && gzip -d ' .. dictionary['name'])
    else
      let output = system('cd ' .. s:skk_dir .. ' && curl -O ' .. dictionary['url'])
    endif

    if v:shell_error
      echo dictionary['name'] .. "のダウンロードが正常に行われませんでした"
      echo output
    endif
  endfor
endfunction
