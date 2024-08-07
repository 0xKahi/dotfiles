return {
  'kndndrj/nvim-dbee',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Dbee',
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require('dbee').install('go')
  end,
  config = function()
    local dbee = require('dbee')
    local default = require('dbee.config').default
    local dbee_sources = require('dbee.sources')
    local layout_config = require('config.dbee.layout')
    local source_path = require('utils.secrets').get('dbee_source_paths')
    local scratchpad_path = require('utils.secrets').get('dbee_scratchpad_path')

    local sources = {}
    if source_path and type(source_path) == 'table' and #source_path > 0 then
      for _, path in ipairs(source_path) do
        if type(path) == 'string' and path ~= '' then
          table.insert(sources, dbee_sources.FileSource:new(vim.fn.expand(path)))
        end
      end
    end

    local slayout = layout_config:new()
    -- Append default sources
    vim.list_extend(sources, default.sources)

    -- @keymaps
    vim.keymap.set('n', '<leader>od', function()
      if not dbee.is_open() then
        dbee.open()
      end
      slayout:open_sidebar()
    end, { noremap = true, desc = '[O]open [D]bee' })

    -- setup function
    require('dbee').setup({
      sources = sources,
      drawer = {
        disable_help = true,
        window_options = {
          number = true,
          relativenumber = true,
        },
        mappings = {
          -- manually refresh drawer
          { key = 'r', mode = 'n', action = 'refresh' },
          -- action_1 opens a note or executes a helper
          { key = '<CR>', mode = 'n', action = 'action_1' },
          -- action_2 renames a note or sets the connection as active manually
          { key = 'cw', mode = 'n', action = 'action_2' },
          -- action_3 deletes a note or connection (removes connection from the file if you configured it like so)
          { key = 'dd', mode = 'n', action = 'action_3' },
          { key = '<Space>', mode = 'n', action = 'toggle' },
          -- mappings for menu popups:
          { key = '<CR>', mode = 'n', action = 'menu_confirm' },
          { key = 'y', mode = 'n', action = 'menu_yank' },
          { key = '<Esc>', mode = 'n', action = 'menu_close' },
          { key = 'q', mode = 'n', action = 'menu_close' },
        },
      },

      window_layout = slayout,
    }) -- setup dbee
  end,
}
