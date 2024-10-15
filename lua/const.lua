-------------------------------------------------------------------------------
-- 定数ファイル
-- 一応定数ファイル作ったけどそこまでちゃんと管理できてない...
-------------------------------------------------------------------------------
local bg_colors = {
  cobalt2         = "#002f4f",
  nightfly        = "#011627",
  synthwave_alpha = "#241B30",
}

vim.g["my#const"] = {
  lsp_plugin_selection_coc             = 1,
  lsp_plugin_selection_mason_lspconfig = 2,

  -- VimEnter直後の遅延ロード用の定数。
  -- 最初からUI読まれてほしいけど素直に起動するとstartuptimeに影響するので、VimEnter直後の遅延起動用のmsを書いている。
  -- 数字をずらしているのは依存関係のロード順序関係。eventだけではまかない切れなかったのでこのように定数を定義している。
  timer_start_lualine                  = 100,
  timer_start_bufferline               = 100,
  timer_start_scrollbar                = 100,
  timer_start_init                     = 90,
  timer_start_ime                      = 1000,
  timer_start_clipboard                = 1000,
  timer_start_standard_plugins         = 500,

  -- NOTE: エラーコードは、基本ユニークとする。つまり同じエラーコードを複数箇所で使わない。
  --       エラーが発生したらエラーコードでgrepするから。
  error_messages                       = {
    ["E001"] = "エラーが発生しました。",
    ["E002"] = "エラーが発生しました。",
    ["E003"] = "エラーが発生しました。",
    ["E004"] = "エラーが発生しました。",
    ["E005"] = "エラーが発生しました。",
    ["E006"] = "エラーが発生しました。",
    ["E007"] = "エラーが発生しました。",
    ["E008"] = "Git情報更新中にエラーが発生しました。",
    ["E009"] = ":command は実行可能ではありません。",
    ["E010"] = "エラーが発生しました。",
    ["E011"] = "エラーが発生しました。",
  },

  -- 色周り
  bg_colors                            = bg_colors,
  term_bgcolor                         = bg_colors.nightfly,
  favorite_colorschemes                = {
    "catppuccin",
    "duskfox",
    "everforest",
    "gruvbox",
    "kanagawa",
    -- "kanagawa-lotus",
    "nightfly",
    "nightfox",
    "nordfox",
    "terafox",
    "tokyonight-night",
  },
}

-- 定数化
vim.cmd([[lockv g:my#const]])
