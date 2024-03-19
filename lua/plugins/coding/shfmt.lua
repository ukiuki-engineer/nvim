local M = {}

function M.lua_source()
  -- shfmtが無ければインストール
  if vim.fn.exepath("shfmt") == "" then
    vim.fn.system("go install mvdan.cc/sh/v3/cmd/shfmt@latest")
  end
  vim.g.shfmt_extra_args  = '-i 2 -ci -bn -s'
  vim.g.shfmt_fmt_on_save = 1 -- TODO: zshとかでformat on saveが効くようにできないだろうか？
end

return M
