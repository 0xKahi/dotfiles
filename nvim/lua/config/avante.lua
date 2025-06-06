local M = {}
---
--- Adds a file to the Avante sidebar
--- Helper function to get or open the Avante sidebar
--- @return avante.Sidebar The Avante sidebar instance
local function get_or_open_avante_sidebar()
  local sidebar = require('avante').get()
  if not sidebar:is_open() then
    require('avante.api').ask()
    sidebar = require('avante').get()
  end
  return sidebar
end

---
--- Adds a file to the Avante sidebar
--- @param filepath string The path to the file to be added
--- @param relative boolean? Whether the path is already relative (default: false)
--- @return avante.Sidebar The Avante sidebar instance
function M.add_to_avante(filepath, relative)
  -- Convert to relative path as needed
  relative = relative or false
  local relative_path
  if relative then
    relative_path = filepath
  else
    relative_path = require('avante.utils').relative_path(filepath)
  end

  -- Get and ensure Avante sidebar is open
  local sidebar = get_or_open_avante_sidebar()

  -- Add the file to Avante
  sidebar.file_selector:add_selected_file(relative_path)

  -- Notify the user
  vim.notify('Added ' .. relative_path .. ' to Avante', vim.log.levels.INFO)
  return sidebar
end

--- Adds multiple files to the Avante sidebar
--- @param filepaths string[] An array of paths to the files to be added
--- @param relative boolean? Whether the paths are already relative (default: false)
function M.add_multiple_to_avante(filepaths, relative)
  relative = relative or false
  -- Get and ensure Avante sidebar is open once for all files
  local sidebar = get_or_open_avante_sidebar()

  for _, filepath in ipairs(filepaths) do
    local relative_path
    if relative then
      relative_path = filepath
    else
      relative_path = require('avante.utils').relative_path(filepath)
    end
    sidebar.file_selector:add_selected_file(relative_path)
  end
  vim.notify('Added ' .. #filepaths .. ' files to Avante', vim.log.levels.INFO)
  return sidebar
end

---@class NeoTreeToAvanteOpts
---@field type 'filesystem' | 'git_status' type of neotree source

--- @param state any
--- @param opts NeoTreeToAvanteOpts opts for neotree
function M:neotree_add_to_avante(state, opts)
  local node = state.tree:get_node()
  local filepath = node:get_id()

  local sidebar = self.add_to_avante(filepath)

  if sidebar:is_open() then
    sidebar.file_selector:remove_selected_file(string.format('neo-tree %s [1]', opts.type))
  end
end

return M
