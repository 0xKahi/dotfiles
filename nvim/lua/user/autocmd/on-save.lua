local util = require('utils.lsp-fmt')

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(args)
    if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat then
      return
    end
    util.lsp_format(args.buf)
  end,
})
