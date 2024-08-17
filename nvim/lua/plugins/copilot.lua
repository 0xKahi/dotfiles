return {
  {
    'github/copilot.vim',
    enabled = false,
    config = function()
      -- Disable omni completion for sql @WARN: not sure if its the best idea
      vim.g.ftplugin_sql_omni_key_right = ''
      vim.g.ftplugin_sql_omni_key_left = ''

      vim.keymap.set('i', '<right>', function()
        if vim.fn['copilot#GetDisplayedSuggestion']().text ~= '' then
          vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](), 'i', true)
          return ''
        else
          return '<right>'
        end
      end, {
        expr = true,
        replace_keycodes = true,
        silent = true,
        desc = 'acept copilot',
      })

      vim.g.copilot_no_tab_map = true
    end,
  },
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup({
        ignore_filetypes = { cpp = true },
        log_level = 'info', -- set to "off" to disable logging completely
        disable_inline_completion = false, -- disables inline completion for use with cmp
        disable_keymaps = true, -- disables built in keymaps for more manual control
      })

      -- the regualr setup lags idk why this the solution
      vim.keymap.set('i', '<Right>', function()
        local suggestion = require('supermaven-nvim.completion_preview')
        if suggestion.has_suggestion() then
          -- Use vim.schedule to ensure the suggestion is accepted in the next event loop
          vim.schedule(function()
            suggestion.on_accept_suggestion() -- false for full suggestion, true for partial (word)
          end)
          return '' -- Return an empty string to prevent the default right arrow behavior
        else
          -- If no suggestion, return the literal right arrow key press
          return vim.api.nvim_replace_termcodes('<Right>', true, false, true)
        end
      end, {
        expr = true,
        replace_keycodes = true,
        silent = true,
        desc = 'acept supermaven',
      })
    end,
  },
}
