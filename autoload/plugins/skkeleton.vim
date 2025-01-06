let s:skk_dir = g:my#const["skk_dir"]

function! plugins#skkeleton#hook_add() abort
  " 辞書が無ければダウンロード
  if !isdirectory(s:skk_dir)
    execute '!mkdir ' . s:skk_dir
    if !isdirectory(s:skk_dir .. "/dict")
      execute '!echo "結構時間かかるよ" && cd ' . s:skk_dir . ' && git clone https://github.com/skk-dev/dict'
    endif
    " TODO: ついでにAquaSKKで使う以下もダウンロードする処理を書く
    " https://github.com/ymrl/SKK-JISYO.emoji-ja
  endif

  inoremap <C-j> <Plug>(skkeleton-toggle)
  cnoremap <C-j> <Plug>(skkeleton-toggle)

  augroup MySkkeleton
    autocmd!
    autocmd User skkeleton-initialize-pre call plugins#skkeleton#init()
    if g:lsp_plugin_selection == g:my#const["lsp_plugin_selection_coc"]
      autocmd User skkeleton-enable-pre let b:coc_suggest_disable = v:true
      autocmd User skkeleton-disable-pre let b:coc_suggest_disable = v:false
    endif
  augroup END

endfunction

function! plugins#skkeleton#init() abort
  call skkeleton#config({
    \ 'eggLikeNewline'    : v:true,
    \ 'globalDictionaries': [
      \ [s:skk_dir .. "/dict/SKK-JISYO.L", "euc-jp"],
      \ s:skk_dir .. "/dict/SKK-JISYO.emoji",
      \ [s:skk_dir .. "/dict/SKK-JISYO.jinmei", "euc-jp"],
      \ [s:skk_dir .. "/dict/SKK-JISYO.hukugougo", "euc-jp"],
      \ [s:skk_dir .. "/dict/SKK-JISYO.station", "euc-jp"],
      \ [s:skk_dir .. "/dict/SKK-JISYO.L.unannotated", "euc-jp"],
    \ ]
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
    \ "who"      : ['うぉ', ''],
  \ })
endfunction

