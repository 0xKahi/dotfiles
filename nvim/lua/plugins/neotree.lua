-- neotree
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'echasnovski/mini.icons',
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    -- 'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  },
  keys = {
    { '<leader>oe', ':Neot reveal<CR>', desc = '[O]pen [E]xplorer', noremap = true, silent = true },
    { '<leader>ds', ':Neot document_symbols<CR>', desc = '[D]ocument [S]ymbols', noremap = true, silent = true },
    { '<leader>ce', ':Neot close<CR>', desc = '[C]lose [E]xplorer', noremap = true, silent = true },
    { '<leader>og', ':Neot git_status reveal<CR>', desc = '[O]pen [G]itStatus', noremap = true, silent = true },
  },
  opts = {},
  config = function()
    require('neo-tree').setup({
      close_if_last_window = false,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
      sort_case_insensitive = false,
      sort_function = nil,
      sources = {
        'filesystem',
        'buffers',
        'git_status',
        'document_symbols',
      },

      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 1.5,
          padding = 0,
          with_markers = true,
          indent_marker = '│',
          last_indent_marker = '└',
          highlight = 'NeoTreeIndentMarker',
          with_expanders = nil,
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        modified = {
          -- symbol = '[+]',
          highlight = 'NeoTreeModified',
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = 'NeoTreeFileName',
        },
        git_status = {
          symbols = require('config.cyberpunk.icons').git_status,
        },
        icon = {
          provider = function(icon, node) -- setup a custom icon provider
            local text, hl
            local mini_icons = require('mini.icons')
            if node.type == 'file' then -- if it's a file, set the text/hl
              text, hl = mini_icons.get('file', node.name)
            elseif node.type == 'directory' then -- get directory icons
              text, hl = mini_icons.get('directory', node.name)
              -- only set the icon text if it is not expanded
              if node:is_expanded() then
                text = nil
              end
            end

            -- set the icon text/highlight only if it exists
            if text then
              icon.text = text
            end
            if hl then
              icon.highlight = hl
            end
          end,
          -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
          -- then these will never be used.
          default = '*',
          highlight = 'NeoTreeFileIcon',
        },
        file_size = {
          enabled = false,
          required_width = 64,
        },
        type = {
          enabled = true,
          required_width = 122,
        },
        last_modified = {
          enabled = true,
          required_width = 88,
        },
        created = {
          enabled = false,
          required_width = 110,
        },
        symlink_target = {
          enabled = false,
        },
      },
      source_selector = {
        winbar = true, -- toggle to show selector on winbar
        statusline = false, -- toggle to show selector on statusline
        show_scrolled_off_parent_node = false, -- this will replace the tabs with the parent path
        -- of the top visible node when scrolled down.
        sources = {
          { source = 'filesystem' },
          { source = 'git_status' },
          { source = 'buffers' },
        },
        content_layout = 'start', -- only with `tabs_layout` = "equal", "focus"
        --                start  : |/ 󰓩 bufname     \/...
        --                end    : |/     󰓩 bufname \/...
        --                center : |/   󰓩 bufname   \/...
        tabs_layout = 'equal', -- start, end, center, equal, focus
        --             start  : |/  a  \/  b  \/  c  \            |
        --             end    : |            /  a  \/  b  \/  c  \|
        --             center : |      /  a  \/  b  \/  c  \      |
        --             equal  : |/    a    \/    b    \/    c    \|
        --             active : |/  focused tab    \/  b  \/  c  \|
        truncation_character = '…', -- character to use when truncating the tab label
        tabs_min_width = nil, -- nil | int: if int padding is added based on `content_layout`
        tabs_max_width = nil, -- this will truncate text even if `text_trunc_to_fit = false`
        padding = 0, -- can be int or table
        -- padding = { left = 2, right = 0 },
        -- separator = "▕", -- can be string or table, see below
        separator = { left = '▏', right = '▕' },
        -- separator = { left = "/", right = "\\", override = nil },     -- |/  a  \/  b  \/  c  \...
        -- separator = { left = "/", right = "\\", override = "right" }, -- |/  a  \  b  \  c  \...
        -- separator = { left = "/", right = "\\", override = "left" },  -- |/  a  /  b  /  c  /...
        -- separator = { left = "/", right = "\\", override = "active" },-- |/  a  / b:active \  c  \...
        -- separator = "|",                                              -- ||  a  |  b  |  c  |...
        separator_active = nil, -- set separators around the active tab. nil falls back to `source_selector.separator`
        show_separator_on_edge = false,
        --                       true  : |/    a    \/    b    \/    c    \|
        --                       false : |     a    \/    b    \/    c     |
        highlight_tab = 'NeoTreeTabInactive',
        highlight_tab_active = 'NeoTreeTabActive',
        highlight_background = 'NeoTreeTabInactive',
        highlight_separator = 'NeoTreeTabSeparatorInactive',
        highlight_separator_active = 'NeoTreeTabSeparatorActive',
      },

      commands = {},
      window = {
        position = 'left',
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ['<C-s>'] = 'open_split',
          ['<C-v>'] = 'open_vsplit',
        },
      },
      nesting_rules = {},
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_hidden = true,
        },
        follow_current_file = {
          enabled = false,
          leave_dirs_open = false,
        },
        group_empty_dirs = false,
        hijack_netrw_behavior = 'open_default',
        use_libuv_file_watcher = false,
        window = {
          mappings = {
            -- Add your filesystem-specific mappings here
          },
        },
      },
      git_status = {
        window = {
          position = 'left',
        },
      },
      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = true,
        show_unloaded = true,
        window = {
          mappings = {
            -- Add your buffers-specific mappings here
          },
        },
      },
      event_handlers = {
        {
          event = 'neo_tree_buffer_enter',
          handler = function(arg)
            vim.cmd([[
              setlocal relativenumber
            ]])
          end,
        },
      },
    })
  end,
}
