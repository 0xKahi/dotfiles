local M = {}
---
--- Adds a file to the Avante sidebar
--- @param filepath string The path to the file to be added
--- @param relative boolean? Whether the path is already relative (default: false)
--- @return nil
function M.add_to_avante(filepath, relative)
  -- Convert to relative path as needed
  relative = relative or false
  local relative_path
  if relative then
    relative_path = filepath
  else
    relative_path = require('avante.utils').relative_path(filepath)
  end

  -- Get the Avante sidebar
  local sidebar = require('avante').get()

  local was_closed = not sidebar:is_open()
  -- Ensure Avante sidebar is open
  if was_closed then
    require('avante.api').ask()
    sidebar = require('avante').get()
  end

  -- Add the file to Avante
  sidebar.file_selector:add_selected_file(relative_path)

  -- Notify the user
  vim.notify('Added ' .. relative_path .. ' to Avante', vim.log.levels.INFO)
end

return M
