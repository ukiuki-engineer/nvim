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
  " ---------------------------------------------------------------------------
  " 補完周り
  " 補完候補の決定
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
  " 補完候補の選択
  inoremap <silent><expr> <TAB>  coc#pum#visible() ? coc#pum#next(1) : "\<TAB>"
  inoremap <silent><expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-TAB>"
  inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : coc#refresh()
  inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : coc#refresh()

  " ---------------------------------------------------------------------------
  " GoTo code navigation
  " 定義ジャンプ
  nnoremap <silent> gd <Plug>(coc-definition)
  nnoremap <silent> gy <Plug>(coc-type-definition)
  " TODO: これ何だっけ...
  nnoremap <silent> gi <Plug>(coc-implementation)
  " 参照箇所表示
  nnoremap <silent> gr <Plug>(coc-references)

  " ---------------------------------------------------------------------------
  " ドキュメント表示
  nnoremap <silent> K :call plugins#show_documentation()<CR>

  " ---------------------------------------------------------------------------
  " カーソル位置のsymbolをハイライト(*でカーソル位置を検索するノリ。shiftがspaceに変わっただけ。)
  nnoremap <silent> <space>8 :call CocActionAsync('highlight')<CR>
  " 上記をダブルクリックでもできるように
  nnoremap <silent> <2-LeftMouse> :call CocActionAsync('highlight')<CR>
  " nnoremap <LeftMouse> <LeftMouse>:call CocActionAsync('highlight')<CR>

  " ---------------------------------------------------------------------------
  " 指摘箇所へジャンプ
  nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
  nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

  " ---------------------------------------------------------------------------
  " coc-outlineの操作
  " coc-outlineを表示
  nnoremap <silent><nowait> <space>o :call plugins#toggle_outline()<CR>
  " coc-outlineにジャンプ。tree上で押すとtreeの開閉。
  nnoremap <silent><nowait> <space>t :call CocActionAsync('showOutline')<CR>
  " NOTE: ジャンプ前の箇所に戻るには、普通に<C-o>で

  " ---------------------------------------------------------------------------
  " Symbol renaming
  nnoremap <leader>rn <Plug>(coc-rename)

  " ---------------------------------------------------------------------------
  " float windowの操作
  nnoremap <nowait><expr> <C-j>  coc#float#has_scroll() ? coc#float#scroll(1, 1) : "7j"
  nnoremap <nowait><expr> <C-k>  coc#float#has_scroll() ? coc#float#scroll(0, 1) : "7k"
  nnoremap <nowait><expr> <C-f>  coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <nowait><expr> <C-b>  coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <nowait><expr> <C-i>  coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 1)\<CR>" : "\<Right>"
  inoremap <nowait><expr> <C-f>  coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
  inoremap <nowait><expr> <C-k>  coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 1)\<CR>" : "\<Left>"
  inoremap <nowait><expr> <C-b>  coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
  nnoremap <silent><expr> <space>j coc#float#has_float()  ? "\<Plug>(coc-float-jump)" : "\<space>j"

  " ---------------------------------------------------------------------------
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
  " 補完を無効化するfiletype
  let g:autoclose#disabled_filetypes = ["TelescopePrompt"]

  " <C-c>で補完をキャンセル
  inoremap <silent><expr> <C-c> autoclose#is_completion() ? autoclose#cancel_completion() : "\<Esc>"
  augroup my#autoclose
    autocmd!
    " カスタム補完定義
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
let s:skk_dir = g:init_dir .. '/.skk'
function! plugins#hook_add_skkeleton() abort

  inoremap <C-j> <Plug>(skkeleton-toggle)
  cnoremap <C-j> <Plug>(skkeleton-toggle)

  augroup MySkkeleton
    autocmd!
    autocmd User skkeleton-initialize-pre call plugins#skkeleton_init()
    if g:lsp_plugin_selection == g:my#const["lsp_plugin_selection_coc"]
      autocmd User skkeleton-enable-pre let b:coc_suggest_disable = v:true
      autocmd User skkeleton-disable-pre let b:coc_suggest_disable = v:false
    endif
  augroup END

endfunction

" NOTE: lua化保留
function! plugins#skkeleton_init() abort
  call skkeleton#config({
    \ 'eggLikeNewline'    : v:true,
    \ 'globalDictionaries': [
      \ [s:skk_dir .. "/SKK-JISYO.L", "euc-jp"],
      \ s:skk_dir .. "/SKK-JISYO.emoji.utf8",
      \ [s:skk_dir .. "/SKK-JISYO.jinmei", "euc-jp"]
    \ ],
    \ 'usePopup'          : v:true
  \ })
  call skkeleton#register_kanatable('rom', {
    \ "xn"       : ['ん', ''],
    \ "&"        : ['＆', ''],
    \ "("        : ['（', ''],
    \ ")"        : ['）', ''],
    \ "_"        : ['＿', ''],
    \ "+"        : ['＋', ''],
    \ "="        : ['＝', ''],
    \ "~"        : ['〜', ''],
    \ "\'"       : ['’', ''],
    \ "\""       : ['”', ''],
    \ "z\<Space>": ["\u3000", ''],
    \ "z0"       : ['０', ''],
    \ "z1"       : ['１', ''],
    \ "z2"       : ['２', ''],
    \ "z3"       : ['３', ''],
    \ "z4"       : ['４', ''],
    \ "z5"       : ['５', ''],
    \ "z6"       : ['６', ''],
    \ "z7"       : ['７', ''],
    \ "z8"       : ['８', ''],
    \ "z9"       : ['９', ''],
  \ })
  call skkeleton#register_keymap('henkan', '<S-Space>', 'henkanBackward')
endfunction
