local tools = require('dbee.layouts.tools')
local utils = require('dbee.utils')
local api_ui = require('dbee.api.ui')

local M = {}

function M:new()
  local o = {
    egg = nil,
    is_opened = false,
    is_sidebar_opened = false,
    windows = {},
    result_height = 15,
    drawer_width = 30,
    call_log_height = 20,
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function M:configure_window_on_switch(on_switch, winid, open_fn, is_editor)
  local action
  if on_switch == 'close' then
    action = function(_, buf, file)
      if is_editor then
        local note, _ = api_ui.editor_search_note_with_file(file)
        if note then
          -- do nothing
          return
        end
        note, _ = api_ui.editor_search_note_with_buf(buf)
        if note then
          -- do nothing
          return
        end
      end
      -- close dbee and open buffer
      self:close()
      vim.api.nvim_win_set_buf(0, buf)
    end
  else
    action = function(win, _, _)
      open_fn(win)
    end
  end

  utils.create_singleton_autocmd({ 'BufWinEnter', 'BufReadPost', 'BufNewFile' }, {
    window = winid,
    callback = function(event)
      action(winid, event.buf, event.file)
    end,
  })
end

function M:configure_window_on_quit(winid)
  utils.create_singleton_autocmd({ 'QuitPre' }, {
    window = winid,
    callback = function()
      self:close()
    end,
  })
end

function M:open_sidebar()
  if self.is_sidebar_opened then
    return
  end

  vim.cmd('to' .. self.drawer_width .. 'vsplit')
  local drawer_win = vim.api.nvim_get_current_win()
  table.insert(self.windows, drawer_win)

  vim.cmd('belowright ' .. self.call_log_height .. 'split')
  local call_log_win = vim.api.nvim_get_current_win()
  table.insert(self.windows, call_log_win)

  api_ui.drawer_show(drawer_win)
  api_ui.call_log_show(call_log_win)

  -- Set cursor to drawer
  vim.api.nvim_set_current_win(drawer_win)

  local close_sidebar = function()
    -- pcall(vim.api.nvim_win_close, sidebar_win, true)
    pcall(vim.api.nvim_win_close, drawer_win, true)
    pcall(vim.api.nvim_win_close, call_log_win, true)
    self.is_sidebar_opened = false
  end

  -- function to configure keymaps and autocmds for sidebar
  local configure_mappings = function(winid)
    local bufnr = vim.api.nvim_win_get_buf(winid)

    -- Create an autocommand to close the sidebar when any of its windows are closed
    vim.api.nvim_create_autocmd('WinClosed', {
      pattern = tostring(winid),
      callback = close_sidebar,
      once = true,
    })

    -- 'q' key mapping to close the sidebar
    vim.keymap.set('n', 'q', close_sidebar, { silent = true, buffer = bufnr })
  end

  -- configure mappings for both windows
  configure_mappings(drawer_win)
  configure_mappings(call_log_win)

  self:configure_window_on_switch(self.on_switch, drawer_win, api_ui.drawer_show)
  self:configure_window_on_switch(self.on_switch, call_log_win, api_ui.call_log_show)
  self.is_sidebar_opened = true
end

function M:is_open()
  return self.is_opened
end

function M:is_sidebar_open()
  return self.is_sidebar_opened
end

function M:open()
  -- save layout before opening ui
  self.egg = tools.save()

  self.windows = {}

  -- editor
  tools.make_only(0)
  local editor_win = vim.api.nvim_get_current_win()
  table.insert(self.windows, editor_win)
  api_ui.editor_show(editor_win)
  self:configure_window_on_switch(self.on_switch, editor_win, api_ui.editor_show, true)
  self:configure_window_on_quit(editor_win)

  -- result
  vim.cmd('bo' .. self.result_height .. 'split')
  local win = vim.api.nvim_get_current_win()
  table.insert(self.windows, win)
  api_ui.result_show(win)
  self:configure_window_on_switch(self.on_switch, win, api_ui.result_show)
  self:configure_window_on_quit(win)

  -- set cursor to editor
  vim.api.nvim_set_current_win(editor_win)

  self.is_opened = true
end

function M:close()
  -- close all windows
  for _, win in ipairs(self.windows) do
    pcall(vim.api.nvim_win_close, win, false)
  end

  -- restore layout
  tools.restore(self.egg)
  self.egg = nil
  self.is_opened = false
  self.is_sidebar_opened = false
end

return M
