-------------------------------------------------------------------------------
-- 共通処理
-- luaで書いた共通処理はここに集める
-------------------------------------------------------------------------------
local M   = {}

--
-- booleanな値を返すvim.fnのwrapper function
-- (なんかで紹介されてたやつをそのまま使ってる)
-- 例）if require("utils.utils").bool_fn.has('mac') then ... end
--
M.bool_fn = setmetatable({}, {
  __index = function(_, key)
    return function(...)
      local v = vim.fn[key](...)
      if not v or v == 0 or v == "" then
        return false
      elseif type(v) == "table" and next(v) == nil then
        return false
      end
      return true
    end
  end,
})

--
-- テーブル内に値が存在するか
-- →phpのin_array()的な使い方を想定
--
function M.in_array(value, array)
  for _, v in ipairs(array) do
    if v == value then
      return true
    end
  end
  return false
end

--
-- WSLか
--
function M.is_wsl()
  return M.bool_fn.has("linux") and M.bool_fn.exists("$WSLENV")
end

--
-- utils#utils#echo_error_message()のラッパー
--
function M.echo_error_message(error_code, exception, param)
  -- NOTE: luaはデフォルト引数が使えない...
  if param then
    -- パラメータあり
    vim.fn["utils#utils#echo_error_message"](error_code, exception, param)
  else
    -- パラメータなし
    vim.fn["utils#utils#echo_error_message"](error_code, exception)
  end
end

--
-- カラースキームを(g:my#const["favarite_colorschemes"]の中から)ランダムに変更する
-- (これを起動時とかに呼ぶと起動するたびにカラースキーム変わって楽しい)
--
function M.change_colorscheme()
  -- 対象のカラースキーム
  local target_colorschemes = {}
  if vim.g.colors_name == nil or vim.g.colors_name == "" then
    -- カラースキームが設定されて無ければ定数の中身をそのまま使う
    target_colorschemes = vim.g["my#const"]["favorite_colorschemes"]
  else
    -- 現在のカラースキームを除いたリストを作成
    for _, scheme in ipairs(vim.g["my#const"]["favorite_colorschemes"]) do
      if scheme ~= vim.g.colors_name then
        table.insert(target_colorschemes, scheme)
      end
    end
  end

  -- 乱数
  math.randomseed(os.time())
  local random_num = math.random(1, #target_colorschemes)

  -- カラースキームを変更
  vim.cmd("colorscheme " .. target_colorschemes[random_num])
end

--
-- インデントをセットする(バッファローカル)
--
function M.setlocal_indent(indent)
  vim.bo.tabstop     = indent
  vim.bo.shiftwidth  = indent
  vim.bo.softtabstop = indent
end

--
-- git projectかどうか
--
function M.is_git_project()
  local result = tonumber(vim.fn.system('git status > /dev/null 2>&1; echo $?')) == 0
  if not result then
    vim.cmd([[
      echohl WarningMsg
      echomsg 'Not a git project.'
      echohl None
    ]])
  end
  return result
end

--
-- リモートブランチ情報のテキストを返す
--
function M.remote_branch_info_text()
  if not vim.g['utils#git_info#git_info']['exists_remote_branch'] then
    return ""
  else
    -- リモートブランチがあれば空文字を返す
    return ""
  end
end

--
-- 全角文字への行内ジャンプのkeymappingを定義する
--
function M.jump_to_zenkaku(hankaku_zenkaku_pairs)
  local opts = { noremap = true, silent = true }
  for hankaku, zenkaku in pairs(hankaku_zenkaku_pairs) do
    vim.keymap.set({ 'n', 'x' }, '<leader>f' .. hankaku, 'f' .. zenkaku, opts)
    vim.keymap.set({ 'n', 'x' }, '<leader>t' .. hankaku, 't' .. zenkaku, opts)
    vim.keymap.set({ 'n', 'x' }, '<leader>F' .. hankaku, 'F' .. zenkaku, opts)
    vim.keymap.set({ 'n', 'x' }, '<leader>T' .. hankaku, 'T' .. zenkaku, opts)
    vim.keymap.set('n', '<leader>df' .. hankaku, 'df' .. zenkaku, opts)
    vim.keymap.set('n', '<leader>dt' .. hankaku, 'dt' .. zenkaku, opts)
    vim.keymap.set('n', '<leader>cf' .. hankaku, 'cf' .. zenkaku, opts)
    vim.keymap.set('n', '<leader>ct' .. hankaku, 'ct' .. zenkaku, opts)
    vim.keymap.set('n', '<leader>yf' .. hankaku, 'yf' .. zenkaku, opts)
    vim.keymap.set('n', '<leader>yt' .. hankaku, 'yt' .. zenkaku, opts)
  end
end

return M
