local M = {}

local jojo_icons = require('config.cyberpunk.icons')
local conf = require('fff.conf')
local file_picker = require('fff.file_picker')

local staged_status = {
  staged_new = true,
  staged_modified = true,
  staged_deleted = true,
  renamed = true,
}

local status_map = {
  untracked = 'untracked',
  modified = 'modified',
  deleted = 'deleted',
  renamed = 'renamed',
  staged_new = 'added',
  staged_modified = 'modified',
  staged_deleted = 'deleted',
  ignored = 'ignored',
  -- clean = "",
  -- clear = "",
  unknown = 'untracked',
}

---@class FFFSnacksState
---@field current_file_cache? string
---@field config table FFF config
M.state = { config = {} }

---@type snacks.picker.finder
---@diagnostic disable-next-line: unused-local
local function finder(opts, ctx)
  -- initialization code from require('fff.picker_ui').open
  -- on_show does not seem to be called before finder
  if not M.state.current_file_cache then
    local current_buf = vim.api.nvim_get_current_buf()
    if current_buf and vim.api.nvim_buf_is_valid(current_buf) then
      local current_file = vim.api.nvim_buf_get_name(current_buf)
      if current_file ~= '' and vim.fn.filereadable(current_file) == 1 then
        M.state.current_file_cache = current_file
      else
        M.state.current_file_cache = nil
      end
    end
  end
  if not file_picker.is_initialized() then
    if not file_picker.setup() then
      vim.notify('Failed to initialize file picker', vim.log.levels.ERROR)
      return {}
    end
  end
  local config = conf.get()
  M.state.config = vim.tbl_deep_extend('force', config or {}, opts or {})

  -- using string.gsub to remove all whitespace from search query
  --- as i like to use spaces as wild characters etc.
  --- 'ts-lsp-highlight.lua' -> search: 'ts highlight'
  local fff_result = file_picker.search_files(
    (string.gsub(ctx.filter.search, '%s', '')),
    opts.limit or M.state.config.max_results,
    M.state.config.max_threads,
    M.state.current_file_cache,
    false
  )

  ---@type snacks.picker.finder.Item[]
  local items = {}
  for _, fff_item in ipairs(fff_result) do
    ---@type snacks.picker.finder.Item
    local item = {
      text = fff_item.name,
      file = fff_item.path,
      score = fff_item.total_frecency_score,
      status = status_map[fff_item.git_status] and {
        status = status_map[fff_item.git_status],
        staged = staged_status[fff_item.git_status] or false,
        unmerged = fff_item.git_status == 'unmerged',
      },
    }
    items[#items + 1] = item
  end

  return items
end

local function on_close()
  M.state.current_file_cache = nil
end

local function format_file_git_status(item)
  local ret = {} ---@type snacks.picker.Highlight[]
  local status = item.status

  local hl = 'SnacksPickerGitStatus'
  if status.unmerged then
    hl = 'JoJoGitConflict'
  elseif status.staged then
    hl = 'JoJoGitStaged'
  else
    hl = 'JoJoGit' .. status.status:sub(1, 1):upper() .. status.status:sub(2)
  end

  local l_icon = jojo_icons.git_status_glyphs[status.status] or jojo_icons.git_status_glyphs.generic
  local r_icon = jojo_icons.git_status[status.status]
  if status.staged then
    r_icon = jojo_icons.git_status.staged
  end

  ret[#ret + 1] = { l_icon, hl }
  -- ret[#ret + 1] = { ' ', virtual = true }

  ret[#ret + 1] = {
    col = 0,
    virt_text = { { r_icon, hl }, { ' ' } },
    virt_text_pos = 'right_align',
    hl_mode = 'combine',
  }
  return ret
end

function format(item, picker)
  ---@type snacks.picker.Highlight[]
  local ret = {}

  if item.label then
    ret[#ret + 1] = { item.label, 'SnacksPickerLabel' }
    ret[#ret + 1] = { ' ', virtual = true }
  end

  if item.status then
    vim.list_extend(ret, format_file_git_status(item))
  else
    ret[#ret + 1] = { ' ', virtual = true }
  end

  vim.list_extend(ret, require('snacks.picker.format').filename(item, picker))

  if item.line then
    Snacks.picker.highlight.format(item, item.line, ret)
    table.insert(ret, { ' ' })
  end
  return ret
end

function M.fff()
  Snacks.picker({
    title = 'FFFiles',
    finder = finder,
    on_close = on_close,
    format = format,
    -- hidden = true,
    -- ignored = true,
    live = true,
    layout = 'basic',
  })
end

return M
