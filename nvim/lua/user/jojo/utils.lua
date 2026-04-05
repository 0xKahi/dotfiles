---@class user.jojo.utils
local M = {}

---@class JoJoDebugTableOpts
---@field tbl table
---@field header? string
---@field title? string
---@field timeout? integer

---@param opts JoJoDebugTableOpts
function M.debug_table(opts)
  -- Convert the table to a string using vim.inspect
  local table_str = vim.inspect(opts.tbl)
  -- Add a header if one was provided
  if opts.header then
    table_str = opts.header .. ':\n' .. table_str
  end
  -- Show the table contents as a notification
  vim.notify(table_str, vim.log.levels.DEBUG, {
    title = opts.title or 'Debug Table',
    timeout = opts.timeout or 1000,
  })
end

---@param tbl table
function M.print_table(tbl)
  M.debug_table({ tbl = tbl })
end

return M
