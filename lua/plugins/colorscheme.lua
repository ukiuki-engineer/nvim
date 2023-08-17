-- ================================================================================
-- colorscheme
-- ================================================================================
local augroup = vim.api.nvim_create_augroup
local au      = vim.api.nvim_create_autocmd
--
-- ハイライト色をカスタムする
--
-- TODO: (TODO, FIXME, NOTE)について、どのファイルでもハイライトされるようにする
local function custom_color(bg_color, colorscheme)
  local hi    = vim.api.nvim_set_hl
  local utils = require("utils")

  local function set_customcolor()
    -- diffview
    if colorscheme ~= 'nightfox' then
      hi(0, 'DiffviewDiffAddAsDelete', { -- NOTE: 不明
        bg = "#FF0000"
      })
      hi(0, 'DiffDelete', { -- 削除された行
        bg = utils.transparent_color(bg_color, "#C70000", 0.90)
      })
      hi(0, 'DiffviewDiffDelete', {
        -- 行が追加された場合の左側
        bg = utils.transparent_color(bg_color, "#C70000", 0.90),
        fg = colorscheme == 'gruvbox'
            and require("gruvbox.palette").colors.dark2
            or utils.transparent_color(bg_color, "#2F2F2F", 0.00)
      })
      hi(0, 'DiffAdd', { -- 追加された行
        bg = utils.transparent_color(bg_color, "#00A100", 0.85)
      })
      hi(0, 'DiffChange', { -- 変更行
        bg = utils.transparent_color(bg_color, "#B9C42F", 0.80)
      })
      hi(0, 'DiffText', { -- 変更行の変更箇所
        bg = utils.transparent_color(bg_color, "#FD7E00", 0.60)
      })
    end
    -- coc.nvim
    hi(0, 'CocFadeOut', {
      bg = utils.transparent_color(bg_color, '#ADABAC', 0.50),
      fg = "LightGrey"
    })
    hi(0, 'CocHintSign', { fg = "LightGrey" })
    hi(0, 'CocHighlightText', {
      bg = utils.transparent_color(bg_color, "LightGrey", 0.75),
    })
    if colorscheme == 'gruvbox' then
      hi(0, 'HighlightedyankRegion', {
        bg = utils.transparent_color(bg_color, "#FD7E00", 0.65)
      })
    else
      hi(0, 'HighlightedyankRegion', {
        bg = utils.transparent_color(bg_color, "Magenta", 0.65),
      })
    end
    -- vim-matchup
    hi(0, 'MatchParen', {
      bg = utils.transparent_color(bg_color, "LightGrey", 0.75),
      bold = true,
      underline = false
    })
    hi(0, 'MatchWord', { link = "MatchParen" })
    hi(0, 'MatchWordCur', { link = "MatchParen" })
    -- search
    if colorscheme == 'gruvbox' then
      hi(0, 'CurSearch', {
        reverse = true,
        fg = "#FABD2F",
        bg = "#282828",
      })
      hi(0, 'IncSearch', {
        bg = utils.transparent_color(bg_color, "#FABD2F", 0.70),
      })
      hi(0, 'Search', {
        link = "IncSearch"
      })
    end
  end

  augroup("custom_highlight", {})

  au("ColorScheme", {
    pattern = { colorscheme },
    callback = set_customcolor,
    group = "custom_highlight",
  })
end

local M = {}

--
-- vim-nightfly-colors
--
function M.lua_add_nightfly_colors()
  local bg_color = "#011627" -- :hi Normal
  custom_color(bg_color, "nightfly")
  vim.cmd([[colorscheme nightfly]])
end

--
-- gruvbox.nvim
--
function M.lua_add_gruvbox()
  local bg_color = "#282828" -- :hi Normal
  custom_color(bg_color, "gruvbox")
  vim.o.background = "dark"
  vim.cmd([[colorscheme gruvbox]])
end

--
-- nightfox.nvim
--
function M.lua_add_nightfox()
  local bg_color = "#192330" -- :hi Normal
  custom_color(bg_color, "nightfox")
  vim.cmd([[colorscheme nightfox]])
end

--
-- catppuccin.nvim
--
function M.lua_add_catppuccin()
  local bg_color = "1e1e2e" -- :hi Normal
  custom_color(bg_color, "catppuccin-mocha")
  vim.cmd([[colorscheme catppuccin]])
end

return M
