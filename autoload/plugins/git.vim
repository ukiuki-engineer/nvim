" ================================================================================
" Git
" ================================================================================
"
" blamer.nvim
"
function! plugins#git#hook_add_blamer() abort
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

"
" vim-gitgutter
"
function! plugins#git#hook_source_gitgutter() abort
  " TODO: もっと色々調整したいけど、一旦これで
  nnoremap ]h <Plug>(GitGutterNextHunk)
  nnoremap [h <Plug>(GitGutterPrevHunk)
endfunction
