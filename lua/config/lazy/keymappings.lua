if vim.g['vimrc#loaded_keymappings'] then
  return
end
vim.g['vimrc#loaded_keymappings'] = true

vim.g.mapleader = "m"

local keymap = vim.keymap.set
local opts = {noremap = true, silent = true}

local function jump_to_zenkaku(hankaku_zenkaku_pairs)
  for hankaku, zenkaku in pairs(hankaku_zenkaku_pairs) do
    keymap('n', '<leader>f' .. hankaku, 'f' .. zenkaku, opts)
    keymap('n', '<leader>t' .. hankaku, 't' .. zenkaku, opts)
    keymap('n', '<leader>df' .. hankaku, 'df' .. zenkaku, opts)
    keymap('n', '<leader>dt' .. hankaku, 'dt' .. zenkaku, opts)
    keymap('n', '<leader>yf' .. hankaku, 'yf' .. zenkaku, opts)
    keymap('n', '<leader>yt' .. hankaku, 'yt' .. zenkaku, opts)
  end
end

keymap("n", "<Esc><Esc>", ":nohlsearch<CR>", opts)
keymap("n", "<TAB>", ":bn<CR>", opts)
keymap("n", "<S-TAB>", ":bN<CR>", opts)
keymap("x", "<C-j>", "7j", opts)
keymap("x", "<C-k>", "7k", opts)
keymap("c", "<C-b>", "<Left>", opts)
keymap("c", "<C-f>", "<Right>", opts)
keymap("c", "<C-a>", "<Home>", opts)
keymap("c", "<C-e>", "<End>", opts)
keymap("c", "<C-d>", "<Del>", opts)
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
