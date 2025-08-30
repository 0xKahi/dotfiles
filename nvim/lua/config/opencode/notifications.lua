local M = {}

-- Permission notification constants
local PERMISSION_TIMER_INTERVAL = 80
local PERMISSION_SPINNER = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }

local permission_timer = nil
local spinner_index = 1

-- Helper functions
local function cleanup_permission_timer()
  if permission_timer then
    permission_timer:stop()
    permission_timer:close()
    permission_timer = nil
  end
end

local function create_permission_notification(message, level, icon)
  local opts = {
    id = 'opencode_permission',
    title = 'Opencode',
    opts = function(notif)
      notif.icon = icon
    end,
  }

  return vim.notify(message, level, opts)
end

-- Handle all permission-related events
local function handle_permission_events(event_type, data)
  -- when permissions are asked
  if event_type == 'permission.updated' then
    cleanup_permission_timer()

    local permission_info = {
      title = data.properties and data.properties.title or 'unknown',
      type = data.properties and data.properties.type or 'unknown',
    }
    local json_string =
      string.format('{\n  "title": "%s",\n  "type": "%s"\n}', permission_info.title, permission_info.type)
    local message = 'permissions required\n```json\n' .. json_string .. '\n```'

    permission_timer = vim.uv.new_timer() ---@diagnostic disable-line: undefined-field
    permission_timer:start(0, PERMISSION_TIMER_INTERVAL, function()
      vim.schedule(function()
        spinner_index = (spinner_index % #PERMISSION_SPINNER) + 1
        create_permission_notification(message, vim.log.levels.DEBUG, PERMISSION_SPINNER[spinner_index])
      end)
    end)
  end

  -- when permissions are granted
  if event_type == 'permission.replied' then
    cleanup_permission_timer()
    create_permission_notification('[SUCCESS] permissions granted', vim.log.levels.INFO, ' ')
  end

  -- when permissions are rejected
  if
    data.type == 'message.part.updated'
    and data.properties.part.type == 'tool'
    and data.properties.part.state.status == 'error'
    and data.properties.part.state.error:match('rejected permission')
  then
    cleanup_permission_timer()
    local message = 'permissions rejected\n [ERROR]' .. tostring(data.properties.part.state.error)
    create_permission_notification(message, vim.log.levels.ERROR, ' ')
  end
end

-- Main event handler

-- Setup function to initialize autocmd
function M.setup()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'OpencodeEvent',
    callback = function(args)
      local event_type = args.data.type
      handle_permission_events(event_type, args.data)
    end,
  })
end

return M
