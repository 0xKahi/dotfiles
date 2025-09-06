return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      javascript = { 'biome', 'prettier' },
      typescript = { 'biome', 'prettier' },
      javascriptreact = { 'biome', 'prettier', stop_after_first = true },
      typescriptreact = { 'biome', 'prettier', stop_after_first = true },
      css = { 'biome', 'prettier', stop_after_first = true },
      -- html = { 'prettier' },
      json = { 'biome', 'prettier', stop_after_first = true },
      -- yaml = { 'prettier' },
      -- markdown = { 'prettier' },
      lua = { 'stylua' },
    },

    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,

    default_format_opts = {
      lsp_format = "fallback",
    },

    formatters = {
      prettier = {
        condition = function(ctx)
          return vim.fs.find({
            '.prettierrc',
            '.prettierrc.json',
            '.prettierrc.yml',
            '.prettierrc.yaml',
            '.prettierrc.json5',
            '.prettierrc.js',
            '.prettierrc.cjs',
            'prettier.config.js',
            'prettier.config.cjs',
          }, { path = ctx.filename, upward = true })[1]
        end,
      },
      biome = {
        condition = function(ctx)
          return vim.fs.find({ 'biome.json', 'biome.jsonc' }, { path = ctx.filename, upward = true })[1]
        end,
      },
    },
  },
}
