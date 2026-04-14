return {
  -- dir = '~/Desktop/code/vim_plugins/lightswitch.nvim',
  '0xKahi/lightswitch.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  keys = { { '<leader>ls', ':LightSwitchShow<CR>', desc = '[L]ight [S]witch', noremap = true, silent = true } },
  config = function()
    require('lightswitch').setup({
      toggles = {
        {
          name = 'Format On Save',
          enable_cmd = 'FormatToggle!',
          disable_cmd = 'FormatToggle!',
          state = true,
        },
        {
          name = 'Windows Auto Width',
          enable_cmd = 'WindowsEnableAutowidth',
          disable_cmd = 'WindowsDisableAutowidth',
          state = true,
        },
        {
          name = 'Twilight',
          enable_cmd = 'TwilightEnable',
          disable_cmd = 'TwilightDisable',
          state = false, -- Initially disabled
        },
        {
          name = 'Wrap Lines',
          enable_cmd = 'set wrap!',
          disable_cmd = 'set wrap!',
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
