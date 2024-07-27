return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
    event = { 'BufEnter' },
    config = function()
      local configs = require('nvim-treesitter.configs')

      configs.setup({
        -- A list of parser names, or "all" (the listed parsers MUST always be installed)
        ensure_installed = {
          'javascript',
          'typescript',
          'tsx',
          'c',
          'lua',
          'vim',
          'vimdoc',
          'query',
          'markdown',
          'markdown_inline',
          'bash',
          'regex',
          'python',
          'sql',
          'graphql',
        },

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

        autopairs = {
          enable = true,
        },
      })
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    --dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',
    config = function()
      require('nvim-ts-autotag').setup({})
    end,
  },
}
