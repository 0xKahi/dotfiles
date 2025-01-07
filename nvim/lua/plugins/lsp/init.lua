return {
  require('plugins.lsp.lsp_config'),
  -- require('plugins.lsp.nvim_cmp'),
  require('plugins.lsp.blink'),
  require('plugins.lsp.conform'),
  require('plugins.lsp.lazydev'),
  require('plugins.lsp.kdl'),
  require('plugins.lsp.ts_comments'),
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
    }),
  },
}
