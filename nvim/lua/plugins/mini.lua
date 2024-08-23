return {
  {
    'echasnovski/mini.ai',
    version = false,
    event = 'VeryLazy',
    config = function()
      require('mini.ai').setup()
    end,
  },
  {
    'echasnovski/mini.indentscope',
    version = false,
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      -- symbol = '│',
      symbol = '╎',
      options = { try_as_border = true },
      mappings = {
        -- Textobjects
        object_scope = 'ii',
        object_scope_with_border = 'ai',
        -- Motions (jump to respective border line; if not present - body line)
        goto_top = '[i',
        goto_bottom = ']i',
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'noice',
          'cmdline',
          'help',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'lazyterm',
          'terminal',
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    'echasnovski/mini.files',
    version = false,
    keys = {
      {
        '<leader>mb',
        function()
          require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = '[M]ini [B]uffer in [E]xplorer',
      },
      {
        '<leader>me',
        function()
          require('mini.files').open(vim.uv.cwd(), true)
        end,
        desc = '[M]ini [E]xplorer',
      },
    },
    opts = {
      content = {
        -- Predicate for which file system entries to show
        filter = nil,
        -- What prefix to show to the left of file system entry
        prefix = nil,
        -- In which order to show file system entries
        sort = nil,
      },

      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close = 'q',
        go_in = 'l',
        go_in_plus = 'L',
        go_out = 'h',
        go_out_plus = 'H',
        reset = '-',
        reveal_cwd = '~',
        show_help = '?',
        synchronize = '=',
        trim_left = '<',
        trim_right = '>',
      },

      -- General options
      options = {
        -- Whether to delete permanently or move into module-specific trash
        permanent_delete = false,
        -- Whether to use for editing directories
        use_as_default_explorer = false,
      },

      -- Customization of explorer windows
      windows = {
        -- Maximum number of windows to show side by side
        max_number = math.huge,
        -- Whether to show preview of file/directory under cursor
        preview = false,
        -- Width of focused window
        width_focus = 30,
        -- Width of non-focused window
        width_nofocus = 15,
        -- Width of preview window
        width_preview = 30,
      },
    },
    config = function(_, opts)
      require('mini.files').setup(opts)

      -- Your existing configuration here
      -- Set up Git integration
      require('config.mini.git_intergation').setup_autocommands()
    end,
  },
}
