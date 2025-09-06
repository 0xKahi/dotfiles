return {
  require('plugins.lsp.treesitter'),
  require('plugins.lsp.lsp-config'),
  require('plugins.lsp.completion.blink'),
  require('plugins.lsp.formatters.conform'),
  require('plugins.lsp.kdl'),
  require('plugins.lsp.helpers.lazydev'),
  require('plugins.lsp.helpers.ts-comments'),
  require('plugins.lsp.helpers.ts-autotag'),
  -- some file type stuff
  {
    vim.filetype.add({
      extension = {
        ['http'] = 'http',
      },
    }),

    vim.diagnostic.config({
      virtual_text = {
        source = 'if_many',
        -- prefix = '● ',
        prefix = ' ',
      },
      update_in_insert = false,
      underline = false,
      severity_sort = true,
      float = {
        focusable = true,
        style = 'minimal',
        border = 'rounded',
        source = 'if_many',
        header = '',
        prefix = '',
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = ' ',
          [vim.diagnostic.severity.WARN] = ' ',
          [vim.diagnostic.severity.INFO] = ' ',
          [vim.diagnostic.severity.HINT] = ' ',
        },
        -- linehl = {
        --   [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
        --   [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
        --   [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
        --   [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
        -- },
        numhl = {
          [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
          [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
          [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
          [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
        },
      },
    }),
  },
}
