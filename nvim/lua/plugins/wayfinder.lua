return {
  'error311/wayfinder.nvim',
  keys = {
    {
      '<leader>wf',
      ':Wayfinder<CR>',
      desc = '[W]ay [F]inder',
      mode = 'n',
    },
  },
  opts = {
    performance = 'fast',
    scope = {
      mode = 'package',
      package_markers = {
        'package.json',
        'tsconfig.json',
        'pyproject.toml',
        'go.mod',
        'Cargo.toml',
        '.git',
      },
    },
    limits = {
      refs = { max_results = 200, timeout_ms = 1200 },
      text = { enabled = true, max_results = 100, timeout_ms = 800 },
      tests = { max_results = 50, timeout_ms = 700 },
      git = { enabled = true, max_commits = 15, timeout_ms = 400 },
    },
  },
}
