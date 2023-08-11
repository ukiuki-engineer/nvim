if vim.g['vimrc#loaded_clipboard'] then
  return
end
vim.g['vimrc#loaded_clipboard'] = true

local has    = vim.fn.has
local exists = vim.fn.exists

if has('linux') and exists('$WSLENV') then
  -- WSLの場合clipboardへのアクセスが重く起動時間への影響が大きいため、timer遅延させる
  vim.cmd([[call timer_start(1000, { tid -> execute("set clipboard+=unnamedplus") })]])
else
  vim.o.clipboard:append("unnamed")
end
