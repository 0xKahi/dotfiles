local Tmux = {}
Tmux.__index = Tmux

function Tmux.new(opts)
  local self = setmetatable({}, Tmux)
  self.opts = opts or {}
  self.pane_id = nil
  return self
end

---Check if we're running in a `tmux` session.
function Tmux.health()
  if vim.fn.executable('tmux') ~= 1 then
    return '`tmux` executable not found in `$PATH`.', {
      "Install `tmux` and ensure it's in your `$PATH`.",
    }
  end

  if not vim.env.TMUX then
    return 'Not running in a `tmux` session.', {
      'Launch Neovim in a `tmux` session.',
    }
  end

  return true
end

---Get the `tmux` pane ID where we started `opencode`, if it still exists.
---Ideally we'd find existing panes by title or command, but `tmux` doesn't make that straightforward.
---@return string|nil pane_id
function Tmux:get_pane_id()
  local ok = self.health()
  if ok ~= true then
    error(ok, 0)
  end

  if self.pane_id then
    -- Confirm it still exists
    if vim.fn.system('tmux list-panes -t ' .. self.pane_id):match("can't find pane") then
      self.pane_id = nil
    end
  end

  return self.pane_id
end

---Create or kill the `opencode` pane.
function Tmux:toggle(cmd)
  local pane_id = self:get_pane_id()
  if pane_id then
    self:stop()
  else
    self:start(cmd)
  end
end

---Start `opencode` in pane.
function Tmux:start(cmd)
  local pane_id = self:get_pane_id()
  if not pane_id then
    -- Create new pane
    local detach_flag = self.opts.focus and '' or '-d'
    self.pane_id =
      vim.trim(vim.fn.system(string.format("tmux split-window %s -P -F '#{pane_id}' %s '%s'", detach_flag, '-h', cmd)))

    local disable_passthrough = true -- default true (disable passthrough)
    if disable_passthrough and self.pane_id and self.pane_id ~= '' then
      vim.fn.system(string.format('tmux set-option -t %s -p allow-passthrough off', self.pane_id))
    end
  end
end

---Kill the `opencode` pane.
function Tmux:stop()
  local pid = self:get_pid()

  if not pid then
    return false
  end

  if vim.fn.has('unix') == 1 then
    return os.execute('kill -TERM -' .. pid .. ' 2>/dev/null') ~= nil
  else
    return pcall(vim.uv.kill, pid, 'sigterm')
  end
end

---Capture the PID of the process running in the pane.
---@return number?
function Tmux:get_pid()
  if not self.pane_id then
    return nil
  end

  return tonumber(vim.trim(vim.fn.system('tmux display-message -p -t ' .. self.pane_id .. " '#{pane_pid}'")))
end

return Tmux
