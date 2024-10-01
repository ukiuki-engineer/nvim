if vim.g['vimrc#loaded_commands'] then
  return
end
vim.g['vimrc#loaded_commands'] = true

vim.cmd([[
  command! SetCursorLineColumn       :set cursorline cursorcolumn
  command! SetNoCursorLineColumn     :set nocursorline nocursorcolumn
  command! SourceSession             :silent! source Session.vim
  command! -bang MksessionAndQuitAll :mksession! | :qa<bang>
  command! ShowVimrcInfo             :echo system(g:init_dir .. '/scripts/show-vimrc-info.sh')
  command! OpenVimrc                 :tabnew | :tcd ~/.config/nvim
  " バッファのフルパスをヤンクする(ホームディレクトリは"~"で表記)
  command! YankBufFullPath           :let @0 = expand('%:~') | :let @+ = expand('%:~')
  " バッファの(:pwdから見た)相対パスをヤンクする
  command! YankBufRelativePath       :let @0 = expand('%') | :let @+ = expand('%')
  " バッファのファイル名をヤンクする
  command! YankBufFileName           :let @0 = expand('%:t') | :let @+ = expand('%:t')
  " git情報を更新する
  command! RefreshGitInfomation      :call utils#git_info#refresh_git_infomation(v:true)
  " 保存だけ行う(autocmdを発火させない。format on saveとかその他諸々。)
  command! W                         :noautocmd w
  " システム側のファイラーを開く(カレントディレクトリ)
  command! OpenFiler                 :call utils#utils#open_filer()
  " システム側のファイラーを開く(カレントバッファのディレクトリ)
  command! OpenFilerHere             :call utils#utils#open_filer_here()
  " カレント行のgitコミットのハッシュ値をヤンクする
  command! YankCommitHash            :call utils#utils#yank_commit_hash()
  " 日報のタイトルを今日の日付で更新
  command! -nargs=* UpdateReportTitle         :call utils#utils#update_report_title("<args>")
]])

-- カラースキームをランダムに変更するコマンド
vim.api.nvim_create_user_command('ChangeColorscheme', require("utils.utils").change_colorscheme, {})
