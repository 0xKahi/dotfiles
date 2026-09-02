local M = {}

M.validate_start = function(bufnr, on_dir, root_markers)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local root = vim.fs.find(root_markers, {
    path = vim.fs.dirname(filename),
    upward = true,
  })[1]

  if root then
    on_dir(vim.fs.dirname(root))
  end
end

---@param bufnr integer
---@param root_markers? string[]
M.has_disabled_root_markers = function(bufnr, root_markers)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local root = vim.fs.find(root_markers, {
    path = vim.fs.dirname(filename),
    upward = true,
  })[1]

  return root ~= nil
end

--- Returns the per-project LSP ignore override from `.nvim/settings.jsonc` or `.nvim/settings.json`.
---@param client_name string
---@param bufnr integer
---@return boolean? ignore
M.get_lsp_ignore_override = function(client_name, bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local config_folder = vim.fs.find('.nvim', {
    path = vim.fs.dirname(filename),
    upward = true,
    type = 'directory',
  })[1]

  if not config_folder then
    return nil
  end

  local settings_file
  for _, name in ipairs({ 'settings.jsonc', 'settings.json' }) do
    local candidate = config_folder .. '/' .. name
    if vim.fn.filereadable(candidate) == 1 then
      settings_file = candidate
      break
    end
  end

  if not settings_file then
    return nil
  end

  local read_ok, content = pcall(vim.fn.readfile, settings_file)
  if not read_ok or #content == 0 then
    return nil
  end

  local decode_ok, settings = pcall(vim.json.decode, table.concat(content, '\n'))
  if not decode_ok or type(settings) ~= 'table' or type(settings.lsp) ~= 'table' then
    return nil
  end

  local client_config = settings.lsp[client_name]
  if type(client_config) == 'table' and type(client_config.ignore) == 'boolean' then
    return client_config.ignore
  end

  return nil
end

---@class WorkspaceLspConfig : vim.lsp.Config
--- Optional field to avoid enabling lsp client if certain root markers are found, useful for monorepos or projects with multiple configs
---@field avoid_root_markers? string[]
---@field disable? boolean
---@field ignore? boolean

---@param client_name string
---@param config WorkspaceLspConfig
M.lsp_config = function(client_name, config)
  local default_config = vim.lsp.config[client_name]

  local root_dir = config.root_dir or default_config.root_dir

  vim.lsp.config(client_name, {
    filetypes = config.filetypes or default_config.filetypes,
    settings = config.settings or default_config.settings,
    root_dir = function(bufnr, on_dir)
      if config.disable == true then
        vim.notify(client_name .. ' disabled', vim.log.levels.DEBUG, {
          title = 'Lsp Global Disabled',
          timeout = 1000,
        })
        return
      end

      local local_ignore = M.get_lsp_ignore_override(client_name, bufnr)
      local should_ignore = local_ignore

      if should_ignore == nil then
        should_ignore = config.ignore == true
      end

      if should_ignore then
        local source = local_ignore == true and 'local config' or 'Neovim config'
        vim.notify(string.format('%s ignored by %s', client_name, source), vim.log.levels.INFO, {
          title = 'LSP Disabled',
          timeout = 3000,
        })
        return
      end

      if config.ignore == true and local_ignore == false then
        vim.notify(string.format('%s enabled by local override', client_name), vim.log.levels.INFO, {
          title = 'LSP Override',
          timeout = 3000,
        })
      end

      if config.avoid_root_markers and M.has_disabled_root_markers(bufnr, config.avoid_root_markers) then
        JoJo.utils.debug_table({
          tbl = { lsp = { [client_name] = { ignore = true } } },
          title = 'LSP Disabled by Root Marker',
          header = 'Disabled root marker found; consider adding this to .nvim/settings.jsonc',
        })
        return
      end

      -- If custom root markers are defined, use validate_start by default.
      if root_dir and not config.root_markers then
        root_dir(bufnr, on_dir)
      else
        M.validate_start(bufnr, on_dir, config.root_markers or default_config.root_markers)
      end
    end,
  })
end

return M
