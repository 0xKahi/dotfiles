return {
  'echasnovski/mini.files',
  version = false,
  keys = {
    {
      '<leader>ee',
      function()
        require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = '[E]xplore [E]xplorer',
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
      go_in = 'L',
      go_in_plus = '',
      go_out = 'H',
      go_out_plus = '',
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
      width_focus = 45,
      -- Width of non-focused window
      width_nofocus = 30,
      -- Width of preview window
      width_preview = 30,
    },
  },
  config = function(_, opts)
    require('mini.files').setup(opts)

    local go_in_and_close = function()
      MiniFiles.go_in()
      MiniFiles.close()
    end

    local map_split = function(direction)
      -- Make new window and set it as target
      local cur_target = MiniFiles.get_explorer_state().target_window
      local new_target = vim.api.nvim_win_call(cur_target, function()
        vim.cmd(direction .. ' split')
        return vim.api.nvim_get_current_win()
      end)

      MiniFiles.set_target_window(new_target)
      go_in_and_close()
    end

    local yank_path = function()
      local path = (MiniFiles.get_fs_entry() or {}).path
      if path == nil then
        return vim.notify('Cursor is not on valid entry')
      end
      vim.fn.setreg(vim.v.register, path)
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id

        vim.keymap.set('n', '<C-s>', function()
          map_split('belowright horizontal')
        end, { buffer = buf_id, desc = 'MiniFiles horizontal Split' })

        vim.keymap.set('n', '<C-v>', function()
          map_split('belowright vertical')
        end, { buffer = buf_id, desc = 'MiniFiles vertical Split' })

        vim.keymap.set('n', '<leader>cp', yank_path, { buffer = buf_id, desc = '[C]opy [P]ath' })

        vim.keymap.set('n', '<enter>', go_in_and_close, { buffer = buf_id, desc = 'MiniFiles Enter' })
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesWindowUpdate',
      callback = function(args)
        local win_id = args.data.win_id
        -- Set relative line numbers
        vim.wo[win_id].number = true
        vim.wo[win_id].relativenumber = true
      end,
    })
  end,
}
