let s:skk_dir = $HOME .. '/skk-dict'

function! plugins#skkeleton#hook_add() abort
  " 辞書が無ければダウンロード
  if !isdirectory(s:skk_dir)
    execute '!echo "結構時間かかるよ" && git clone https://github.com/skk-dev/dict ' s:skk_dir
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
      \ [s:skk_dir .. "/SKK-JISYO.L", "euc-jp"],
      \ s:skk_dir .. "/SKK-JISYO.emoji",
      \ [s:skk_dir .. "/SKK-JISYO.jinmei", "euc-jp"],
      \ [s:skk_dir .. "/SKK-JISYO.hukugougo", "euc-jp"],
      \ [s:skk_dir .. "/SKK-JISYO.station", "euc-jp"],
      \ [s:skk_dir .. "/SKK-JISYO.L.unannotated", "euc-jp"],
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
  call skkeleton#register_keymap('henkan', '<BS>', 'henkanBackward')
  call skkeleton#register_keymap('henkan', 'x', '')
endfunction

