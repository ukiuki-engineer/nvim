local M = {}

function M.timer_start(time)
  vim.fn.timer_start(
    time,
    function()
      M.lua_add()
    end
  )
end

function M.lua_add()
  -- skkeletonのモードを返す
  local function skkeleton_mode()
    local modes = {
      ["hira"]    = "あ",
      ["kata"]    = "ア",
      ["hankata"] = "ｱ",
      ["zenkaku"] = "ａ",
      ["abbrev"]  = "a",
    }
    if vim.fn['skkeleton#is_enabled']() then
      return modes[vim.fn['skkeleton#mode']()]
    else
      return ''
    end
  end

  -- 未pullのコミット数の状態をテキストで返す
  local function pull()
    if next(vim.g['my#git_infomations']) == nil then
      return ""
    end
    return "↓" .. vim.g['my#git_infomations']['commit_count']['remote']
  end

  -- 未pushのコミット数の状態をテキストで返す
  local function push()
    if next(vim.g['my#git_infomations']) == nil then
      return ""
    end
    return "↑" .. vim.g['my#git_infomations']['commit_count']['local']
  end

  -- リモートブランチがあるかの情報をテキストで返す
  local function remote_branch_info_text()
    if next(vim.g['my#git_infomations']) == nil then
      return ""
    end

    return require('utils').remote_branch_info_text() -- リモートブランチがあるかの情報
  end

  -- 変更があるかをテキストで返す
  local function has_changed()
    if next(vim.g['my#git_infomations']) == nil then
      return ""
    end

    if vim.g['my#git_infomations']['has_changed'] then
      return "󰦒"
    else
      return ""
    end
  end

  -- user.nameとuser.emailのtextを返す
  local function user_info()
    if next(vim.g['my#git_infomations']) == nil then
      return ""
    end
    local config = vim.g['my#git_infomations']['config']
    -- return '  ' .. config['user_name'] .. '   hogehoge@gmail.com' -- キャプチャ用
    return '  ' .. config['user_name'] .. '   ' .. config['user_email']
  end

  -- animation {{{
  local frames = {
    "(꜆꜄꜆˙꒳˙)꜆꜄ ｱﾀﾀﾀﾀﾀﾀﾀ!!",
    "(꜄꜆ ˙꒳˙)꜄꜆꜄ｱﾀﾀﾀﾀﾀﾀﾀ!!",
    "(꜄꜆꜄˙꒳˙)꜆꜄꜆ｱﾀﾀﾀﾀﾀﾀﾀ!!",
  }

  local frame_number = 1

  -- ｱﾀﾀﾀﾀﾀﾀﾀ!!
  local function atatata()
    if frame_number > #frames then
      frame_number = 1
    end
    local output = frames[frame_number]
    frame_number = frame_number + 1
    return output
  end
  -- }}}

  require('lualine').setup({
    options = {
      globalstatus = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      -- section_separators = { left = '', right = '' },
      -- component_separators = { left = '', right = '' }
    },
    sections = {
      lualine_a = {
        'mode',
        skkeleton_mode
      },
      lualine_b = {
        -- 'branch', -- NOTE: ←だと、diffviewとかhelpとかで表示されない
        {
          'g:my#git_infomations.branch_name', -- TODO: gin.vimでFugitiveHeadのような関数はないだろうか？
          icon = { '', color = { fg = '#FFA500' } },
          separator = '',
          on_click = function()
            vim.cmd([[GitBranches]])
          end
        },
        {
          pull,
          color = { fg = '#ADFF2F' },
          separator = ''
        },
        {
          push,
          color = { fg = '#00ffff' },
          separator = ''
        },
        {
          remote_branch_info_text,
          color = { fg = '#00ffff' },
          separator = ''
        },
        {
          has_changed,
          color = { fg = '#ffff00' },
        },
        user_info, -- user.name, user.email
      },
      lualine_c = {
        {
          'filetype',
          colored = true,
          icon_only = true,
          icon = { align = 'right' }, -- Display filetype icon on the right hand side
          separator = ''
        },
        {
          'filename',
          file_status = true,     -- Displays file status (readonly status, modified status)
          newfile_status = false, -- Display new file status (new file means no write after created)
          path = 1,               -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path
          -- 3: Absolute path, with tilde as the home directory
          -- 4: Filename and parent dir, with tilde as the home directory
          shorting_target = 40, -- Shortens path to leave 40 spaces in the window
          -- for other components. (terrible name, any suggestions?)
          symbols = {
            modified = '[+]', -- Text to show when the file is modified.
            readonly = '', -- Text to show when the file is non-modifiable or readonly.(\ue0a2)
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
            newfile = '[New]', -- Text to show for newly created file before first write
          }
        },
        'diff',
        'diagnostics',
        atatata,
      },
      lualine_x = { 'encoding', 'fileformat', 'filetype', 'g:colors_name' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
  })
end

return M