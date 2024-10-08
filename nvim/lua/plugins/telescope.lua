-- plugins/telescope.lua:
return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable('make') == 1
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup({
        defaults = {
          layout_config = {
            horizontal = {
              preview_width = 0.5,
              -- preview_width = 0.65,
              size = {
                width = '95%',
                height = '95%',
              },
            },
          },
          mappings = {
            -- @keymaps
            n = {
              ['q'] = actions.close,
              ['<leader>aq'] = actions.add_selected_to_qflist, -- [A]dd selected to [Q]uickfix list
              ['<leader>rq'] = actions.send_selected_to_qflist, -- [R]eplace [Q]uickfix list with selected
              ['<leader>dd'] = actions.delete_buffer,
              ['<Tab>'] = actions.toggle_selection,
              ['<C-s>'] = actions.select_horizontal,
            },
          },
          path_display = function(opts, path)
            local tail = require('telescope.utils').path_tail(path)
            return string.format('%s (%s)', tail, path)
          end,
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
        },
      })
      -- require('telescope').load_extension('neoclip')
      require('telescope').load_extension('noice')
      require('telescope').load_extension('fzf')
    end,
  },
}
