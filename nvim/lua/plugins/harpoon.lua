-- disabled to try out arrow.nvim
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
  enabled = false,
  config = function()
    -- Harpoon
    -- personal config to setup webdev icons
    local harpoon_config = require('config.harpoon')
    harpoon_config.setup()

    local harpoon = require('harpoon')
    vim.keymap.set('n', '<leader>ac', function()
      harpoon:list():add()
    end, { desc = '[A]n[C]hor current file', silent = false, noremap = true })

    vim.keymap.set('n', '<leader>ha', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = '[HA]rpoon', silent = true, noremap = true })

    harpoon:extend({
      UI_CREATE = function(cx)
        vim.keymap.set('n', '<C-v>', function()
          harpoon.ui:select_menu_item({ vsplit = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set('n', '<C-s>', function()
          harpoon.ui:select_menu_item({ split = true })
        end, { buffer = cx.bufnr })
      end,
    })
  end,
}
