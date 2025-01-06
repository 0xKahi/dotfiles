-- here just in case blink breaks
return {
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
}
