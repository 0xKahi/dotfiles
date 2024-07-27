return {
  'frankroeder/parrot.nvim',
  tag = 'v0.3.7',
  dependencies = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim' },
  lazy = true,
  -- optionally include "rcarriga/nvim-notify" for beautiful notifications
  config = function()
    require('parrot').setup({
      -- Providers must be explicitly added to make them available.
      providers = {
        anthropic = {
          api_key = os.getenv('ANTHROPIC_API_KEY'),
        },
        pplx = {},
        openai = {},
        mistral = {},
        gemini = {},
        ollama = {}, -- provide an empty list to make provider available
      },

      cmd_prefix = 'Prt',

      chat_conceal_model_params = false,
      -- Option to move the chat to the end of the file after finished respond
      chat_free_cursor = false,

      -- Chat user prompt prefix
      chat_user_prefix = '🗨:',

      -- Explicitly confirm deletion of a chat file
      chat_confirm_delete = true,
      -- use prompt buftype for chats (:h prompt-buffer)
      chat_prompt_buf_type = false,

      -- Default target for  PrtChatToggle, PrtChatNew, PrtContext and the chats opened from the ChatFinder
      -- values: popup / split / vsplit / tabnew
      toggle_target = 'popup',

      -- The interactive user input appearing when can be "native" for
      -- vim.ui.input or "buffer" to query the input within a native nvim buffer
      -- (see video demonstrations below)
      user_input_ui = 'native',

      -- Popup window layout
      -- border: "single", "double", "rounded", "solid", "shadow", "none"
      style_popup_border = 'rounded',

      -- margins are number of characters or lines
      style_popup_margin_bottom = 8,
      style_popup_margin_left = 1,
      style_popup_margin_right = 2,
      style_popup_margin_top = 2,
      style_popup_max_width = 160,

      -- fzf_lua options for PrtAgent and PrtChatFinder when plugin is installed
      fzf_lua_opts = {
        ['--ansi'] = true,
        ['--sort'] = '',
        ['--info'] = 'inline',
        ['--layout'] = 'reverse',
        ['--preview-window'] = 'nohidden:right:75%',
      },

      -- Enables the query spinner animation
      enable_spinner = true,
      -- Type of spinner animation to display while loading
      -- Available options: "dots", "line", "star", "bouncing_bar", "bouncing_ball"
      spinner_type = 'star',

      hooks = {
        Complete = function(prt, params)
          local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted."
        ]]
          local agent = prt.get_command_agent()
          prt.Prompt(params, prt.ui.Target.append, nil, agent.model, template, agent.system_prompt, agent.provider)
        end,

        CompleteFullContext = function(prt, params)
          local template = [[
        I have the following code from {{filename}} and other realted files:

				```{{filetype}}
				{{multifilecontent}}
				```

				Please look at the following section specifically:
        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted."
        ]]
          local agent = prt.get_command_agent()
          prt.Prompt(params, prt.ui.Target.append, nil, agent.model, template, agent.system_prompt, agent.provider)
        end,

        Explain = function(prt, params)
          local template = [[
        Your task is to take the code snippet from {{filename}} and explain it with gradually increasing complexity.
        Break down the code's functionality, purpose, and key components.
        The goal is to help the reader understand what the code does and how it works.

        ```{{filetype}}
        {{selection}}
        ```

        Use the markdown format with codeblocks and inline code.
        Explanation of the code above:
        ]]
          local agent = prt.get_chat_agent()
          prt.logger.info('Explaining selection with agent: ' .. agent.name)
          prt.Prompt(params, prt.ui.Target.new, nil, agent.model, template, agent.system_prompt, agent.provider)
        end,

        FixBugs = function(prt, params)
          local template = [[
        You are an expert in {{filetype}}.
        Fix bugs in the below code from {{filename}} carefully and logically:
        Your task is to analyze the provided {{filetype}} code snippet, identify
        any bugs or errors present, and provide a corrected version of the code
        that resolves these issues. Explain the problems you found in the
        original code and how your fixes address them. The corrected code should
        be functional, efficient, and adhere to best practices in
        {{filetype}} programming.

        ```{{filetype}}
        {{selection}}
        ```

        Fixed code:
        ]]
          local agent = prt.get_command_agent()
          prt.logger.info('Fixing bugs in selection with agent: ' .. agent.name)
          prt.Prompt(params, prt.ui.Target.new, nil, agent.model, template, agent.system_prompt, agent.provider)
        end,

        Optimize = function(prt, params)
          local template = [[
        You are an expert in {{filetype}}.
        Your task is to analyze the provided {{filetype}} code snippet and
        suggest improvements to optimize its performance. Identify areas
        where the code can be made more efficient, faster, or less
        resource-intensive. Provide specific suggestions for optimization,
        along with explanations of how these changes can enhance the code's
        performance. The optimized code should maintain the same functionality
        as the original code while demonstrating improved efficiency.

        ```{{filetype}}
        {{selection}}
        ```

        Optimized code:
        ]]
          local agent = prt.get_command_agent()
          prt.logger.info('Optimizing selection with agent: ' .. agent.name)
          prt.Prompt(params, prt.ui.Target.new, nil, agent.model, template, agent.system_prompt, agent.provider)
        end,

        UnitTests = function(prt, params)
          local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Please respond by writing table driven unit tests for the code above.
        ]]
          local agent = prt.get_command_agent()
          prt.logger.info('Creating unit tests for selection with agent: ' .. agent.name)
          prt.Prompt(params, prt.ui.Target.enew, nil, agent.model, template, agent.system_prompt, agent.provider)
        end,

        Debug = function(prt, params)
          local template = [[
        I want you to act as {{filetype}} expert.
        Review the following code, carefully examine it, and report potential
        bugs and edge cases alongside solutions to resolve them.
        Keep your explanation short and to the point:

        ```{{filetype}}
        {{selection}}
        ```
        ]]
          local agent = prt.get_chat_agent()
          prt.logger.info('Debugging selection with agent: ' .. agent.name)
          prt.Prompt(params, prt.ui.Target.enew, nil, agent.model, template, agent.system_prompt, agent.provider)
        end,
      },
    })
  end,
}
