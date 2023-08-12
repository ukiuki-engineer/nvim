if vim.g['vimrc#loaded_keymappings'] then
  return
end
vim.g['vimrc#loaded_keymappings'] = true

vim.g.mapleader = "m"

local keyset = vim.keymap.set
local opts = {noremap = true, silent = true}

local function jump_to_zenkaku(hankaku_zenkaku_pairs)
  for hankaku, zenkaku in pairs(hankaku_zenkaku_pairs) do
    keyset('n', '<leader>f' .. hankaku, 'f' .. zenkaku, opts)
    keyset('n', '<leader>t' .. hankaku, 't' .. zenkaku, opts)
    keyset('n', '<leader>df' .. hankaku, 'df' .. zenkaku, opts)
    keyset('n', '<leader>dt' .. hankaku, 'dt' .. zenkaku, opts)
    keyset('n', '<leader>yf' .. hankaku, 'yf' .. zenkaku, opts)
    keyset('n', '<leader>yt' .. hankaku, 'yt' .. zenkaku, opts)
  end
end

keyset("n", "<Esc><Esc>", ":nohlsearch<CR>", opts)
keyset("n", "<TAB>", ":bn<CR>", opts)
keyset("n", "<S-TAB>", ":bN<CR>", opts)
keyset("x", "<C-j>", "7j", opts)
keyset("x", "<C-k>", "7k", opts)
keyset("c", "<C-b>", "<Left>", opts)
keyset("c", "<C-f>", "<Right>", opts)
keyset("c", "<C-a>", "<Home>", opts)
keyset("c", "<C-e>", "<End>", opts)
keyset("c", "<C-d>", "<Del>", opts)
jump_to_zenkaku({
  [","] = "、",
  ["."] = "。",
  ["("] = "（",
  [")"] = "）",
  ["["] = "「",
  ["]"] = "」",
  ["{"] = "『",
  ["}"] = "』",
  [":"] = "：",
  [";"] = "；",
  ["?"] = "？",
  ["a"] = "あ",
  ["i"] = "い",
  ["u"] = "う",
  ["e"] = "え",
  ["o"] = "お",
})
