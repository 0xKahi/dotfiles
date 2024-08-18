return {
  'stevearc/oil.nvim',
  opts = {},
  keys = {
    { '<leader>oo', '<CMD>Oil --float<CR>', desc = '[O]pen [O]il', noremap = true },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup({
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
      },
      float = {
        padding = 2,
        max_width = 200,
        max_height = 40,
        preview_split = 'right',
        border = 'rounded',
        win_options = {
          wrap = true,
          winblend = 0,
          signcolumn = 'number',
        },
      },
      win_options = {
        wrap = true,
        winblend = 0,
        signcolumn = 'number',
      },
      keymaps = {
        ['<C-c>'] = false,
        ['q'] = 'actions.close',
        ['<C-p>'] = false,
        ['<S-p>'] = 'actions.preview',
        ['<Space>'] = 'actions.select',
        ['?'] = 'actions.show_help',
        ['<C-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
        ['<C-h>'] = false,
        ['<C-s>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
        ['g.'] = false,
        ['<S-h>'] = 'actions.toggle_hidden',
      },
      -- Configuration for the floating keymaps help window
      keymaps_help = {
        border = 'rounded',
      },
    })
  end,
}
