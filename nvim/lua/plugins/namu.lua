return {
  {
    'bassamsdata/namu.nvim',
    keys = {
      {
        '<leader>ns',
        '<CMD>Namu symbols<CR>',
        { desc = '[N]amu [S]ymbols', silent = false, noremap = true },
        mode = { 'n' },
      },
    },
    config = function()
      require('namu').setup({
        -- Enable the modules you want
        namu_symbols = {
          enable = true,
          options = {
            display = {
              mode = 'icon', -- "icon" or "raw"
              padding = 2,
            },
          }, -- here you can configure namu
        },
        -- Optional: Enable other modules if needed
        ui_select = { enable = false }, -- vim.ui.select() wrapper
        colorscheme = {
          enable = false,
          options = {
            -- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
            persist = true, -- very efficient mechanism to Remember selected colorscheme
            write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
          },
        },
      })
      -- === Suggested Keymaps: ===
      -- vim.keymap.set('n', '<leader>ss', ':Namu symbols<cr>', {
      --   desc = 'Jump to LSP symbol',
      --   silent = true,
      -- })
    end,
  },
}
