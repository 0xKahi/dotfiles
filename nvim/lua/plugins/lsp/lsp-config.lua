return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    opts = {
      ui = {
        border = 'rounded',
      },
    },
    config = true,
  },
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'nvim-telescope/telescope.nvim' },
      {
        'j-hui/fidget.nvim',
        tag = 'v1.4.5',
        opts = {
          progress = {
            display = {
              done_icon = ' ',
            },
          },
          notification = {
            window = {
              winblend = 0, -- Background color opacity in the notification window
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- This is where all the LSP shenanigans will live
      local lsp = require('lsp-zero')
      lsp.extend_lspconfig()
      --- if you want to know more about lsp-zero and mason.nvim
      --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
      lsp.on_attach(function(client, bufnr)
        vim.keymap.set('n', 'gd', function()
          Snacks.picker.lsp_definitions({
            layout = 'basic',
          })
        end, { buffer = bufnr, desc = '[G]o to [D]efinition' })

        vim.keymap.set('n', 'gp', function()
          Snacks.picker.lsp_definitions({ auto_confirm = false, layout = 'bottom' })
        end, { buffer = bufnr, desc = '[G]o to [P]review definition' })

        vim.keymap.set('n', 'gr', function()
          Snacks.picker.lsp_references({
            layout = 'basic',
          })
        end, { buffer = bufnr, desc = '[G]o to [R]eferences' })

        -- Setup Telescope for LSP @keymaps
        -- local telescope = require('telescope.builtin')
        -- vim.keymap.set('n', 'gd', telescope.lsp_definitions, { buffer = bufnr, desc = '[G]o to [D]efinition' })
        -- vim.keymap.set('n', 'gp', function()
        --   telescope.lsp_definitions(require('telescope.themes').get_ivy({ jump_type = 'never' }))
        -- end, { buffer = bufnr, desc = '[G]o to [P]review definition' })
        -- vim.keymap.set('n', 'gr', function()
        --   telescope.lsp_references({ fname_width = 60 })
        -- end, { buffer = bufnr, desc = '[G]o to [R]eferences' })

        --vim.keymap.set('n', 'go', telescope.lsp_type_definitions, { buffer = bufnr, desc = 'Go to type definition' })
        -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = '[G]o to [D]eclaration' })
        -- vim.keymap.set('n', 'gi', telescope.lsp_implementations, { buffer = bufnr, desc = '[G]o to [I]mplementation' })

        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp.default_keymaps({ buffer = bufnr })
      end)

      local nvim_lsp = require('lspconfig')
      require('mason-lspconfig').setup({
        ensure_installed = { 'ts_ls', 'eslint', 'lua_ls', 'rust_analyzer', 'marksman', 'autotools_ls', 'pyright' },
        handlers = {
          lsp.default_setup,
          lua_ls = function()
            local lua_opts = lsp.nvim_lua_ls()
            nvim_lsp.lua_ls.setup(lua_opts)
          end,
          denols = function()
            nvim_lsp.denols.setup({
              root_dir = nvim_lsp.util.root_pattern('deno.json', 'deno.jsonc'),
            })
          end,
          ts_ls = function()
            nvim_lsp.ts_ls.setup({
              root_dir = nvim_lsp.util.root_pattern('package.json'),
              single_file_support = false,
            })
          end,
        },
      })
    end,
  },
}
