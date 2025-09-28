return {
  {
    'dmtrKovalenko/fff.nvim',
    lazy = false, -- lazy loaded by design
    enabled = false,
    build = function()
      -- this will download prebuild binary or try to use existing rustup toolchain to build from source
      -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
      -- require('blink.cmp').setup() -- ensure blink is setup first
      require('fff.download').download_or_build_binary()
    end,
    dependencies = {
      -- required to load first
      -- without this fff will break blink completion
      'saghen/blink.cmp', -- Prevent symbol conflict: blink must load before fff's libfff_nvim.dylib
    },
    keys = {
      {
        '<C-p>',
        function()
          local picker = require('config.snacks.fff-picker')
          picker.fff()
          -- Snacks.picker.git_files({
          --   finder = 'git_files',
          --   show_empty = true,
          --   format = 'file',
          --   untracked = true,
          --   submodules = false,
          --   layout = 'basic',
          -- })
        end,
        { desc = 'find files in git', noremap = true },
      },
      -- {
      --   '<leader>ee',
      --   function()
      --     require('fff').find_files()
      --   end,
      --   { desc = 'find files', noremap = true },
      -- },
    },
    opts = { -- (optional)
      base_path = vim.fn.getcwd(),
      prompt = '',
      title = 'FFFiles',
      max_results = 100,
      max_threads = 4,
      lazy_sync = true, -- set to false if you want file indexing to start on open
      layout = {
        height = 0.8,
        width = 0.8,
        prompt_position = 'bottom', -- or 'top'
        preview_position = 'right', -- or 'left', 'right', 'top', 'bottom'
        preview_size = 0.5,
      },
      preview = {
        enabled = true,
        max_size = 10 * 1024 * 1024, -- Do not try to read files larger than 10MB
        chunk_size = 8192, -- Bytes per chunk for dynamic loading (8kb - fits ~100-200 lines)
        binary_file_threshold = 1024, -- amount of bytes to scan for binary content (set 0 to disable)
        imagemagick_info_format_str = '%m: %wx%h, %[colorspace], %q-bit',
        line_numbers = true,
        wrap_lines = false,
        show_file_info = true,
        filetypes = {
          svg = { wrap_lines = true },
          markdown = { wrap_lines = true },
          text = { wrap_lines = true },
        },
      },
      keymaps = {
        close = { '<Esc>', 'q' },
        select = '<CR>',
        select_split = '<C-s>',
        select_vsplit = '<C-v>',
        select_tab = '<C-t>',
        move_up = { '<Up>', '<C-p>' },
        move_down = { '<Down>', '<C-n>' },
        preview_scroll_up = '<C-u>',
        preview_scroll_down = '<C-d>',
        toggle_debug = '<F2>',
      },
      hl = {
        border = 'FloatBorder',
        normal = 'Normal',
        cursor = 'CursorLine',
        matched = 'IncSearch',
        title = 'Title',
        prompt = 'Question',
        active_file = 'Visual',
        frecency = 'Number',
        debug = 'Comment',
      },
      frecency = {
        enabled = true,
        db_path = vim.fn.stdpath('cache') .. '/fff_nvim',
      },
      debug = {
        enabled = false, -- Set to true to show scores in the UI
        show_scores = true,
      },
      logging = {
        enabled = true,
        log_file = vim.fn.stdpath('log') .. '/fff.log',
        log_level = 'info',
      },
    },
  },
}
