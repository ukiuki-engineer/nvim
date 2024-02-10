" ================================================================================
" vimscriptで書いたプラグイン設定
" ================================================================================
"
" vim-autoclose
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
let s:skk_dir = g:init_dir .. '/skk-dict'
function! plugins#hook_add_skkeleton() abort
  " 辞書が無ければダウンロード
  if !isdirectory(s:skk_dir)
    execute '!git clone https://github.com/skk-dev/dict ' s:skk_dir
  endif

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
      \ s:skk_dir .. "/SKK-JISYO.emoji",
      \ [s:skk_dir .. "/SKK-JISYO.jinmei", "euc-jp"],
      \ [s:skk_dir .. "/SKK-JISYO.hukugougo", "euc-jp"],
      \ [s:skk_dir .. "/SKK-JISYO.station", "euc-jp"],
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
