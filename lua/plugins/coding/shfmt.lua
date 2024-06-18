local M = {}

function M.lua_source()
  -- shfmtが無ければインストール
  if vim.fn.exepath("shfmt") == "" then
    vim.fn.system("go install mvdan.cc/sh/v3/cmd/shfmt@latest")
  end
  vim.g.shfmt_extra_args  = '-i 2 -ci -bn -s'
  -- NOTE: *.zshでも、:Shfmtで実行はできる
  --       が、zsh固有の構文に対応してないからエラーになったりする
  vim.g.shfmt_fmt_on_save = 1
end

return M
