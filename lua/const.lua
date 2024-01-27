-------------------------------------------------------------------------------
-- 定数ファイル
-- 一応定数ファイル作ったけどそこまでちゃんと管理できてない...
-------------------------------------------------------------------------------
local bg_colors = {
  cobalt2         = "#002f4f",
  synthwave_alpha = "#241B30",
}

vim.g["my#const"] = {
  lsp_plugin_selection_coc             = 1,
  lsp_plugin_selection_mason_lspconfig = 2,

  timer_start_lualine                  = 100,
  timer_start_bufferline               = 100,
  timer_start_scrollbar                = 100,
  timer_start_init                     = 90,
  timer_start_ime                      = 1000,
  timer_start_clipboard                = 1000,
  timer_start_standard_plugins         = 500,

  error_codes                          = {
    ["E001"] = "E001: An error occurred while executing the external command.",
    ["E002"] = "E002: An error occurred while getting branch and commit information.",
    ["E003"] = "E003: An error occurred while checking for git changes.",
    ["E004"] = "E004: An error occurred while getting user name and email.",
  },

  bg_colors                            = bg_colors,
  term_bgcolor                         = bg_colors.cobalt2,
  favorite_colorschemes                = {
    "catppuccin",
    "nightfly",
    "tokyonight-night",
    "gruvbox",
    "base16-monokai"
  },
}

-- 定数化
vim.cmd([[lockv g:my#const]])
