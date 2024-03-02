function! git_info#refresh_git_infomation() abort
  call denops#request('gitInfo', 'refreshGitInfo', [])
endfunction

