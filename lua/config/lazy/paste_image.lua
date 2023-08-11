-- ================================================================================
-- 画像貼り付け
-- 以下のVSCodeのプラグインを参考にvimに移植した
-- https://github.com/mushanshitiancai/vscode-paste-image
-- シェルのコマンドに依存した書き方になってるけど、自分用だからまーいいかな…
-- 今はまだMacOSのみ対応
-- ================================================================================
-- TODO: lua以降後動作未確認
if vim.g['vimrc#loaded_paste_image'] then
  return
end
vim.g['vimrc#loaded_paste_image'] = true

-- コマンド定義
vim.cmd([[command! -nargs=* PasteImage :call utils#paste_image("<args>")]])

-- nvim-cmpの設定をリロード
require("plugins.lsp_and_completion").lua_source_nvim_cmp()
