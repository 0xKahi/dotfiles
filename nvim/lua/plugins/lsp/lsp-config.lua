return {
  {
    'mason-org/mason.nvim',
    lazy = false,
    opts = {
      ui = {
        border = 'rounded',
      },
    },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    lazy = true,
    dependencies = {
      'mason-org/mason.nvim',
    },
    config = function()
      require('mason-lspconfig').setup({
        automatic_enable = true,
        ensure_installed = {
          'ts_ls',
          'biome',
          'eslint',
          'lua_ls',
          'stylua',
          'rust_analyzer',
          'marksman',
          'autotools_ls',
          'pyright',
          'bashls',
          'vimls',
        },
        automatic_installation = false,
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'mason-org/mason.nvim' },
      { 'mason-org/mason-lspconfig.nvim' },
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
      -- Common setup function for all LSP servers
      local on_attach = function(client, bufnr)
        -- Load your keymaps
        require('config.lsp-picker-keymap').setup_snacks_lsp_keymaps(bufnr)
      end

      local workspace = require('config.workspace')

      local validate_start = function(bufnr, on_dir, root_markers)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local root = vim.fs.find(root_markers, {
          path = vim.fs.dirname(filename),
          upward = true,
        })[1]

        if root then
          on_dir(vim.fs.dirname(root))
        end
      end

      -- Define default config
      vim.lsp.config('*', {
        on_attach = on_attach,
      })

      -- TypeScript config
      vim.lsp.config('ts_ls', {
        root_markers = { 'package.json' },
        root_dir = function(bufnr, on_dir)
          validate_start(bufnr, on_dir, { 'package.json' })
        end,
        single_file_support = false,
      })

      -- Deno config
      vim.lsp.config('denols', {
        root_markers = { 'deno.json', 'deno.jsonc' },
        root_dir = function(bufnr, on_dir)
          validate_start(bufnr, on_dir, { 'deno.json', 'deno.jsonc' })
        end,
      })

      -- ESLint config
      workspace.lsp_config('eslint', {
        root_dir = function(bufnr, on_dir)
          validate_start(bufnr, on_dir, { 'eslint.config.js', 'eslint.config.mjs' })
        end,
      })

      -- Biome config
      workspace.lsp_config('biome', {
        root_dir = function(bufnr, on_dir)
          validate_start(bufnr, on_dir, { 'biome.json', 'biome.jsonc' })
        end,
      })

      -- Lua config
      workspace.lsp_config('lua_ls', {
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
        root_markers = {
          '.stylua.toml',
          'stylua.toml',
          '.emmyrc.json',
          '.luarc.json',
          '.luarc.jsonc',
          '.luacheckrc',
          'selene.toml',
          'selene.yml',
          '.git',
        },
      })

      vim.lsp.config('terraformls', {
        filetypes = { 'terraform-vars', 'terraform', 'tf' },
        settings = {
          terraformls = {
            experimentalFeatures = {
              prefillRequiredFields = true,
              -- validateOnSave = true,
            },
          },
        },
      })

      workspace.lsp_config('graphql', {
        filetypes = { 'graphql' },
      })

      workspace.lsp_config('tailwindcss', {
        filetypes = vim.tbl_filter(function(ft)
          return not vim.tbl_contains({ 'postcss', 'scss' }, ft)
        end, vim.lsp.config['tailwindcss'].filetypes),
      })

      workspace.lsp_config('cssls', {})

      workspace.lsp_config('cssmodules_ls', {
        filetypes = { 'javascriptreact', 'typescriptreact' },
      })

      workspace.lsp_config('css_variables', {})

      workspace.lsp_config('pylsp', {
        settings = {
          pylsp = {
            configurationSources = { 'flake8' },
            plugins = {
              flake8 = {
                enabled = true,
                indentSize = 2,
                maxLineLength = 150,
                ignore = { 'E302', 'E501', 'W293' },
              },
              pycodestyle = { enabled = false },
              pyflakes = { enabled = false },
              pylint = { enabled = false },
              mccabe = { enabled = false },
            },
          },
        },
      })

      vim.lsp.enable('sourcekit')
      workspace.lsp_config('sourcekit', {
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
          textDocument = {
            diagnostic = {
              dynamicRegistration = true,
              relatedDocumentSupport = true,
            },
          },
        },
      })

      workspace.lsp_config('marksman', {
        filetypes = { 'markdown', 'markdown.mdx' },
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local conf = { buffer = event.buf }
          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', conf)
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', conf)
          vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', conf)
        end,
      })
    end,
  },
}
