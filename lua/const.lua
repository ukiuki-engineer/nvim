-------------------------------------------------------------------------------
-- 定数
-- 一応定数ファイル作ったけどそこまでちゃんと管理できてない...
-------------------------------------------------------------------------------
local plugins = {
  TIMER_START_LUALINE    = 100,
  TIMER_START_BUFFERLINE = 100,
  TIMER_START_SATTELITE  = 100,
}

local config = {
  TIMER_START_INIT             = 90,
  TIMER_START_IME              = 1000,
  TIMER_START_CLIPBOARD        = 1000,
  TIMER_START_STANDARD_PLUGINS = 500,
}

local error_messages = {
  ERROR_EXTERNAL_COMMAND   = "An error occurred while executing the external command.",
  ERROR_BRANCH_COMMIT_INFO = "An error occurred while getting branch and commit information.",
  ERROR_GIT_CHANGES        = "An error occurred while checking for git changes.",
  ERROR_USER_INFO          = "An error occurred while getting user name and email.",
}

local M = {}

M.plugins = function(key)
  return plugins[key]
end

M.config = function(key)
  return config[key]
end

M.error_messages = function(key)
  return error_messages[key]
end

return M