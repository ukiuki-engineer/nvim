-------------------------------------------------------------------------------
-- 定数
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

local M = {}

M.plugins = function(key)
  return plugins[key]
end

M.config = function(key)
  return config[key]
end

return M
