return {
  {
    'rest-nvim/rest.nvim',
    main = 'rest-nvim',
    ft = 'http',
    cmd = 'Rest',
    keys = {
      { '<Leader>rr', '<cmd>Rest run<CR>', desc = '[R]est [R]un (Execute HTTP request)' },
    },
    opts = { skip_ssl_verification = true },
  },
}
