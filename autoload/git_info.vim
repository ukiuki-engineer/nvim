function! git_info#refresh_git_infomation(fetch = v:false) abort
  try
    call denops#request('gitInfo', 'refreshGitInfo', [a:fetch])
  catch
    echohl WarningMsg
    echomsg "Warning: refreshGitInfo is not available yet."
    echohl None
  endtry
endfunction

