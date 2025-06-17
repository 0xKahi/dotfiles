return {

  {
    'yetone/avante.nvim',
    -- event = 'VeryLazy',
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    keys = {
      {
        '<leader>oa',
        function()
          require('avante').open_sidebar()
        end,
        { mode = { 'n' }, desc = '[O]pen [A]vante' },
      },
      {
        '<leader>ca',
        function()
          require('avante').close_sidebar()
        end,
        { mode = { 'n' }, desc = '[C]lose [A]vante' },
      },
      {
        '<leader>aa',
        function()
          require('utils.misc').start_in_normal_mode({
            normal = function()
              require('avante.api').ask({ ask = true, without_selection = true })
            end,
            other = function()
              require('avante.api').ask()
            end,
          })
        end,
        mode = { 'n', 'v' },
        desc = '[A]vante [A]sk',
      },
      {
        '<leader>ae',
        function()
          require('avante.api').edit()
          vim.cmd.normal('<Esc>') -- gotta do this janky way cos `start_insert` bugs out
        end,
        mode = { 'v', 'n' },
        desc = '[A]vante [E]dit',
      },
      {
        '<leader>ar',
        function()
          require('avante.api').refresh()
        end,
        mode = { 'v', 'n' },
        desc = '[A]vante [R]efresh',
      },
    },
    opts = {
      -- add any opts here
      -- for example
      provider = 'gemini-flash', -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
      mode = 'agentic',

      -- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
      -- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
      -- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
      auto_suggestions_provider = nil,
      cursor_applying_provider = nil, -- The provider used in the applying phase of Cursor Planning Mode, defaults to nil, when nil uses Config.provider as the provider for the applying phase
      providers = {
        claude = {
          endpoint = 'https://api.anthropic.com',
          model = 'claude-3-7-sonnet-latest',
          extra_request_body = {
            temperature = 0,
            max_tokens = 10000,
          },
        },
        openai = {
          endpoint = 'https://api.openai.com/v1',
          model = 'gpt-4.1',
          extra_request_body = {
            temperature = 0,
            max_tokens = 8192,
            max_completion_tokens = 10000, -- Increase this to include reasoning tokens (for reasoning models)
          },
          -- reasoning_effort = 'medium', -- low|medium|high, only used for reason
        },
        gemini = {
          endpoint = 'https://generativelanguage.googleapis.com/v1beta/models',
          model = 'gemini-2.5-pro-preview-06-05',
          extra_request_body = {
            temperature = 0,
            max_tokens = 8192,
          },
          -- reasoning_effort = 'medium', -- low|medium|high, only used for reason
        },
        ['claude-big'] = {
          __inherited_from = 'claude',
          endpoint = 'https://api.anthropic.com',
          model = 'claude-sonnet-4-20250514',
          extra_request_body = {
            max_tokens = 8192,
          },
        },
        ['claude-small'] = {
          __inherited_from = 'claude',
          endpoint = 'https://api.anthropic.com',
          model = 'claude-3-5-haiku-latest',
          extra_request_body = {
            max_tokens = 4096,
          },
        },
        ['openai-big'] = {
          __inherited_from = 'openai',
          model = 'gpt-4.1',
          extra_request_body = {
            max_tokens = 8192,
          },
        },
        ['openai-small'] = {
          __inherited_from = 'openai',
          model = 'gpt-4.1-mini',

          extra_request_body = {
            max_tokens = 4096,
          },
        },
        ['gemini-pro'] = {
          __inherited_from = 'gemini',
          model = 'gemini-2.5-pro-preview-06-05',
          extra_request_body = {
            max_tokens = 8192,
          },
        },
        ['gemini-flash'] = {
          __inherited_from = 'gemini',
          model = 'gemini-2.5-flash-preview-05-20',
          extra_request_body = {
            max_tokens = 8192,
          },
        },
      },
      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
        minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
        enable_token_counting = true, -- Whether to enable token counting. Default to true.
        -- enable_cursor_planning_mode = true, -- Whether to enable Cursor Planning Mode. Default to false.
        auto_focus_sidebar = true,
        auto_suggestions_respect_ignore = false,
        jump_result_buffer_on_finish = true,
        use_cwd_as_project_root = true,
        auto_focus_on_diff_view = false,
      },
      file_selector = {
        provider = 'snacks',
        -- Options override for custom providers
        provider_opts = {},
      },
      mappings = {
        ask = '<leader>aa',
        edit = '<leader>ae',
        refresh = '<leader>ar',
        diff = {
          ours = 'co',
          theirs = 'ct',
          all_theirs = 'ca',
          both = 'cb',
          cursor = 'cc',
          next = ']x',
          prev = '[x',
        },
        suggestion = {
          accept = '<M-l>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
        jump = {
          next = ']]',
          prev = '[[',
        },
        submit = {
          normal = '<CR>',
          insert = '<C-s>',
        },
        sidebar = {
          apply_all = 'A',
          apply_cursor = 'a',
          retry_user_request = 'r',
          edit_user_request = 'e',
          switch_windows = '<Tab>',
          reverse_switch_windows = '<S-Tab>',
          remove_file = 'd',
          add_file = '@',
          close = { '<Esc>' },
          close_from_input = { normal = { '<Esc>' } },
        },
      },
      hints = { enabled = false },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = 'right', -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        width = 30, -- default % based on available width
        sidebar_header = {
          enabled = true, -- true, false to enable/disable the header
          align = 'center', -- left, center, right for title
          rounded = true,
        },
        input = {
          prefix = '󱋊 ', -- Prefix for the input window',
          height = 8, -- Height of the input window in vertical layout
        },
        edit = {
          border = 'rounded',
          start_insert = false, -- Start insert mode when opening the edit window
          floating = false,
        },
        ask = {
          floating = false, -- Open the 'AvanteAsk' prompt in a floating window
          start_insert = false, -- Start insert mode when opening the ask window
          border = 'rounded',
          ---@type "ours" | "theirs"
          focus_on_apply = 'ours', -- which diff to focus after applying
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = 'DiffText',
          incoming = 'DiffAdd',
        },
      },
      --- @class AvanteConflictUserConfig
      diff = {
        autojump = true,
        --- ---@type string | fun(): any
        --- list_opener = 'copen',
        --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
        --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
        --- Disable by setting to -1.
        override_timeoutlen = 500,
      },
      suggestion = {
        debounce = 600,
        throttle = 600,
      },

      web_search_engine = {
        provider = 'tavily', -- tavily, serpapi, searchapi, google, kagi, brave, or searxng
        proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
      },

      ---- mcp hub specific options ----
      -- system_prompt as function ensures LLM always has latest MCP server state
      -- This is evaluated for every message, even in existing chats
      system_prompt = function()
        local hub = require('mcphub').get_hub_instance()
        return hub:get_active_servers_prompt()
      end,
      -- Using function prevents requiring mcphub before it's loaded
      custom_tools = function()
        return {
          require('mcphub.extensions.avante').mcp_tool(),
        }
      end,
      ---- mcp hub specific options ----
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'echasnovski/mini.icons',
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      'ravitemer/mcphub.nvim',
    },
  },
}
