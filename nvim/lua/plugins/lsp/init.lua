return {
  require('plugins.lsp.lsp-config'),
  -- require('plugins.lsp.nvim_cmp'),
  require('plugins.lsp.blink'),
  require('plugins.lsp.conform'),
  require('plugins.lsp.lazydev'),
  require('plugins.lsp.kdl'),
  require('plugins.lsp.ts-comments'),
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
