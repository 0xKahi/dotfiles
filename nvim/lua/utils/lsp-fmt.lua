---@class ClientEntry
---@field client vim.lsp.Client
---@field supports_formatting boolean

local M = {}

---@type table<string, string[]>
M.formatter_priority = {
  javascript = { 'biome', 'prettier' },
  typescript = { 'biome', 'prettier' },
  javascriptreact = { 'biome', 'prettier' },
  typescriptreact = { 'biome' },
  css = { 'biome', 'prettier' },
  json = { 'biome', 'prettier' },
  lua = { 'stylua' },
  python = { 'pylsp' },
}

---@param bufnr? integer
---@return  vim.lsp.Client[]
function M.get_active_clients(bufnr)
  bufnr = bufnr or 0
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  ---@type vim.lsp.Client[]
  local format_clients = {}
  ---@type ClientEntry[]

  for _, client in ipairs(clients) do
    local supports_formatting = client:supports_method('textDocument/formatting')
    if supports_formatting then
      table.insert(format_clients, client)
    end
  end

  return format_clients
end

---@param clients vim.lsp.Client[]
---@param bufnr? integer
---@return vim.lsp.Client?
function M.get_preferred_formatter(clients, bufnr)
  bufnr = bufnr or 0
  local filetype = vim.bo[bufnr].filetype
  local priority_list = M.formatter_priority[filetype]

  if not priority_list then
    return nil
  end

  ---@type table<string, vim.lsp.Client>
  local client_map = {}
  for _, entry in ipairs(clients) do
    client_map[entry.name] = entry
  end

  for _, formatter_name in ipairs(priority_list) do
    if client_map[formatter_name] then
      return client_map[formatter_name]
    end
  end

  return nil
end

---@param bufnr? integer
function M.lsp_format(bufnr)
  bufnr = bufnr or 0
  local clients = M.get_active_clients(bufnr)
  local preferred = M.get_preferred_formatter(clients, bufnr)
  if preferred then
    vim.notify('Formatting with: **' .. preferred.name .. '**', vim.log.levels.INFO)
    vim.lsp.buf.format({
      async = false,
      -- filter = function(client)
      --   return client.id == preferred.id
      -- end,
      id = preferred.id,
    })
    return
  end

  if #clients > 0 then
    vim.notify('Formatting with default', vim.log.levels.INFO)
    vim.lsp.buf.format({ async = false })
    return
  end

  vim.notify('No LSP formatter available', vim.log.levels.WARN)
end

return M
