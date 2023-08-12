if vim.g["vimrc#loaded_ime"] then
  return
end
vim.g["vimrc#loaded_ime"] = true

local api     = vim.api
local has     = vim.fn.has
local exepath = vim.fn.exepath
local exists  = vim.fn.exists
local events  = {"InsertLeave", "InsertEnter", "CmdlineLeave"}

api.nvim_create_augroup("my_ime", {})

-- MacOS用
if has("mac") and exepath("im-select") ~= "" then
  api.nvim_create_autocmd(events, {
    group = "my_lazyload",
    callback = function()
      vim.fn.jobstart("im-select com.apple.keylayout.ABC")
    end,
    once = true
  })
end

-- WSL用
if has("linux") and exists("$WSLENV") and exepath("zenhan.exe") ~= "" then
  api.nvim_create_autocmd(events, {
    group = "my_lazyload",
    callback = function()
      vim.fn.jobstart("zenhan.exe 0")
    end,
    once = true
  })
end
