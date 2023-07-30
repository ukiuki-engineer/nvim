" ================================================================================
" Code Editting
" ================================================================================
"
" vim-matchup
"
function! plugins#code_editting#hook_source_matchup() abort
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
function! plugins#code_editting#hook_source_commentary() abort
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
function! plugins#code_editting#hook_source_autoclose() abort
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
" lexima.vim
"
function! plugins#code_editting#hook_source_lexima() abort
  " NOTE: 多分改行の機能とぶつかって、cocの補完確定ができなくなってしまっている
endfunction

"
" nvim-colorizer.lua
"
function! plugins#code_editting#hook_source_colorizer() abort
  augroup MyColorizer
    autocmd!
    autocmd FileType css,html,xml,less,sass,scss,stylus,vim,blade,vue,eruby,toml,lua,javascript,markdown ColorizerAttachToBuffer
  augroup END
  lua require 'colorizer'.setup()
endfunction

"
" skkeleton
"
function! plugins#code_editting#hook_add_skkeleton() abort
  " 辞書ファイルダウンロード
  " TODO: 何かどっかで上手くいってないけど面倒だから必要な時に直す
  let s:skk_dir = expand('~/.skk')
  " call s:download_skk_jisyo()

  inoremap <C-j> <Plug>(skkeleton-toggle)
  cnoremap <C-j> <Plug>(skkeleton-toggle)

  augroup MySkkeleton
    autocmd!
    autocmd User skkeleton-initialize-pre call plugins#code_editting#skkeleton_init()
    autocmd User skkeleton-enable-pre let b:coc_suggest_disable = v:true
    autocmd User skkeleton-disable-pre let b:coc_suggest_disable = v:false
  augroup END

endfunction

function! plugins#code_editting#skkeleton_init() abort
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
