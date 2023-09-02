if vim.g["vimrc#loaded_ime"] then
  return
end
vim.g["vimrc#loaded_ime"] = true

local augroup             = vim.api.nvim_create_augroup
local au                  = vim.api.nvim_create_autocmd
local has                 = vim.fn.has
local exepath             = vim.fn.exepath

local events              = { "InsertLeave", "InsertEnter", "CmdlineLeave" }

augroup("my_ime", {})

-- MacOS用
if has("mac") and exepath("im-select") ~= "" then
  au(events, {
    group = "my_ime",
    callback = function()
      vim.fn.jobstart("im-select com.apple.keylayout.ABC")
    end,
  })
end

-- WSL用
if require("utils").is_wsl() and exepath("zenhan.exe") ~= "" then
  au(events, {
    group = "my_ime",
    callback = function()
      vim.fn.jobstart("zenhan.exe 0")
    end,
  })
end
