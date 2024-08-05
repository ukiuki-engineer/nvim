function! utils#git_info#refresh_git_infomation(fetch = v:false) abort
  try
    " グローバル変数がセットされていない or gitプロジェクトではない場合は何もしない
    if !exists('g:utils#git_info#is_git_project') || !g:utils#git_info#is_git_project
      return
    endif
    " git情報を更新
    call denops#request('gitInfo', 'refreshGitInfo', [a:fetch])
  catch
    " エラーメッセージ出力
    call utils#utils#echo_error_message('E008', v:exception)
  endtry
endfunction

