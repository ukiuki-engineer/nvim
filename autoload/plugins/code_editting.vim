" ================================================================================
" Code Editting
" ================================================================================
"
" vim-matchup
"
function! plugins#code_editting#hook_source_matchup() abort
  " TODO: bladeでtagnameonlyが効かない
  let g:matchup_matchpref = {
    \ 'html': {'tagnameonly': 1},
    \ 'xml': {'tagnameonly': 1},
    \ 'blade': {'tagnameonly': 1},
    \ 'vue': {'tagnameonly': 1},
  \}
endfunction

"
" vim-commentary
"
function! plugins#code_editting#hook_source_commentary() abort
  augroup MyCommentstring
    autocmd!
    autocmd FileType applescript setlocal commentstring=#\ %s
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
  " <C-c>で補完をキャンセル
  inoremap <silent><expr> <C-c> autoclose#is_completion() ? autoclose#cancel_completion() : "\<Esc>"
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
    autocmd FileType css,html,less,sass,scss,stylus,vim,blade,vue,eruby,toml,lua ColorizerAttachToBuffer
    autocmd BufEnter *.css,*.html,*.sass,*.scss,*.vim,*.blade.php,*.vue,*.erb,*.toml,*.lua ColorizerAttachToBuffer
  augroup END
endfunction

"
" skkeleton
"
function! plugins#code_editting#hook_add_skkeleton() abort
  " 辞書ファイルをダウンロード {{{
  let l:skk_dir = expand('~/.config/nvim/skk')
  if !filereadable(l:skk_dir .. '/SKK-JISYO.L')
    call mkdir(l:skk_dir, 'p')
    let l:output = system('cd ' .. l:skk_dir .. ' && wget https://skk-dev.github.io/dict/SKK-JISYO.L.gz && gzip -d SKK-JISYO.L.gz')
    if v:shell_error
      " NOTE: wgetがなくてダウンロードされなかった時に何の警告も出なかったので、警告を出すようにする
      echo "SKK辞書ファイルのダウンロードが正常に行われませんでした"
      echo l:output
    endif
  endif
  " }}}

  imap <C-j> <Plug>(skkeleton-toggle)

  augroup MySkkeleton
    autocmd!
    autocmd User skkeleton-initialize-pre call plugins#code_editting#skkeleton_init()
    autocmd User skkeleton-enable-pre let b:coc_suggest_disable = v:true
    autocmd User skkeleton-disable-pre let b:coc_suggest_disable = v:false
  augroup END

endfunction

function! plugins#code_editting#skkeleton_init() abort
  call skkeleton#config({
    \ 'eggLikeNewline': v:true,
    \ 'globalDictionaries': [["~/.config/nvim/skk/SKK-JISYO.L", "euc-jp"]],
    \ 'usePopu': v:true
  \ })
  call skkeleton#register_kanatable('rom', {
    \ "xn": 'ん',
    \ "z\<Space>": ["\u3000"],
  \ })
  " call skkeleton#register_keymap('henkan', "\<CR>", 'kakutei')
endfunction

