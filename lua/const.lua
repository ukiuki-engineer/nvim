-------------------------------------------------------------------------------
-- 定数ファイル
-- 一応定数ファイル作ったけどそこまでちゃんと管理できてない...
-------------------------------------------------------------------------------
vim.g["my#const"] = {
  bg_color                     = "#000000", -- FIXME: 一旦
  timer_start_lualine          = 100,
  timer_start_bufferline       = 100,
  timer_start_sattelite        = 100,
  timer_start_init             = 90,
  timer_start_ime              = 1000,
  timer_start_clipboard        = 1000,
  timer_start_standard_plugins = 500,
  error_messages               = {
    error_external_command   = "An error occurred while executing the external command.",
    error_branch_commit_info = "An error occurred while getting branch and commit information.",
    error_git_changes        = "An error occurred while checking for git changes.",
    error_git_user_info      = "An error occurred while getting user name and email.",
  },
}

-- 定数化
vim.cmd([[lockv g:my#const]])
