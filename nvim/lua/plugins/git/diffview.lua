return {
  {
    'sindrets/diffview.nvim',
    dependencies = {
      -- 'nvim-tree/nvim-web-devicons',
      'echasnovski/mini.icons',
    },
    cmd = {
      'DiffviewOpen',
    },
    keys = {
      { '<leader>dv', '<cmd>DiffviewOpen<cr>', desc = '[D]iff [V]iew' },
      { '<leader>dq', '<cmd>DiffviewClose<cr>', desc = '[D]iff view [Q]uit' },
    },
    opts = {
      use_icons = true,
      enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
      view = {
        -- Configure the layout and behavior of different types of views.
        -- Available layouts:
        --  'diff1_plain'
        --    |'diff2_horizontal'
        --    |'diff2_vertical'
        --    |'diff3_horizontal'
        --    |'diff3_vertical'
        --    |'diff3_mixed'
        --    |'diff4_mixed'
        -- For more info, see |diffview-config-view.x.layout|.
        default = {
          -- Config for changed files, and staged files in diff views.
          layout = 'diff2_horizontal',
          disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
          winbar_info = true, -- See |diffview-config-view.x.winbar_info|
        },
        merge_tool = {
          -- Config for conflicted files in diff views during a merge or rebase.
          layout = 'diff3_horizontal',
          disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
          winbar_info = true, -- See |diffview-config-view.x.winbar_info|
        },
        file_history = {
          -- Config for changed files in file history views.
          layout = 'diff2_horizontal',
          disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
          winbar_info = false, -- See |diffview-config-view.x.winbar_info|
        },
      },
      file_panel = {
        listing_style = 'tree', -- One of 'list' or 'tree'
        tree_options = { -- Only applies when listing_style is 'tree'
          flatten_dirs = true, -- Flatten dirs that only contain one single dir
          folder_statuses = 'only_folded', -- One of 'never', 'only_folded' or 'always'.
        },
        win_config = { -- See |diffview-config-win_config|
          type = 'split',
          position = 'left',
          width = 30,
          win_opts = {},
        },
      },
    },
  },
}
