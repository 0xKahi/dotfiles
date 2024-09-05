return {
  {
    'github/copilot.vim',
    enabled = true,
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
        desc = '[->] accept copilot',
      })

      vim.g.copilot_no_tab_map = true
    end,
  },
}
