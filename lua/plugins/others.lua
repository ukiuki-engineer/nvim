-- ================================================================================
-- Others
-- ================================================================================
local M = {}
--
-- nvim-treesitter
--
M.lua_source_treesitter = function()
  -- NOTE: 逆にデフォルトの方が見やすい場合はtreesitterを適宜オフに設定する
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true, -- syntax highlightを有効にする
      disable = {    -- デフォルトの方が見やすい場合は無効に
      }
    },
    indent = {
      enable = true
    },
    matchup = {
      -- enable = true,              -- mandatory, false will disable the whole extension
      -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
    },
    context_commentstring = {
      enable = true,
    },
    ensure_installed = 'all', -- :TSInstall allと同じ
  }
end

return M
