return {
  {
    'olimorris/codecompanion.nvim', -- The KING of AI programming
    keymaps = {
      {
        '<leader>oa',
        '<cmd>CodeCompanionChat Toggle<CR>',
        { mode = { 'n' }, desc = '[O]pen [A]i' },
      },
      {
        '<leader>aa',
        '<cmd>CodeCompanionChat Add<CR>',
        mode = { 'n', 'v' },
        desc = '[A]i [A]sk',
      },
    },
    dependencies = {
      'j-hui/fidget.nvim', -- Display status
      -- "ravitemer/codecompanion-history.nvim", -- Save and load conversation history
      {
        'ravitemer/mcphub.nvim', -- Manage MCP servers
        cmd = 'MCPHub',
        build = 'npm install -g mcp-hub@latest',
        config = true,
      },
      {
        'HakonHarnes/img-clip.nvim', -- Share images with the chat buffer
        event = 'VeryLazy',
        cmd = 'PasteImage',
        opts = {
          filetypes = {
            codecompanion = {
              prompt_for_file_name = false,
              template = '[Image]($FILE_PATH)',
              use_absolute_path = true,
            },
          },
        },
      },
    },
    opts = {
      extensions = {
        -- history = {
        --   enabled = true,
        --   opts = {
        --     keymap = "gh",
        --     save_chat_keymap = "sc",
        --     auto_save = false,
        --     auto_generate_title = true,
        --     continue_last_chat = false,
        --     delete_on_clearing_chat = false,
        --     picker = "snacks",
        --     enable_logging = false,
        --     dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        --   },
        -- },
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
        vectorcode = {
          opts = {
            add_tool = true,
          },
        },
      },
      adapters = {
        copilot = function()
          return require('codecompanion.adapters').extend('copilot', {
            schema = {
              model = {
                default = 'gemini-2.5-pro',
              },
            },
          })
        end,
        gemini = function()
          return require('codecompanion.adapters').extend('gemini', {})
        end,
        tavily = function()
          return require('codecompanion.adapters').extend('tavily', {})
        end,
      },
      strategies = {
        chat = {
          adapter = 'copilot',
          roles = {
            user = 'kahi',
          },
          keymaps = {
            send = {
              modes = {
                i = { '<C-s>' },
                n = { '<CR>' },
              },
            },
          },
          tools = {
            opts = {
              auto_submit_success = false,
              auto_submit_errors = false,
            },
          },
        },
        inline = { adapter = 'copilot' },
      },
      display = {
        action_palette = {
          provider = 'default',
        },
        chat = {
          -- show_references = true,
          -- show_header_separator = false,
          -- show_settings = false,
        },
      },
      opts = {
        log_level = 'DEBUG',
      },
    },
  },
}
