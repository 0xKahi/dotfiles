return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    -- 'nvim-tree/nvim-web-devicons',
    'echasnovski/mini.icons',
  },
  opts = {
    options = {
      icons_enabled = true,
      theme = require('config.lualine_theme'),
      section_separators = { left = '', right = '' },
      component_separators = '|',
      globalstatus = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        'branch',
        {
          'git_base',
          fmt = function()
            local git_base = Global:get('git_base')
            if git_base == nil or git_base == 'HEAD' then
              return nil
            end
            return ' ' .. git_base
          end,
        },
        'diff',
        'diagnostics',
      },
      lualine_c = {
        -- {
        --   'buffers',
        --   mode = 2, -- 0: Shows buffer name
        -- },
      },
      lualine_x = {
        {
          require('noice').api.status.command.get,
          cond = require('noice').api.status.command.has,
          color = { fg = '#00FF9C' },
        },
        {
          'macro',
          fmt = function()
            local reg = vim.fn.reg_recording()
            if reg ~= '' then
              return 'Recording @' .. reg
            end
            return nil
          end,
          color = { fg = '#ff966c' },
          draw_empty = false,
        },
      },
      lualine_y = { 'encoding', 'filetype' },
      lualine_z = { 'progress', 'location' },
    },
    extensions = { 'fzf', 'lazy', 'mason', 'oil', 'trouble' },
  },
}
