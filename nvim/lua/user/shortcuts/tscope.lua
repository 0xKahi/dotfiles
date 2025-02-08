-- commands shortcuts

local telescope_commands = {
  dg = {
    func = function()
      require('telescope.builtin').diagnostics()
    end,
    desc = 'Diagnostics',
  },
  ['git status'] = {
    func = function()
      require('telescope.builtin').git_status()
    end,
    desc = 'Git Status',
  },
  ['doc symb'] = {
    func = function()
      require('telescope.builtin').lsp_document_symbols()
    end,
    desc = 'Lists LSP document symbols in the current buffer',
  },
}

-- Create custom command for Telescope
vim.api.nvim_create_user_command('Tscope', function(opts)
  local cmd = telescope_commands[opts.args]
  if cmd then
    cmd.func()
  else
    print('Unknown Tscope command. Available commands: ' .. table.concat(vim.tbl_keys(telescope_commands), ', '))
  end
end, {
  nargs = 1,
  complete = function(ArgLead, CmdLine, CursorPos)
    return vim.tbl_filter(function(cmd)
      return cmd:match('^' .. ArgLead)
    end, vim.tbl_keys(telescope_commands))
  end,
  desc = 'Custom Telescope commands. Available: ' .. table.concat(vim.tbl_keys(telescope_commands), ', '),
})
