return {
  'saghen/blink.cmp',

  -- use a release tag to download pre-built binaries
  version = '*',

  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = {
      preset = 'default',
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-y>'] = { 'accept' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
    },

    completion = {
      -- 'prefix' will fuzzy match on the text before the cursor
      -- 'full' will fuzzy match on the text before *and* after the cursor
      -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
      keyword = { range = 'prefix' },

      accept = { auto_brackets = { enabled = false } },

      trigger = {
        show_on_insert_on_trigger_character = true,
      },

      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },

      menu = {

        auto_show = true,

        -- nvim-cmp style menu
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind' },
          },

          treesitter = { 'lsp' }, -- still experimental
        },

        border = 'rounded',
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = {
          border = 'rounded',
        },
      },

      -- Display a preview of the selected item on the current line
      ghost_text = { enabled = true },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'normal',
    },

    signature = {
      enabled = true,
      window = {
        border = 'single',
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },

      -- cmdline = function()
      --   local type = vim.fn.getcmdtype()
      --   -- Search forward and backward
      --   if type == '/' or type == '?' then
      --     return { 'buffer' }
      --   end
      --   -- Commands
      --   if type == ':' or type == '@' then
      --     return { 'cmdline' }
      --   end
      --   return {}
      -- end,
    },
  },
  opts_extend = { 'sources.default' },
}
