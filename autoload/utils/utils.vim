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
  echomsg a:exception
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
" 行末にセミコロンを挿入する
"
function! utils#utils#append_semicolon()
  call utils#utils#append_symbol(';')
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
" --------------------------------------------------------------------------------
" lua/config/lazy/commands.lua
" --------------------------------------------------------------------------------
"
" カーソル行/列の表示と非表示
"
function! utils#utils#set_cursor_line_column() abort
  " カーソル行/列を表示
  setlocal cursorline cursorcolumn
  augroup MyCursorLineColumn
    autocmd!
    " カーソル行/列を非表示
    autocmd WinLeave,CursorMoved <buffer> ++once setlocal nocursorline nocursorcolumn
  augroup END
endfunction

"
" ファイラーを取得
"
function! utils#utils#get_filer() abort
  if utils#utils#is_wsl()
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
function! utils#utils#open_filer() abort
  let l:filer = utils#utils#get_filer()
  call system(l:filer .. " .")
endfunction

"
" システムのファイラーを開く(カレントバッファのディレクトリ)
"
function! utils#utils#open_filer_here() abort
  " wslは非対応
  if utils#utils#is_wsl()
    echohl WarningMsg
    echomsg 'TODO: WSL用は未実装'
    echohl None
    return
  endif
  let l:filer = utils#utils#get_filer()
  call system(filer .. " " .. expand("%:p:h"))
endfunction

"
" カレント行のgitコミットのハッシュ値をヤンクする
"
function! utils#utils#yank_commit_hash()
  " git projectではないなら処理終了
  if !utils#utils#is_git_project()
    echohl WarningMsg
    echomsg 'Not a git project.'
    echohl None
    return
  endif

  try
    " 現在のファイルパスを取得
    let l:file_path = expand('%:p')
    " 現在の行番号を取得
    let l:line_number = line('.')
    " 実行コマンド
    let l:command = 'git blame -L ' .. l:line_number .. ',' .. l:line_number .. ' ' .. l:file_path .. " | awk '{print $1}'"

    " ハッシュ値を取得
    let l:commit_hash = system(l:command)
    " 不要な改行を削除
    let l:commit_hash = substitute(l:commit_hash, '\n', '', 'g')

    " コミットハッシュをヤンク
    let @+ = l:commit_hash
    echo "Commit hash yanked: " .. l:commit_hash
  catch
    call utils#utils#echo_error_message('E005', v:exception)
  endtry
endfunction

"
" 日報のタイトルを今日の日付で更新
"
function! utils#utils#update_report_title()
  " 日付を取得
  let date_command =  ['date', '+%Y/%m/%d(%u)']
  let today = system(date_command)

  " 改行を削除
  let today = substitute(today, '\n', '', 'g')
  " 曜日を日本語に
  let today = substitute(today, '(1)', '(月)', '')
  let today = substitute(today, '(2)', '(火)', '')
  let today = substitute(today, '(3)', '(水)', '')
  let today = substitute(today, '(4)', '(木)', '')
  let today = substitute(today, '(5)', '(金)', '')
  let today = substitute(today, '(6)', '(土)', '')
  let today = substitute(today, '(7)', '(日)', '')

  " タイトル
  let title = '##### 日報 ' .. today

  " タイトル更新
  execute 'norm! S' .. title
endfunction
