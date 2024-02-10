"
" ターミナルをカレントバッファのディレクトリで開く
"
function! terminal#term_here(spOrVsp) abort
  if a:spOrVsp == "sp"
  " 水平分割
    split | wincmd j | resize 20
  elseif a:spOrVsp == "vsp"
    " 垂直分割
    vsplit | wincmd l
  endif
  " ターミナルを開く
  call terminal#execute_here("terminal")
endfunction

"
" カレントバッファのディレクトリに移動してコマンドを実行
"
function! terminal#execute_here(command) abort
  " 無名バッファでなければ移動
  if expand('%') != ''
    lcd %:h
  endif
  " コマンド実行
  execute a:command
endfunction

