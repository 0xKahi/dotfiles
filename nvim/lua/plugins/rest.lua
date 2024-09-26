return {
  {
    'rest-nvim/rest.nvim',
    ft = 'http',
    cmd = 'Rest',
    keys = {
      { '<Leader>rr', '<cmd>Rest run<CR>', desc = '[R]est [R]un (Execute HTTP request)' },
    },
    config = function()
      require('rest-nvim').setup({
        custom_dynamic_variables = {},
        request = {
          skip_ssl_verification = false,
          hooks = {
            encode_url = true,
            user_agent = 'rest.nvim v' .. require('rest-nvim.api').VERSION,
            set_content_type = true,
          },
        },
        ---@class rest.Config.Response
        response = {
          hooks = {
            decode_url = true,
            format = true,
          },
        },
        clients = {
          curl = {
            statistics = {
              { id = 'time_total', winbar = 'take', title = 'Time taken' },
              { id = 'size_download', winbar = 'size', title = 'Download size' },
            },
            opts = {
              set_compressed = false,
            },
          },
        },
        ---@class rest.Config.Cookies
        cookies = {
          enable = true,
          path = vim.fs.joinpath(vim.fn.stdpath('data') --[[@as string]], 'rest-nvim.cookies'),
        },
        ---@class rest.Config.Env
        env = {
          enable = true,
          pattern = '.*%.env.*',
        },
        ---@class rest.Config.UI
        ui = {
          winbar = true,
          keybinds = {
            prev = 'H',
            next = 'L',
          },
        },
        ---@class rest.Config.Highlight
        highlight = {
          enable = true,
          timeout = 750,
        },
        _log_level = vim.log.levels.WARN,
      })
    end,
  },
}
