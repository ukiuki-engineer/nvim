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
" Git情報(g:my#git_infomations)を更新する
"
" @return void
"
" NOTE: g:my#git_infomationsの構造は以下
"
" g:my#git_infomations  : v:t_dict
"   branch_name         : v:t_string
"   exists_remote_branch: v:t_bool
"   commit_count        : v:t_dict
"     remote            : v:t_string
"     local             : v:t_string
"   has_changed         : v:t_bool
"   config              : v:t_dict
"     user_name         : v:t_string
"     user_email        : v:t_string
"
function! utils#refresh_git_infomations(job_id = v:null, exit_status = v:null, event_type = v:null) abort
  " git projectではないなら処理終了
  if !v:lua.require('utils').is_git_project()
    return
  endif

  let g:my#git_infomations = {
    \ 'branch_name'         : '',
    \ 'exists_remote_branch': v:false,
    \ 'commit_count'        : {},
    \ 'has_changed'         : {},
    \ 'config'              : {}
  \ }

  " ブランチ、commit情報
  try
    let g:my#git_infomations['branch_name'] = v:lua.require('utils').get_branch_name()

    let git_info = v:lua.require('utils').get_git_infomations()
    if git_info != 'NO_REMOTE_BRANCH'
      let g:my#git_infomations['exists_remote_branch'] = v:true
      let parts = split(git_info, ', ')
      let g:my#git_infomations['commit_count']['remote'] = parts[0]
      let g:my#git_infomations['commit_count']['local'] = parts[1]
    endif
  catch
    call utils#echo_error_message("E002", v:exception)
  endtry

  " 変更があるか
  try
    let g:my#git_infomations['has_changed'] = v:lua.require('utils').has_git_changed()
  catch
    call utils#echo_error_message("E003", v:exception)
  endtry

  " user.nameとuser.email
  try
    let g:my#git_infomations['config']['user_name'] = utils#delete_line_breaks(system("git config user.name"))
    let g:my#git_infomations['config']['user_email'] = utils#delete_line_breaks(system("git config user.email"))
  catch
    call utils#echo_error_message("E004", v:exception)
  endtry
endfunction

"
" git fetchを非同期に実行し、git情報を更新する
"
" @param boolean fetch trueなら`git fetch`する(default: false)
" @return void
"
function! utils#async_fetch_and_refresh_git_info() abort
  " git projectではないなら処理終了
  if !v:lua.require('utils').is_git_project()
    return
  endif
  call jobstart('git fetch', {'on_exit': function('utils#refresh_git_infomations')})
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
