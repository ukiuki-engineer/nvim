if vim.g['vimrc#loaded_clipboard'] then
  return
end
vim.g['vimrc#loaded_clipboard'] = true

if require("utils").is_wsl() then
  -- WSLの場合clipboardへのアクセスが重く起動時間への影響が大きいため、timer遅延させる
  vim.fn.timer_start(
    vim.g["my#const"].timer_start_clipboard,
    function()
      vim.cmd([[set clipboard+=unnamedplus]])
    end
  )
else
  vim.cmd([[set clipboard+=unnamed]])
end
