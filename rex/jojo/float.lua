---@class jojo.float
local M = {}

---@class jojo.float.opts
---@field command? string[] program and its arguments, e.g. { 'lazygit' }; omit for an interactive shell
---@field cwd? string working directory, defaults to the anchor block's cwd
---@field block_id? string block whose cwd to inherit, defaults to the current block
---@field bounds? number[] [x, y, w, h] fractions of the window, defaults to centered 80%

--- Open a floating pane. With a command it closes when the command exits; without one it runs
--- an interactive shell that closes when the shell exits.
---@param opts? jojo.float.opts
function M.create(opts)
  opts = opts or {}
  return rex.session.new_layer({
    bounds = opts.bounds or { 0.1, 0.1, 0.8, 0.8 },
    focus = true,
    layout = rex.layout.block({
      flavor = 'com.superlogical.terminal.shell',
      options = { command = opts.command, cwd = opts.cwd or JoJo.utils.get_cwd(opts.block_id) },
    }),
  })
end

return M
