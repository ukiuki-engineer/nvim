-------------------------------------------------------------------------------
-- 定数ファイル
-- 一応定数ファイル作ったけどそこまでちゃんと管理できてない...
-------------------------------------------------------------------------------
local bg_colors = {
  cobalt2 = "#002f4f",
}

vim.g["my#const"] = {
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
  -- FIXME: 本当は環境変数とかから取得できるようにした方が良いけど一旦↓で。
  --        bg_colorsを定義しといて、環境に応じて↓を手で変える
  term_bgcolor                 = bg_colors.cobalt2,
}

-- 定数化
vim.cmd([[lockv g:my#const]])
