return {
  'augmentcode/augment.vim',
  cmd = {
    'Augment',
  },
  keys = {
    {
      '<leader>oa',
      '<CMD>Augment chat-toggle<CR>',
      { mode = { 'n' }, desc = '[O]pen [A]ugment', noremap = true },
    },
    {
      '<leader>aa',
      '<CMD>Augment chat<CR>',
      mode = { 'v', 'n' },
      desc = '[A]ugment [A]sk',
    },
  },
  config = function()
    vim.g.ftplugin_sql_omni_key_right = ''
    vim.g.ftplugin_sql_omni_key_left = ''

    vim.g.augment_disable_tab_mapping = true
    vim.keymap.set('i', '<right>', function()
      vim.fn['augment#Accept']('<right>')
      -- vim.api.nvim_feedkeys(vim.fn['augment#Accept']('<right>'), 'i', true)
    end, {
      -- expr = true,
      -- replace_keycodes = true,
      silent = true,
      desc = '[->] accept augment',
    })
  end,
}
