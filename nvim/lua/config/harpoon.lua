-- Additional Config to add icons to Harpoon UI
local M = {}

local harpoon = require('harpoon')
local devicons = require('nvim-web-devicons')

local function get_icon(filename)
  local file_extension = vim.fn.fnamemodify(filename, ':e')
  local icon, icon_color = devicons.get_icon(filename, file_extension, { default = true })
  return icon, icon_color
end

local function get_highlight_color(hl_group)
  local hl = vim.api.nvim_get_hl(0, { name = hl_group, link = false }) -- gets the highlight attributes for a given highlight group
  return hl.fg and string.format('#%06x', hl.fg) or 'NONE' -- if highlight attr exist return as a 6-digit hex color, else return NONE
end

local function update_icons(bufnr, list)
  local ns_id = vim.api.nvim_create_namespace('harpoon_icons') -- create unique namespace for icons
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1) -- clear any existing icons in buffer (icons kept duplicating?)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for i, line in ipairs(lines) do
    -- Get the filename from full path && icon
    local filename = vim.fn.fnamemodify(line, ':t')
    local icon, icon_color_name = get_icon(filename)

    -- Create a safe highlight group name
    local hl_group = 'HarpoonIcon' .. i
    local color = get_highlight_color(icon_color_name)
    vim.api.nvim_set_hl(0, hl_group, { fg = color, bg = 'NONE' })

    -- Add icon as virtual text to the left of the text
    vim.api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, 0, {
      virt_text = { { icon .. ' ', hl_group } },
      virt_text_pos = 'inline',
    })
  end
end

function M.setup()
  harpoon:setup({
    settings = {
      save_on_toggle = false,
      sync_on_ui_close = true,
    },
  })

  local original_toggle = harpoon.ui.toggle_quick_menu

  harpoon.ui.toggle_quick_menu = function(self, list, opts)
    original_toggle(self, list, opts)

    -- set relative line numbers
    if self.win_id and vim.api.nvim_win_is_valid(self.win_id) then
      vim.api.nvim_set_option_value('number', true, { win = self.win_id })
      vim.api.nvim_set_option_value('relativenumber', true, { win = self.win_id })
    end

    if self.bufnr and vim.api.nvim_buf_is_valid(self.bufnr) then
      update_icons(self.bufnr, list)

      -- Set buffer options to allow editing
      vim.api.nvim_set_option_value('modifiable', true, { buf = self.bufnr })

      -- Set up autocmd to update icons when buffer is modified
      vim.api.nvim_create_autocmd('TextChanged', {
        buffer = self.bufnr,
        callback = function()
          if vim.api.nvim_buf_is_valid(self.bufnr) then
            update_icons(self.bufnr, list)
          end
        end,
      })
    end
  end
end

-- basic telescope configuration
function M.toggle_telescope(harpoon_files)
  local conf = require('telescope.config').values
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Harpoon',
      finder = require('telescope.finders').new_table({
        results = file_paths,
      }),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    })
    :find()
end

return M
