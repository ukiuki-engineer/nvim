local M = {}

function M.lua_source()
  vim.g.vimhelpgenerator_defaultlanguage = 'ja'
  vim.g.vimhelpgenerator_version = ''
  vim.g.vimhelpgenerator_author = 'Author  : ukiuki-engineer'
  vim.g.vimhelpgenerator_contents = {
    contents         = 1,
    introduction     = 1,
    usage            = 1,
    interface        = 1,
    variables        = 1,
    commands         = 1,
    ["key-mappings"] = 1,
    functions        = 1,
    setting          = 0,
    todo             = 1,
    changelog        = 0
  }
end

return M
