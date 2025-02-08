local ascii = require('config.cyberpunk.ascii-art')
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
      '<leader>fn',
      function()
        require('snacks').notifier.show_history()
      end,
      { desc = '[F]ind [N]otification', silent = false, noremap = true },
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
      '<leader>/',
      function()
        Snacks.picker.lines({
          layout = { preset = 'bottom', layout = {
            title_pos = 'left',
          } },
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
  },

  opts = {
    dashboard = {
      width = 60,
      row = nil, -- dashboard position. nil for center
      col = nil, -- dashboard position. nil for center
      pane_gap = 4, -- empty columns between vertical panes

      preset = {
        pick = nil,
        header = require('utils.misc').random_selector(ascii),
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
        frecency = true,
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
          layout = {
            box = 'horizontal',
            width = 0.8,
            min_width = 120,
            height = 0.8,
            {
              box = 'vertical',
              border = 'rounded',
              title = '{title} {live} {flags}',
              { win = 'list', border = 'none' },
              { win = 'input', height = 1, border = 'top' },
            },
            { win = 'preview', title = '{preview}', border = 'rounded', width = 0.5 },
          },
        },
      },
    },
  },
}
