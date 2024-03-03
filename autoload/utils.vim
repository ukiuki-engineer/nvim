" ================================================================================
" vimscriptで書いた共通処理とか
" ================================================================================
" --------------------------------------------------------------------------------
" utils
" --------------------------------------------------------------------------------
"
" 改行を削除する
"
function! utils#delete_line_breaks(str) abort
  return substitute(a:str, '\n', '', 'g')
endfunction

"
" wslか
"
function! utils#is_wsl() abort
  return has('linux') && exists("$WSLENV")
endfunction

"
" 共通で使うconfirm
"
" @param string message
" @return bool
"
function! utils#confirm(message) abort
  try
    if confirm(a:message, "&Yes\n&No", 1) == 1
      return v:true
    else
      return v:false
    endif
  catch
    " 例外が発生したら2(no)を返す(<C-c>で中断した場合とか)
    return v:false
  endtry
endfunction

"
" エラーメッセージを出力する
"
" @param string exception
" @param string error_code
" @param dict param
" @return void
"
function! utils#echo_error_message(error_code, exception, param = {}) abort
  let l:my_message = "[" .. a:error_code .. "]" .. g:my#const["error_messages"][a:error_code]

  " 定数中のパラメータを渡された文字列に置換
  if a:param != {}
    for l:key in keys(a:param)
       let l:my_message = substitute(l:my_message, '\(:' .. l:key .. '\)', a:param[l:key], '')
    endfor
  endif

  try
    " エラーメッセージ出力
    call luaeval('require("notify")(_A[1], _A[2])', [l:my_message, "error"])
    if a:exception != "" && a:exception != v:null
      call luaeval('require("notify")(_A[1], _A[2])', [a:exception, "error"])
    endif
  catch
    " notifyが入ってない場合
      echohl ErrorMsg
      echo "[E000]notify module not found."
      echohl None
  endtry
endfunction

"
" ファイラーを取得
"
function! utils#get_filer() abort
  if utils#is_wsl()
    return "explorer.exe"
  elseif has('mac')
    return "open"
  else
    " ファイラーが見つからない警告を出して終了
    echohl WarningMsg
    echomsg 'File explorer not found.'
    echohl None
    return
  endif
endfunction

"
" システムのファイラーを開く(カレントディレクトリ)
"
function! utils#open_filer() abort
  let l:filer = utils#get_filer()
  call system(l:filer .. " .")
endfunction

"
" システムのファイラーを開く(カレントバッファのディレクトリ)
"
function! utils#open_filer_here() abort
  " wslは非対応
  if utils#is_wsl()
    echohl WarningMsg
    echomsg 'TODO: WSL用は未実装'
    echohl None
    return
  endif
  let l:filer = utils#get_filer()
  call system(filer .. " " .. expand("%:p:h"))
endfunction
" --------------------------------------------------------------------------------
" lua/config/init.lua
" --------------------------------------------------------------------------------
"
" 標準プラグインの遅延読み込み
" NOTE: 今は使ってない
"
function! utils#lazy_load_standard_plugins() abort
  augroup MyTimerLoad
    autocmd!
    execute 'au InsertLeave,FileType * ++once call s:packadd_standard_plugins()'
  augroup END
  if expand('%') != ''
    call timer_start(g:my#const['timer_start_standard_plugins'], function("s:timer_load_standard_plugins"))
  endif
endfunction

function! s:packadd_standard_plugins() abort
  unlet g:loaded_matchit
  packadd matchit
endfunction

function! s:timer_load_standard_plugins(timer) abort
  call s:packadd_standard_plugins()
endfunction
" --------------------------------------------------------------------------------
" lua/config/lazy/commands.lua
" --------------------------------------------------------------------------------
"
" カーソル行/列の表示と非表示
"
function! utils#set_cursor_line_column() abort
  " カーソル行/列を表示
  setlocal cursorline cursorcolumn
  augroup MyCursorLineColumn
    autocmd!
    " カーソル行/列を非表示
    autocmd WinLeave,CursorMoved <buffer> ++once setlocal nocursorline nocursorcolumn
  augroup END
endfunction
