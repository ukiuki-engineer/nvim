" ================================================================================
" vimscriptで書いた共通処理とか
" ================================================================================
" --------------------------------------------------------------------------------
" utils
" --------------------------------------------------------------------------------
"
" git projectかどうかを返す
"
function! utils#utils#is_git_project() abort
  let result = str2nr(system('git status > /dev/null 2>&1; echo -n $?'))
  " NOTE: return result == 0だと上手くいかなかった...
  if result == 0
    return v:true
  else
    return v:false
  endif
endfunction
"
" 改行を削除する
"
function! utils#utils#delete_line_breaks(str) abort
  return substitute(a:str, '\n', '', 'g')
endfunction

"
" wslか
"
function! utils#utils#is_wsl() abort
  return has('linux') && exists("$WSLENV")
endfunction

"
" 共通で使うconfirm
"
" @param string message
" @return bool
"
function! utils#utils#confirm(message) abort
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
function! utils#utils#echo_error_message(error_code, exception, param = {}) abort
  let l:my_message = "[" .. a:error_code .. "]" .. g:my#const["error_messages"][a:error_code]

  " 定数中のパラメータを渡された文字列に置換
  if a:param != {}
    for l:key in keys(a:param)
       let l:my_message = substitute(l:my_message, '\(:' .. l:key .. '\)', a:param[l:key], '')
    endfor
  endif

  " エラーメッセージ出力
  echohl ErrorMsg
  echomsg l:my_message
  if a:exception != ''
    echomsg a:exception
  endif
  echohl None
endfunction

"
" $がついてるとき用のtagジャンプ
" TODO: 本当はctagsの設定で解決すべきだがとりあえずこれでいいや
"
function! utils#utils#tag_jump_with_dollar()
  " 現在の単語を取得
  let l:current_word = expand('<cword>')

  " タグジャンプのコマンドを構築
  let l:tag_jump_cmd = 'tag ' . l:current_word

  " タグジャンプを試みる
  try
    execute l:tag_jump_cmd
  catch /E426: Tag not found/
    " タグが見つからない場合は、$ を前置して再試行
    let l:tag_with_dollar = '$' . l:current_word
    let l:tag_jump_cmd_with_dollar = 'tag ' . l:tag_with_dollar
    try
      execute l:tag_jump_cmd_with_dollar
    catch /E426: Tag not found/
      " $ を前置しても見つからない場合は、エラーメッセージを表示
      echo "Tag not found: " . l:current_word . " and " . l:tag_with_dollar
    endtry
  endtry
endfunction

"
" 行末に指定されたシンボルを挿入する
" TODO: Visual modeにも対応させる
"
function! utils#utils#append_symbol(symbol)
  " 末尾が指定されたシンボルなら何もしない
  if getline('.') =~ a:symbol .. '$'
    return
  endif

  " 末尾に指定されたシンボルを挿入
  let l:command = "A" .. a:symbol .. "\<Esc>"
  call feedkeys(l:command, 'n')
endfunction
" --------------------------------------------------------------------------------
" lua/config/init.lua
" --------------------------------------------------------------------------------
"
" 標準プラグインの遅延読み込み
" NOTE: 今は使ってない
"
function! utils#utils#lazy_load_standard_plugins() abort
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
