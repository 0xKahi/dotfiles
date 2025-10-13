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

-- Currently not ideal find a better way
-- custom function to check local lsp configs in a `.nvim` folder with settings.json or settings.jsonc
-- if the file contains `{ "lsp": { "<client_name>": { "ignore": true } } }`, the LSP client will not start
-- this allows per-project disabling of LSP clients

---@param client_name string
---@param bufnr integer
M.check_lsp_ignore = function(client_name, bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local config_folder = vim.fs.find({ '.nvim' }, {
    path = vim.fs.dirname(filename),
    upward = true,
    type = 'directory',
  })[1]

  -- print(vim.fs.find({'.nvim'}, { path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)), upward = true, type = 'directory' })[1])

  if config_folder then
    local content = vim.fn.readfile(config_folder .. '/settings.jsonc')
    if #content == 0 then
      return true
    end

    local json_str = table.concat(content, '\n')
    local ok, parsed = pcall(vim.json.decode, json_str)
    if ok and parsed and parsed.lsp and parsed.lsp[client_name] then
      if parsed.lsp[client_name].ignore then
        vim.notify(
          string.format('[LSP Local Config] settings for %s: %s', client_name, vim.inspect(parsed.lsp[client_name])),
          vim.log.levels.INFO,
          {
            title = 'LSP Disabled',
            timeout = 3000,
          }
        )
        return false
      end
    end
  end

  return true
end

---@param client_name string
---@param config vim.lsp.Config
M.lsp_config = function(client_name, config)
  local default_config = vim.lsp.config[client_name]

  local root_dir = config.root_dir or default_config.root_dir

  vim.lsp.config(client_name, {
    filetypes = config.filetypes or default_config.filetypes,
    settings = config.settings or default_config.settings,
    root_dir = function(bufnr, on_dir)
      local enabled = M.check_lsp_ignore(client_name, bufnr)
      if enabled then
        -- if defined own root_markers use validate_start by default
        if root_dir and not config.root_markers then
          root_dir(bufnr, on_dir)
        else
          M.validate_start(bufnr, on_dir, config.root_markers or default_config.root_markers) -- use this as there is no default root_dir
        end
      end
    end,
  })
end

return M
