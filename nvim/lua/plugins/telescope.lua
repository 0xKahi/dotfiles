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

      require('telescope').load_extension('noice')
      require('telescope').load_extension('fzf')

      local telescope = require('telescope.builtin')

      -- vim.keymap.set('n', '<C-p>', function()
      --   telescope.git_files({ show_untracked = true })
      -- end, { desc = 'find files in git', noremap = true })

      -- vim.keymap.set('n', '<leader>/', function()
      --   telescope.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
      --     previewer = true,
      --   }))
      -- end, { desc = '[/] Fuzzy Find in current buffer]' })
      --
      -- vim.keymap.set('n', '<leader>ff', function()
      --   telescope.find_files({ no_ignore = true, hidden = true })
      -- end, { desc = '[F]ind all [F]iles', noremap = true })
      --
      -- vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = '[F]ind [G]rep in directory', noremap = true })
      --
      -- vim.keymap.set('n', '<leader>fb', function()
      --   telescope.buffers(require('telescope.themes').get_ivy())
      -- end, { desc = '[F]ind [B]uffers', silent = false, noremap = true })

      vim.keymap.set(
        'n',
        '<leader>fw',
        telescope.grep_string,
        { desc = '[F]ind current [W]ord in directory', noremap = true }
      )

      vim.keymap.set('n', '<leader>fp', function()
        telescope.oldfiles({ only_cwd = true })
      end, { desc = '[F]ind [P]ast files', silent = false, noremap = true })

      vim.keymap.set(
        'n',
        '<leader>pp',
        telescope.resume,
        { desc = '[P]ast telescope [P]ickers', silent = false, noremap = true }
      )

      -- vim.keymap.set(
      --   'n',
      --   '<leader>fn',
      --   '<cmd>Telescope notify<CR>',
      --   { desc = '[F]ind [N]otify', silent = false, noremap = true }
      -- )
    end,
  },
}
