local M = {}

function M.random_selector(tbl)
  if type(tbl) ~= 'table' then
    error('Expected table as argument')
  end

  -- Create an array of keys
  local keys = {}
  for key, _ in pairs(tbl) do
    table.insert(keys, key)
  end

  if #keys == 0 then
    return nil, nil
  end

  local key = keys[math.random(#keys)]
  return tbl[key]
end

-- for printing tables
function M.debug_table(tbl, title)
  -- Convert the table to a string using vim.inspect
  local table_str = vim.inspect(tbl)
  -- Add a title if one was provided
  if title then
    table_str = title .. ':\n' .. table_str
  end
  -- Show the table contents as a notification
  vim.notify(table_str, vim.log.levels.DEBUG)
end

---@class StartInINormaModeOpts
---@field generic? fun() function to run on other modes without any specific mode functions
---@field normal? fun() function to run on normal mode
---@field other? fun() function to run on other modes

--- Factory function to create snippet handlers.
---@param opts StartInINormaModeOpts The configuration for this specific snippet type.
function M.start_in_normal_mode(opts)
  local func_to_call

  if vim.api.nvim_get_mode().mode == 'n' then
    func_to_call = opts.normal or opts.generic
  else
    func_to_call = opts.other or opts.generic
  end

  if func_to_call then
    func_to_call()
  end

  if vim.api.nvim_get_mode().mode ~= 'n' then
    -- feed the keys directly cos vim.cmd.normal() is buggy
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false) -- gotta do this janky way cos `start_insert` in plugin bugs out
  end
end

---@class WordUnderCursor
---@field selectedText string selected text under cursor
---@field cursorPos? {startPos: integer[], endPos: integer[]} start and end positions of the selected text if in visual mmode

--- function to get the word under cursor or selected text in visual mode
---@return WordUnderCursor cursorWord a table containing the selected text and cursor position
function M.get_word_under_cursor()
  if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' then
    -- Visual mode: yank selection to 'v' register
    vim.cmd('normal! "vy')
    local selectedText = vim.fn.getreg('v')
    local cursorPos = {
      startPos = vim.fn.getpos("'<"),
      endPos = vim.fn.getpos("'>"),
    }
    return { selectedText = selectedText, cursorPos = cursorPos }
  else
    -- Normal mode: get word under cursor
    local selectedText = vim.fn.expand('<cword>')
    return { selectedText = selectedText }
  end
end

function M.copy_to_clipboard(text)
  -- Use the system clipboard register
  vim.fn.setreg('+', text)
  vim.notify('Copied to clipboard: ' .. text, vim.log.levels.INFO, {
    title = 'custom-keymap',
  })
end

function M.filter_out(tbl, property)
  local result = {}
  for key, value in pairs(tbl) do
    if key ~= property then
      result[key] = value
    end
  end
  return result
end

return M
