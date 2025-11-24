local utils = require('utils.misc')
local commands = {
  all = {
    func = function()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      local client_data = {}

      for _, client in ipairs(clients) do
        local supports_formatting = client.server_capabilities.documentFormattingProvider ~= nil
        client_data[client.name] = supports_formatting
      end

      utils.debug_table({
        tbl = client_data,
        title = 'BufferLspInfo',
        header = 'Current Buffer LSP Clients',
        timeout = 3000,
      })
    end,
  },
  fmt = {
    func = function()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      local client_names = {}

      for _, client in ipairs(clients) do
        local supports_formatting = client.server_capabilities.documentFormattingProvider ~= nil
        if supports_formatting then
          table.insert(client_names, client.name)
        end
      end

      utils.debug_table({
        tbl = client_names,
        title = 'BufferLspInfo',
        header = 'Current Buffer Formatting LSP Clients',
        timeout = 3000,
      })
    end,
  },
}

vim.api.nvim_create_user_command('BufferLspInfo', function(opts)
  local cmd = commands[opts.args]
  if cmd then
    cmd.func()
  else
    print('Unknown BufferLspInfo commands. Available commands: ' .. table.concat(vim.tbl_keys(commands), ', '))
  end
end, {
  nargs = 1,
  complete = function(ArgLead, CmdLine, CursorPos)
    return vim.tbl_filter(function(cmd)
      return cmd:match('^' .. ArgLead)
    end, vim.tbl_keys(commands))
  end,
  desc = 'Custom BufferLspInfo commands. Available: ' .. table.concat(vim.tbl_keys(commands), ', '),
})
