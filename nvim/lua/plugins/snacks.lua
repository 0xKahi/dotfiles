return {
  'folke/snacks.nvim',
  lazy = false,
  keys = {
    {
      '<leader>nn',
      function()
        require('snacks').notifier.hide()
      end,
      { desc = '[N]o [N]otification', silent = false, noremap = true },
      mode = { 'n' },
    },
    {
      '<leader>gb',
      function()
        require('snacks').gitbrowse()
      end,
      { desc = '[G]it [B]rowse', silent = false, noremap = true },
      mode = { 'n', 'v' },
    },
    {
      '<leader>fb',
      function()
        Snacks.picker.buffers({
          -- I always want my buffers picker to start in normal mode
          on_show = function()
            vim.cmd.stopinsert()
          end,
          finder = 'buffers',
          format = 'buffer',
          hidden = false,
          unloaded = true,
          current = true,
          layout = 'bottom',
          sort_lastused = true,
          win = {
            input = {
              keys = {
                ['<leader>dd'] = { 'bufdelete', mode = { 'n' } },
              },
            },
          },
        })
      end,
      { desc = '[F]ind [B]uffers', silent = false, noremap = true },
    },
    {
      '<C-p>',
      function()
        Snacks.picker.git_files({
          finder = 'git_files',
          show_empty = true,
          format = 'file',
          untracked = true,
          submodules = false,
          layout = 'basic',
        })
      end,
      { desc = 'find files in git', noremap = true },
    },
    {
      '<leader>ff',
      function()
        Snacks.picker.files({
          finder = 'files',
          format = 'file',
          show_empty = true,
          hidden = true,
          ignored = true,
          follow = false,
          supports_live = true,
          layout = 'vscode',
        })
      end,
      { desc = '[F]ind all [F]iles', noremap = true },
    },
    {
      '<leader>fp',
      function()
        Snacks.picker.recent({
          finder = 'recent_files',
          format = 'file',
          layout = 'basic',
          filter = {
            cwd = true,
          },
        })
      end,
      { desc = '[F]ind [P]ast files', noremap = true },
    },
    {
      '<leader>/',
      function()
        Snacks.picker.lines({
          layout = { layout = { height = 0.3 } },
        })
      end,
      { desc = '[/] Fuzzy Find in current buffer]' },
    },
    {
      '<leader>fg',
      function()
        Snacks.picker.grep({
          finder = 'grep',
          format = 'file',
          regex = false,
          show_empty = true,
          live = true, -- live grep by default
          supports_live = true,
          layout = 'basic',
        })
      end,
      { desc = '[F]ind [G]rep in directory', noremap = true },
    },
    {
      '<leader>ts',
      function()
        Snacks.picker.lsp_symbols({
          finder = 'lsp_symbols',
          format = 'lsp_symbol',
          tree = true,
          markdown = true,
          help = true,
        })
      end,
      {
        desc = '[T]oggle [S]ymbol',
        silent = true,
        noremap = true,
      },
    },
    {
      '<leader>pp',
      function()
        Snacks.picker.resume()
      end,
      { desc = '[P]ast [P]ickers', silent = false, noremap = true },
    },
    {
      '<leader>pc',
      function()
        Snacks.picker.command_history()
      end,
      { desc = '[P]ast [C]ommands', silent = false, noremap = true },
      mode = { 'n' },
    },
    {
      '<leader>fn',
      function()
        Snacks.picker.notifications()
      end,
      { desc = '[F]ind [N]otification', silent = false, noremap = true },
      mode = { 'n' },
    },
  },

  opts = {
    dashboard = {
      width = 60,
      row = nil, -- dashboard position. nil for center
      col = nil, -- dashboard position. nil for center
      pane_gap = 4, -- empty columns between vertical panes

      preset = {
        pick = nil,
        header = require('utils.misc').random_selector(require('config.cyberpunk.ascii-art')),
      },
      sections = {
        { section = 'header' },
        { title = 'Recent Files', padding = 1 },
        { section = 'recent_files', padding = 1, limit = 9, cwd = true },
        { section = 'startup' },
      },
    },

    notifier = {
      enable = true,
      timeout = 3000, -- default timeout in ms
    },

    picker = {
      matcher = {
        fuzzy = true, -- use fuzzy matching
        smartcase = true, -- use smartcase
        ignorecase = true, -- use ignorecase
        filename_bonus = true, -- give bonus for matching file names (last part of the path)
        file_pos = true, -- support patterns like `file:line:col` and `file:line`
        sort_empty = false, -- sort results when the search string is empty

        -- the bonusses below, possibly require string concatenation and path normalization,
        -- so this can have a performance impact for large lists and increase memory usage
        frecency = true, -- frecency bonus
        cwd_bonus = false, -- give bonus for matching files in the cwd
        history_bonus = false, -- give more weight to chronological order
      },

      ui_select = true,

      formatters = {
        file = {
          filename_first = true,
          truncate = 1000000,
          icon_width = 2,
        },
      },

      win = {
        input = {
          keys = {
            -- to close the picker on ESC instead of going to normal mode,
            -- add the following keymap to your config
            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            ['q'] = { 'close', mode = { 'n' } },
            ['<C-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
            ['<C-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
            ['<leader>rq'] = { 'qflist', mode = { 'n' } },
            ['@'] = {
              function(picker)
                picker:close()
                require('config.snacks').picker_to_avante()
              end,
              mode = { 'n' },
            },
          },
        },
        list = {
          keys = {
            ['<Esc>'] = 'close',
            ['q'] = { 'close', mode = { 'n' } },
          },
        },
        preview = {
          keys = {
            ['<Esc>'] = 'close',
            ['q'] = { 'close', mode = { 'n' } },
          },
        },
      },

      layout = {
        cycle = true,
      },

      layouts = {

        bottom = {
          cycle = true,
          layout = {
            box = 'vertical',
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.3,
            border = 'top',
            position = 'bottom',
            title = ' {title} {live} {flags}',
            title_pos = 'center',
            { win = 'input', height = 1, border = 'bottom' },
            {
              box = 'horizontal',
              { win = 'list', border = 'none' },
              { win = 'preview', title = '{preview}', width = 0.5, border = 'left' },
            },
          },
        },
        basic = {
          reverse = true,
          cycle = true,
          layout = {
            box = 'horizontal',
            width = 0.8,
            min_width = 120,
            height = 0.8,
            {
              box = 'vertical',
              border = 'rounded',
              title = '{title}',
              { win = 'list', border = 'none' },
              { win = 'input', title = 'Input   {live} {flags}', title_pos = 'left', height = 1, border = 'top' },
            },
            { win = 'preview', title = '{preview}', border = 'rounded', width = 0.5 },
          },
        },
      },
    },

    scratch = {
      name = 'Scratch',
      ft = function()
        if vim.bo.buftype == '' and vim.bo.filetype ~= '' then
          return vim.bo.filetype
        end
        return 'lua'
      end,
      ---@type string|string[]?
      icon = nil, -- `icon|{icon, icon_hl}`. defaults to the filetype icon
      root = vim.fn.stdpath('data') .. '/scratch',
      autowrite = true, -- automatically write when the buffer is hidden
      -- unique key for the scratch file is based on:
      -- * name
      -- * ft
      -- * vim.v.count1 (useful for keymaps)
      -- * cwd (optional)
      -- * branch (optional)
      filekey = {
        cwd = true, -- use current working directory
        branch = true, -- use current branch name
        count = true, -- use vim.v.count1
      },
      win = { style = 'scratch' },
      win_by_ft = {
        lua = {
          keys = {
            ['source'] = {
              '<cr>',
              function(self)
                local name = 'scratch.' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ':e')
                Snacks.debug.run({ buf = self.buf, name = name })
              end,
              desc = 'Source buffer',
              mode = { 'n', 'x' },
            },
          },
        },
      },
    },
  },
}
