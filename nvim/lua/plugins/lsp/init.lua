return {
  require('plugins.lsp.lsp_config'),
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
  },
}
