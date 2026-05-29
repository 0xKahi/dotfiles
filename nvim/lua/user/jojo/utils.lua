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

---@return boolean
function M.in_visual_mode()
  return vim.fn.mode() == 'v' or vim.fn.mode() == 'V'
end

function M.back_to_normal_mode()
  if vim.api.nvim_get_mode().mode ~= 'n' then
    -- feed the keys directly cos vim.cmd.normal() is buggy
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false) -- gotta do this janky way cos `start_insert` in plugin bugs out
  end
end

---@class PosFormatted
---@field lnum integer line number
---@field col integer column number

---@class CursorPos
---@field raw {startPos: integer[], endPos: integer[]} start and end positions as the raw output
---@field formatted {startPos: PosFormatted, endPos: PosFormatted } start and end positions formatted as lnum and col

---@return CursorPos? cursorPos a table containing the start and end positions of the selected text if in visual mode, nil otherwise
function M.get_cursor_position()
  if M.in_visual_mode() then
    local raw = {
      startPos = vim.fn.getpos('v'),
      endPos = vim.fn.getpos('.'),
    }

    -- {lnum, col} 0-based col to match nvim API
    local a = { lnum = raw.startPos[2], col = raw.startPos[3] - 1 }
    local b = { lnum = raw.endPos[2], col = raw.endPos[3] - 1 }

    -- order by lnum asc, then col asc
    local swap = a.lnum > b.lnum or (a.lnum == b.lnum and a.col > b.col)
    local formatted = {
      startPos = swap and b or a,
      endPos = swap and a or b,
    }

    return { raw = raw, formatted = formatted }
  end
end

---@class FilePath
---@field full string full file path
---@field relative string relative file path

---@return FilePath a table containing the full and relative file paths of the current buffer
function M.get_file_path()
  local full = vim.api.nvim_buf_get_name(0)
  local relative = vim.fn.expand('%:.')
  return { full = full, relative = relative }
end

function M.copy_to_clipboard(text)
  -- Use the system clipboard register
  vim.fn.setreg('+', text)
  vim.notify(text, vim.log.levels.INFO, {
    title = 'Copied to clipboard',
  })
end

return M
