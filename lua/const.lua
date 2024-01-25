-------------------------------------------------------------------------------
-- 定数ファイル
-- 一応定数ファイル作ったけどそこまでちゃんと管理できてない...
-- TODO: ここの中身を全部autoload/const.vimに移植する
-------------------------------------------------------------------------------
local bg_colors = {
  cobalt2         = "#002f4f",
  synthwave_alpha = "#241B30",
}

vim.g["my#const"] = {
  timer_start_lualine          = 100,
  timer_start_bufferline       = 100,
  timer_start_scrollbar        = 100,
  timer_start_init             = 90,
  timer_start_ime              = 1000,
  timer_start_clipboard        = 1000,
  timer_start_standard_plugins = 500,
  error_messages               = {
    -- TODO: keyをエラーコードにする。エラー表示にもエラーコードを出す。
    -- 要はエラー発生時にエラーコードでgrepできるようにする。
    error_external_command   = "An error occurred while executing the external command.",
    error_branch_commit_info = "An error occurred while getting branch and commit information.",
    error_git_changes        = "An error occurred while checking for git changes.",
    error_git_user_info      = "An error occurred while getting user name and email.",
  },
  bg_colors                    = bg_colors,
  term_bgcolor                 = bg_colors.cobalt2,
  favorite_colorschemes        = {
    "catppuccin",
    "nightfly",
    "tokyonight-night",
    "gruvbox",
    "base16-monokai"
  },
}

-- 定数化
vim.cmd([[lockv g:my#const]])
