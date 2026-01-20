return {
  {
    'nvim-treesitter/nvim-treesitter',
    -- build = function()
    --   require('nvim-treesitter.install').update({ with_sync = true })
    -- end,
    build = ':TSUpdate',
    event = { 'BufEnter' },
    config = function()
      local configs = require('nvim-treesitter.configs')

      configs.setup({
        -- A list of parser names, or "all" (the listed parsers MUST always be installed)
        ensure_installed = {
          'javascript',
          'typescript',
          'tsx',
          'html',
          'http',
          'jq',
          'c',
          'lua',
          'vim',
          'vimdoc',
          'query',
          'markdown',
          'markdown_inline',
          'latex',
          'typst',
          'bash',
          'regex',
          'python',
          'sql',
          'graphql',
          'json',
          'toml',
          'yaml',
          'gitignore',
          'dockerfile',
          'terraform',
          'hcl',
          'rust',
          'swift',
        },

        ignore_install = {},

        auto_install = false,

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        --auto_install = true,

        highlight = {
          enable = true,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        autopairs = { enable = true },
      })
    end,
  },
}
