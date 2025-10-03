vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(args)
    if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat then
      return
    end
    vim.lsp.buf.format({ async = false })
  end,
})
