local opt = vim.opt

-- 文字コード
-- NOTE: `:h encoding-values`
-- Vim が内部処理に利用する文字コード。開いたファイルが文字化けしてたときにいじるのはこれ。
opt.encoding = 'utf-8'
-- Vim が 既存ファイルの 文字コード推定に使う文字コードのリスト。
opt.fileencodings = 'utf-8,sjis,iso-2022-jp,euc-jp'
--  新規ファイルを作成する際の文字コード
opt.fileencoding = 'utf-8'

-- スワップファイルを作らない
opt.swapfile = false
-- マウス有効化
opt.mouse = 'a'
-- 編集中のファイルが変更されたら自動で読み直す
opt.autoread = true
-- カーソル行を表示
opt.cursorline = true
-- カーソル列を表示
opt.cursorcolumn = true
-- ルーラーを表示しない
opt.ruler = false
-- 行番号を表示
opt.number = true
-- タブや改行を表示
opt.list = true
-- タブや改行の表示記号を定義
-- opt.listchars=tab:»-,trail:-,eol:↓,extends:»,precedes:«,nbsp:%

-- 画面を垂直分割する際に右に開く
opt.splitright = true
-- 画面を水平分割する際に下に開く
opt.splitbelow = true

-- 差分
-- 縦分割
opt.diffopt:append("vertical")
-- 空白を無視
-- opt.diffopt:append("iwhiteall")

-- 検索時の挙動
opt.wrapscan = false
opt.ignorecase = true
opt.smartcase = true

-- 置換時に画面分割して該当個所を表示
opt.inccommand = 'split'

-- sessionに保存する内容を指定
opt.sessionoptions = 'buffers,curdir,tabpages'
-- Tab文字を半角スペースにする
opt.expandtab = true

-- viewにoptions, curdirを保存しない
vim.opt.viewoptions:remove("options")
vim.opt.viewoptions:remove("curdir")

-- インデントは基本的に2
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

-- 符号なし数字として扱う
opt.nrformats:append("unsigned")

-- window分割しててもstatuslineを1つに
opt.laststatus = 3

-- タブとか改行の表示
vim.opt.list = true
vim.opt.listchars:append({
  space    = "⋅",
  tab      = "»-",
  trail    = "-",
  eol      = "↓",
  extends  = "»",
  precedes = "«",
  nbsp     = "%"
})
