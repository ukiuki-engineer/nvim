--=============================================================================
-- keymappings
-- plugin用以外のkeymapを定義する
-- plugin用のmappingは各pluginの設定中で行なう
--
-- NOTE: <leader>, <space>の使い分けの方針は一応以下だけど、結構曖昧だしほとんど雰囲気
--         g: コマンドを実行する系？なんか違うような気もする
--   <leaer>: 何かしらのactionを起こす系
--   <space>: 何かを表示する系
--=============================================================================
vim.api.nvim_create_augroup("keymappings", {})
-------------------------------------------------------------------------------
-- localな変数、function
-------------------------------------------------------------------------------
local opts = { noremap = true, silent = true }

-- 次のタブに移動
local function tabnext()
  local count = vim.v.count

  if count > 0 then
    -- tab番号が指定されていればそのタブへ
    vim.cmd(count .. "tabnext")
  else
    -- tab番号指定なしなら次のタブへ
    vim.cmd([[tabnext]])
  end
end

-- 前のタブに移動
local function tabprevious()
  local count = vim.v.count

  if count > 0 then
    -- tab番号が指定されていればそのタブへ
    vim.cmd(count .. "tabnext")
  else
    -- tab番号指定なしなら前のタブへ
    vim.cmd([[tabprevious]])
  end
end
-------------------------------------------------------------------------------
-- NOTE: markは使ってないのでleaderにする
vim.g.mapleader = "m"
-------------------------------------------------------------------------------
-- 通常のmapping
-------------------------------------------------------------------------------
-- <C-d>でdelete
vim.keymap.set("i", "<C-d>", "<Del>", opts)

-- esc2回で検索結果ハイライトをオフに
vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR>", opts)

-- バッファ移動
vim.keymap.set("n", "gb", ":bn<CR>", opts)
vim.keymap.set("n", "gB", ":bN<CR>", opts)

-- 引用(行頭に">"を挿入)
vim.keymap.set({ "n", "x" }, "g>", ":norm! I><space><CR>", opts)
-- 行末に","を挿入
vim.keymap.set("n", "<leader>,", function() vim.fn["utils#utils#append_symbol"](",") end, opts)

-- タブ操作
-- 次のタブへ移動
vim.keymap.set("n", "<TAB>", tabnext, opts)
-- 前のタブへ移動
vim.keymap.set("n", "<S-TAB>", tabprevious, opts)
-- 新規タブ作成
vim.keymap.set("n", "<C-T>", ":tabnew<CR>", opts)
-- タブを閉じる
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", opts)

-- NOTE: <TAB>のmappingが<C-i>にも適用されてしまうので元の動きに戻す
vim.keymap.set({ "n" }, "<C-i>", "<TAB>", opts)
-------------------------------------------------------------------------------
-- ファイルタイプ別keymappings
-------------------------------------------------------------------------------
-- 行末にセミコロンを挿入
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "keymappings",
  pattern = {
    "css",
    "java",
    "javascript",
    "php",
    "scss",
    "sql",
    "typescript",
    "vue",
  },
  callback = function()
    vim.keymap.set("n", "<leader>;", function() vim.fn["utils#utils#append_symbol"](";") end, opts)
  end
})
-- タグジャンプ
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "keymappings",
  pattern = {
    "javascript",
    "vue",
  },
  callback = function()
    vim.keymap.set("n", "<C-]>", vim.fn["utils#utils#tag_jump_with_dollar"], opts)
  end
})
-------------------------------------------------------------------------------
-- 遅延で定義するmapping(vim起動時にあれこれ処理させたくない)
-------------------------------------------------------------------------------

-- <space>1 ~ 9でタブ1 ~ 9に移動
vim.api.nvim_create_autocmd({ "TabNew" }, {
  group = "keymappings",
  callback = function()
    for i = 1, 9 do
      vim.keymap.set("n", "<space>" .. i, ":" .. i .. "tabnext<CR>", opts)
    end
  end,
  once = true,
})

-- 全角文字に行内ジャンプ
vim.api.nvim_create_autocmd({ "BufRead", "CursorMoved" }, {
  group = "keymappings",
  callback = function()
    -- 全角文字と半角文字の対応を定義
    require("utils.utils").jump_to_zenkaku({
      [" "] = "　",
      ["!"] = "！",
      ["%"] = "％",
      ["&"] = "＆",
      ["("] = "（",
      [")"] = "）",
      ["+"] = "＋",
      [","] = "、",
      ["-"] = "ー",
      ["."] = "。",
      ["/"] = "・",
      ["0"] = "０",
      ["1"] = "１",
      ["2"] = "２",
      ["3"] = "３",
      ["4"] = "４",
      ["5"] = "５",
      ["6"] = "６",
      ["7"] = "７",
      ["8"] = "８",
      ["9"] = "９",
      [":"] = "：",
      [";"] = "；",
      ["<"] = "＜",
      ["="] = "＝",
      [">"] = "＞",
      ["?"] = "？",
      ["["] = "「",
      ["]"] = "」",
      ["a"] = "あ",
      ["e"] = "え",
      ["i"] = "い",
      ["o"] = "お",
      ["u"] = "う",
      ["{"] = "『",
      ["|"] = "｜",
      ["}"] = "』",
    })
  end,
  once = true,
})

-- cmdlineモードのkeymapping
vim.api.nvim_create_autocmd({ "CmdLineEnter" }, {
  group = "keymappings",
  callback = function()
    -- cmdlineモードをemacsキーバインドでカーソル移動
    vim.keymap.set("c", "<C-b>", "<Left>", { noremap = true })
    vim.keymap.set("c", "<C-f>", "<Right>", { noremap = true })
    vim.keymap.set("c", "<C-a>", "<Home>", { noremap = true })
    vim.keymap.set("c", "<C-e>", "<End>", { noremap = true })
    vim.keymap.set("c", "<C-d>", "<Del>", { noremap = true })
  end,
  once = true,
})
