return {
  -- dir = '~/Desktop/code/vim_plugins/lightswitch.nvim',
  '0xKahi/lightswitch.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  keys = { { '<leader>ls', ':LightSwitchShow<CR>', desc = '[L]ight [S]witch', noremap = true, silent = true } },
  config = function()
    require('lightswitch').setup({
      toggles = {
        {
          name = 'Formatting',
          enable_cmd = 'FormatToggle!',
          disable_cmd = 'FormatToggle!',
          state = false,
        },
        {
          name = 'Twilight',
          enable_cmd = 'TwilightEnable',
          disable_cmd = 'TwilightDisable',
          state = false, -- Initially disabled
        },
        {
          name = 'Copilot',
          enable_cmd = 'Copilot enable',
          disable_cmd = 'Copilot disable',
          state = true, -- Initially enabled
        },
        {
          name = 'LSP',
          enable_cmd = ':LspStart<CR>',
          disable_cmd = ':LspStop<CR>',
          state = true,
        },
      },
    })
  end,
}
