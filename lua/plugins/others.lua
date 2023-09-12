-- ================================================================================
-- Others
-- ================================================================================
local augroup = vim.api.nvim_create_augroup
local au      = vim.api.nvim_create_autocmd
local g       = vim.g
local fn      = vim.fn
local keyset  = vim.keymap.set
local opts    = { noremap = true, silent = true }

local M       = {}


--
-- vim-quickrun
--
function M.lua_add_quickrun()
  keyset({ "n", "x" }, "<F5>", ":QuickRun<CR>", opts)
end

--
-- vimhelpgenerator
--
function M.lua_source_vimhelpgenerator()
  g.vimhelpgenerator_defaultlanguage = 'ja'
  g.vimhelpgenerator_version = ''
  g.vimhelpgenerator_author = 'Author  : ukiuki-engineer'
  g.vimhelpgenerator_contents = {
    contents         = 1,
    introduction     = 1,
    usage            = 1,
    interface        = 1,
    variables        = 1,
    commands         = 1,
    ["key-mappings"] = 1,
    functions        = 1,
    setting          = 0,
    todo             = 1,
    changelog        = 0
  }
end

--
-- previm
--
function M.lua_source_previm()
  -- fn["plugins#hook_source_previm"]()
  g.previm_show_header = 1
  g.previm_enable_realtime = 1
  if fn.has('mac') == 1 then
    -- MacOS用
    g.previm_open_cmd = [[open -a safari]]
  elseif require("utils").is_wsl() then
    -- TODO: WSL用
  end
end

--
-- toggleterm.nvim
-- FIXME: <C-w>L<C-w>Jとするとサイズがバグる
--
function M.lua_add_toggleterm()
  keyset("t", "<C-`>", "<Cmd>ToggleTerm<CR>")
  keyset("n", "<C-`>", ":ToggleTerm<CR>")
end

function M.lua_source_toggleterm()
  require("toggleterm").setup {
    persist_size = false
  }
  -- カレントバッファのディレクトリでterminalを開く
  vim.cmd([[command! ToggleTermHere ToggleTerm dir=%:h]])
end

return M
