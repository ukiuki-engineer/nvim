"
" git情報を更新
"
function! utils#git_info#refresh_git_infomation(fetch = v:false) abort
  try
    " グローバル変数がセットされていない or gitプロジェクトではない場合は何もしない
    if !exists('g:utils#git_info#is_git_project') || !g:utils#git_info#is_git_project
      return
    endif
    " メッセージを出力し画面を再描画
    echomsg 'Refreshing git infomation...'
    redraw

    " git情報を更新
    call denops#request('gitInfo', 'refreshGitInfo', [a:fetch])
  catch
    " エラーメッセージ出力
    call utils#utils#echo_error_message('E008', v:exception)
  endtry
endfunction

"
" git情報を更新(非同期)
"
function! utils#git_info#async_refresh_git_infomation(fetch = v:false) abort
  try
    " グローバル変数がセットされていない or gitプロジェクトではない場合は何もしない
    if !exists('g:utils#git_info#is_git_project') || !g:utils#git_info#is_git_project
      return
    endif
    " git情報を更新
    call denops#request('gitInfo', 'asyncRefreshGitInfo', [a:fetch])
  catch
    " エラーメッセージ出力
    call utils#utils#echo_error_message('E011', v:exception)
  endtry
endfunction

