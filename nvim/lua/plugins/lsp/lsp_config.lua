return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    opts = {
      ui = {
        border = 'rounded',
      },
    },
    config = true,
  },
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'nvim-telescope/telescope.nvim' },
      {
        'j-hui/fidget.nvim',
        tag = 'v1.4.5',
        opts = {
          progress = {
            display = {
              done_icon = ' ',
            },
          },
          notification = {
            window = {
              winblend = 0, -- Background color opacity in the notification window
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- This is where all the LSP shenanigans will live
      local lsp = require('lsp-zero')
      lsp.extend_lspconfig()
      --- if you want to know more about lsp-zero and mason.nvim
      --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
      lsp.on_attach(function(client, bufnr)
        local telescope = require('telescope.builtin')

        -- Setup Telescope for LSP @keymaps
        vim.keymap.set('n', 'gd', telescope.lsp_definitions, { buffer = bufnr, desc = '[G]o to [D]efinition' })

        vim.keymap.set('n', 'gp', function()
          telescope.lsp_definitions(require('telescope.themes').get_ivy({ jump_type = 'never' }))
        end, { buffer = bufnr, desc = '[G]o to [P]review definition' })

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = '[G]o to [D]eclaration' })

        vim.keymap.set('n', 'gi', telescope.lsp_implementations, { buffer = bufnr, desc = '[G]o to [I]mplementation' })

        --vim.keymap.set('n', 'go', telescope.lsp_type_definitions, { buffer = bufnr, desc = 'Go to type definition' })
        vim.keymap.set('n', 'gr', function()
          telescope.lsp_references({ fname_width = 60 })
        end, { buffer = bufnr, desc = '[G]o to [R]eferences' })

        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp.default_keymaps({ buffer = bufnr })
      end)

      local nvim_lsp = require('lspconfig')
      require('mason-lspconfig').setup({
        ensure_installed = { 'ts_ls', 'eslint', 'lua_ls', 'rust_analyzer', 'marksman', 'autotools_ls', 'pyright' },
        handlers = {
          lsp.default_setup,
          lua_ls = function()
            local lua_opts = lsp.nvim_lua_ls()
            nvim_lsp.lua_ls.setup(lua_opts)
          end,
          denols = function()
            nvim_lsp.denols.setup({
              root_dir = nvim_lsp.util.root_pattern('deno.json', 'deno.jsonc'),
            })
          end,
          ts_ls = function()
            nvim_lsp.ts_ls.setup({
              root_dir = nvim_lsp.util.root_pattern('package.json'),
              single_file_support = false,
            })
          end,
        },
      })
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-cmdline' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'onsails/lspkind.nvim' },
    },
    config = function()
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
      })
      -- Here is where you configure the autocompletion settings.
      local lsp = require('lsp-zero')
      lsp.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_Select = { behavior = cmp.SelectBehavior.Select }

      local lspkind = require('lspkind')
      local luasnip = require('luasnip')
      cmp.setup({
        -- copied might one to remove
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        performance = {
          debounce = 0, -- default is 60ms
          throttle = 0, -- default is 30ms
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-u>'] = cmp.mapping.scroll_docs(4),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_Select),
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_Select),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = lsp.cmp_action().luasnip_supertab(),
          ['<S-Tab>'] = lsp.cmp_action().luasnip_shift_supertab(),
        }),

        sources = cmp.config.sources({
          { name = 'nvim_lsp' }, -- lsp
          { name = 'buffer', max_item_count = 5 }, -- text within current buffer
          { name = 'path' }, -- file system paths
          { name = 'luasnip', max_item_count = 3 }, -- snippets
          { name = 'lazydev', max_item_count = 3 },
        }),

        experimental = {
          ghost_text = true,
        },
        -- Enable pictogram icons for lsp/autocompletion
        formatting = {
          expandable_indicator = true,
          format = function(entry, item)
            local color_item = require('nvim-highlight-colors').format(entry, { kind = item.kind })
            item = lspkind.cmp_format({
              mode = 'symbol_text',
              maxwidth = 50,
              ellipsis_char = '...',
              symbol_map = {
                Copilot = '',
              },
            })(entry, item)

            if color_item.abbr_hl_group then
              item.kind_hl_group = color_item.abbr_hl_group
              item.kind = color_item.abbr
            end
            return item
          end,
        },
      })

      -- comand line
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },
}
