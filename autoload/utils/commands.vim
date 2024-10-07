" ================================================================================
" コマンド定義(lua/config/lazy/commands.lua)から呼ばれる処理
" ================================================================================
"
" カーソル行/列の表示と非表示
"
function! utils#commands#set_cursor_line_column() abort
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
function! utils#commands#get_filer() abort
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
function! utils#commands#open_filer() abort
  let l:filer = utils#commands#get_filer()
  call system(l:filer .. " .")
endfunction

"
" システムのファイラーを開く(カレントバッファのディレクトリ)
"
function! utils#commands#open_filer_here() abort
  " wslは非対応
  if utils#utils#is_wsl()
    echohl WarningMsg
    echomsg 'TODO: WSL用は未実装'
    echohl None
    return
  endif
  let l:filer = utils#commands#get_filer()
  call system(filer .. " " .. expand("%:p:h"))
endfunction

"
" カレント行のgitコミットのハッシュ値をヤンクする
"
function! utils#commands#yank_commit_hash()
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
" NOTE: GNU版のdateコマンド前提
"       Macの場合、homebrewとかでgdateをインストールして、MYVIMRC_REPORT_COMMANDにフルパスを入れておく
"
function! utils#commands#update_report_title(relative_days)
  " dateコマンド
  if exists('$MYVIMRC_REPORT_COMMAND')
    let date_command = $MYVIMRC_REPORT_COMMAND
  else
    " デフォルト
    let date_command = 'date'
  endif

  " dateコマンドが実行可能でなければエラーメッセージ出力して終了
  if !executable(date_command)
    call utils#utils#echo_error_message('E009', '', {'command': date_command})
    return
  endif

  " 実行コマンド
  let execute_command =  [date_command, '+%Y/%m/%d(%u)']

  " 引数の処理
  if a:relative_days != "" && (a:relative_days =~ '^+' || a:relative_days =~ '^[0-9]')
    let relative_days = substitute(a:relative_days, '+', '', '') .. ' days'
    call add(execute_command, '--date')
    call add(execute_command, relative_days)
  elseif a:relative_days != "" && a:relative_days =~ '^-'
    let relative_days = substitute(a:relative_days, '-', '', '') .. ' days ago'
    call add(execute_command, '--date')
    call add(execute_command, relative_days)
  endif

  " 日付を取得
  let today = system(execute_command)

  " シェルで何らかのエラーが発生していればエラーメッセージ出力して終了
  if v:shell_error != 0
    call utils#utils#echo_error_message('E010', v:exception)
    return
  endif

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

