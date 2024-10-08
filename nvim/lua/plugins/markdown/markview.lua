return {
  {
    'OXY2DEV/markview.nvim',
    lazy = false, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local presets = require('markview.presets')
      require('markview').setup({
        -- -- Buffer types to ignore
        -- buf_ignore = { 'nofile' },
        -- -- Delay, in miliseconds
        -- -- to wait before a redraw occurs(after an event is triggered)
        -- debounce = 50,
        -- -- Filetypes where the plugin is enabled
        filetypes = { 'markdown', 'quarto', 'rmd' },
        -- -- Highlight groups to use
        -- -- "dynamic" | "light" | "dark"
        -- highlight_groups = 'dynamic',
        -- -- Modes where hybrid mode is enabled
        hybrid_modes = { 'n' },
        -- -- Tree-sitter query injections
        -- injections = {},
        -- -- Initial plugin state,
        -- -- true = show preview
        -- -- falss = don't show preview
        -- initial_state = true,
        -- -- Max file size that is rendered entirely
        -- max_file_length = 1000,
        -- -- Modes where preview is shown
        -- modes = { 'n', 'no', 'c' },
        -- -- Lines from the cursor to draw when the
        -- -- file is too big
        -- render_distance = 100,
        -- -- Window configuration for split view
        -- split_conf = {},

        -- Rendering related configuration
        headings = { enable = false },
        checkboxes = { enable = false },
        inline_codes = { enable = false },
        links = { enable = false },
        list_items = { enable = false },
        block_quotes = {
          enable = true,
          default = {
            border = '▋',
            hl = 'MarkviewBlockQuoteDefault',
            title = true,
          },
          --- Configuration for custom block quotes
          callouts = {
            {
              --- String between "[!" & "]"
              match_string = 'gem',
              hl = 'MarkviewBlockQuoteGem',
              --- Highlight group for the preview text.
              ---@type string?
              preview_hl = nil,
              --- When true, adds the ability to add a title
              --- to the block quote.
              ---@type boolean
              title = true,
              --- Icon to show before the title.
              ---@type string?
              icon = ' ',
              --- Text to show in the preview.
              ---@type string
              preview = ' Gem',
              ---@type string | string
              border = '▋',
              ---@type (string | string[])?
              border_hl = nil,
            },
            {
              match_string = 'candy',
              hl = 'MarkviewBlockQuoteCandy',
              preview_hl = nil,
              title = true,
              icon = '󱥳 ',
              preview = '󱥳 Candy',
              border = '▋',
              border_hl = nil,
            },
            {
              match_string = 'tip',
              hl = 'MarkviewBlockQuoteTip',
              preview_hl = nil,
              title = true,
              icon = '󰌶 ',
              preview = '󰌶 Tip',
              border = '▋',
              border_hl = nil,
            },
            {
              match_string = 'note',
              hl = 'MarkviewBlockQuoteNote',
              preview_hl = nil,
              title = true,
              icon = ' ',
              preview = ' Note',
              border = '▋',
              border_hl = nil,
            },
            {
              match_string = 'dev',
              hl = 'MarkviewBlockQuoteDev',
              preview_hl = nil,
              title = true,
              preview = '󱚤 Dev',
              icon = '󱚤 ',
              border = '▋',
              border_hl = nil,
            },
          },
        },
        callbacks = {},
        code_blocks = {},
        escaped = {},
        footnotes = {},
        horizontal_rules = {},
        html = {},
        latex = {},
        tables = {},
      })
    end,
  },
}
