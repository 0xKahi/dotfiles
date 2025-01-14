local function create_callout(match_string, icon, hl)
  return {
    match_string = match_string,
    hl = hl,
    preview_hl = nil,
    title = true,
    icon = icon,
    preview = icon .. string.upper(string.sub(match_string, 1, 1)) .. string.sub(match_string, 2),
    border = '▋',
    border_hl = nil,
  }
end

return {
  {
    'OXY2DEV/markview.nvim',
    -- lazy = false, -- Recommended
    ft = 'markdown', -- If you decide to lazy-load anyway
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      -- 'nvim-tree/nvim-web-devicons',
      'echasnovski/mini.icons',
    },
    config = function()
      require('markview').setup({
        __inside_code_block = true,
        -- -- Buffer types to ignore
        buf_ignore = { 'nofile' },
        -- -- Delay, in miliseconds
        -- -- to wait before a redraw occurs(after an event is triggered)
        debounce = 50,
        -- -- Filetypes where the plugin is enabled filetypes = { 'markdown', 'quarto', 'rmd' },
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
        checkboxes = { enable = true },
        inline_codes = { enable = false },
        list_items = { enable = false },
        links = { enable = true },
        code_blocks = {
          enable = true,
          icons = 'devicons',
          sign = false,
        },
        block_quotes = {
          enable = true,
          default = {
            border = '▋',
            hl = 'MarkviewBlockQuoteDefault',
            title = true,
          },
          --- Configuration for custom block quotes
          callouts = {
            create_callout('gem', ' ', 'MarkviewBlockQuoteGem'),
            create_callout('candy', '󱥳 ', 'MarkviewBlockQuoteCandy'),
            create_callout('tip', '󰌶 ', 'MarkviewBlockQuoteTip'),
            create_callout('note', ' ', 'MarkviewBlockQuoteNote'),
            create_callout('dev', '󱚤 ', 'MarkviewBlockQuoteDev'),
            create_callout('warn', ' ', 'MarkviewBlockQuoteWarn'),
            create_callout('important', ' ', 'MarkviewBlockQuoteImportant'),
            create_callout('success', ' ', 'MarkviewBlockQuoteSuccess'),
            create_callout('fail', ' ', 'MarkviewBlockQuoteFail'),
            create_callout('info', '󰋽 ', 'MarkviewBlockQuoteInfo'),
          },
        },
        footnotes = {},
        horizontal_rules = {},
        html = {},
        latex = {},
        tables = {},
      })
    end,
  },
}
