if vim.g['vimrc#loaded_commands'] then
  return
end
vim.g['vimrc#loaded_commands'] = true

vim.cmd([[
  command! SetCursorLineColumn                :set cursorline cursorcolumn
  command! SetNoCursorLineColumn              :set nocursorline nocursorcolumn
  command! SourceSession                      :silent! source Session.vim
  command! -bang MksessionAndQuitAll          :mksession! | :qa<bang>
  command! ShowVimrcInfo                      :echo system(g:init_dir .. '/scripts/show-vimrc-info.sh')
  command! OpenVimrc                          :tabnew | :tcd ~/.config/nvim
  " バッファのフルパスをヤンクする(ホームディレクトリは"~"で表記)
  command! YankBufFullPath                    :let @0 = expand('%:~') | :let @+ = expand('%:~')
  " バッファの(:pwdから見た)相対パスをヤンクする
  command! YankBufRelativePath                :let @0 = expand('%') | :let @+ = expand('%')
  " バッファのファイル名をヤンクする
  command! YankBufFileName                    :let @0 = expand('%:t') | :let @+ = expand('%:t')
  " git情報を更新する
  command! RefreshGitInfomation               :call utils#git_info#async_refresh_git_infomation(v:true)
  " autocmdを発火させずに保存
  command! W                                  :noautocmd w
  command! Wq                                 :noautocmd wq
  " システム側のファイラーを開く(カレントディレクトリ)
  command! OpenFiler                          :call utils#commands#open_filer()
  " システム側のファイラーを開く(カレントバッファのディレクトリ)
  command! OpenFilerHere                      :call utils#commands#open_filer_here()
  " カレント行のgitコミットのハッシュ値をヤンクする
  command! YankCommitHash                     :call utils#commands#yank_commit_hash()
  " 日報のタイトルを今日の日付で更新
  command! -nargs=* UpdateReportTitle         :call utils#commands#update_report_title("<args>")
  " カレントバッファのインデントを変更する
  command! -nargs=1 SetlocalIndent            :lua require('utils.utils').setlocal_indent(<args>)
]])

-- カラースキームをランダムに変更するコマンド
vim.api.nvim_create_user_command('ChangeColorscheme', require("utils.utils").change_colorscheme, {})
