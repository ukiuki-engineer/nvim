function! git_info#refresh_git_infomation(fetch = v:false) abort
  call denops#request('gitInfo', 'refreshGitInfo', [a:fetch])
endfunction

