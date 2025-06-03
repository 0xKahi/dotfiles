local M = {}

function M.format_path(filepath)
  local cwd = vim.fs.normalize(vim.fn.getcwd(), { _fast = true, expand_env = false })
  local home = vim.fs.normalize('~')
  local path = vim.fs.normalize(filepath, { _fast = true, expand_env = false })

  if path:find(cwd .. '/', 1, true) == 1 and #path > #cwd then
    path = path:sub(#cwd + 2)
  else
    local root = require('snacks').git.get_root(path)
    if root and root ~= '' and path:find(root, 1, true) == 1 then
      local tail = vim.fn.fnamemodify(root, ':t')
      path = '⋮' .. tail .. '/' .. path:sub(#root + 2)
    elseif path:find(home, 1, true) == 1 then
      path = '~' .. path:sub(#home + 1)
    end
  end
  path = path:gsub('/$', '')
  return path
end

function M.picker_to_avante()
  -- have to use this to get the proper picker object
  local snacks_picker = Snacks.picker.get()[1]
  if not snacks_picker then
    vim.notify('No active picker found', vim.log.levels.ERROR)
    return
  end

  local sel = snacks_picker:selected()
  local files_to_add = {}
  for _, item in ipairs(sel) do
    table.insert(files_to_add, item.file)
  end
  require('config.avante').add_multiple_to_avante(files_to_add, true)
end

return M
