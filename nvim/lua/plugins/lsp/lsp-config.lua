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
      -- { 'nvim-telescope/telescope.nvim' },
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
        require('config.lsp-picker-keymap').setup_snacks_lsp_keymaps(bufnr)
        require('config.lsp-picker-keymap').setup_avante_lsp_keymaps(bufnr)
        -- require('config.lsp-picker-keymap').setup_telescope_lsp_keymaps(bufnr)

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
            -- lua_opts.capabilities = require('blink.cmp').get_lsp_capabilities()
            -- lua_opts.settings = {
            --   Lua = {
            --     workspace = {
            --       library = {
            --         '${3rd}/love2d/library',
            --       },
            --     },
            --   },
            -- }
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
        automatic_installation = false,
      })
    end,
  },
}
