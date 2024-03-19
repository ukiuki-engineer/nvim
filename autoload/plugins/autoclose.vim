function! plugins#autoclose#hook_source() abort
  " let g:autoclose#autoclosing_brackets_enable = 0
  " let g:autoclose#autoclosing_quots_enable = 0
  let g:autoclose#disable_nextpattern_autoclosing_brackets = []
  let g:autoclose#disable_nextpattern_autoclosing_quots = []
  " 改行の整形機能をオフ
  let g:autoclose#autoformat_newline_enable = 0
  let g:autoclose#autoclosing_tags_enable = 0
  " let g:autoclose#enabled_autoclosing_tags_filetypes = [
  "       \ "html",
  "       \ "xml",
  "       \ "javascript",
  "       \ "blade",
  "       \ "eruby",
  "       \ "vue",
  "       \ ]
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

