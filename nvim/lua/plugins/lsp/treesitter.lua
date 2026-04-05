return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    commit = vim.fn.has('nvim-0.12') == 0 and '7caec274fd19c12b55902a5b795100d21531391f' or nil,
    version = false, -- last release is way too old and doesn't work on Windows
    -- build = function()
    --   require('nvim-treesitter.install').update({ with_sync = true })
    -- end,
    build = ':TSUpdate',
    lazy = false,
    opts = {
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

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = false,

      highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
      autopairs = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      local TS = require('nvim-treesitter')

      TS.setup(opts)

      JoJo.treesitter.installed.refresh()

      local not_installed = vim
        .iter(opts.ensure_installed)
        :filter(function(parser)
          return not JoJo.treesitter.installed.have(parser)
        end)
        :totable()

      if #not_installed > 0 then
        TS.install(not_installed)
        JoJo.treesitter.installed.refresh()
      end
    end,
  },
}
