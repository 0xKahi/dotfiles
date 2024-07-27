local M = {}

-- formatter command for lua files
function M.luaFormat()
  if vim.bo.filetype ~= 'lua' then
    print('This is not a Lua file. Formatting aborted.')
    return
  end

  vim.lsp.buf.format()
  print('Lua file formatted.')
end

return M
