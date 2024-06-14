function! utils#git_info#refresh_git_infomation(fetch = v:false) abort
  try
    call denops#request('gitInfo', 'refreshGitInfo', [a:fetch])
  catch
    " NOTE: 例外が発生したら何もしない。
    " エラーメッセージ類はdenops側で出すようにする。
    " ここでメッセージ出すようにすると、非git管理化で保存するたびにいちいち表示されるから鬱陶しい。
    " かと言ってここでgit管理化かどうかを判定するのも、二度手間間ある。
  endtry
endfunction

