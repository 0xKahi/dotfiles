return {
  'RRethy/vim-illuminate',
  event = { 'BufEnter' },
  config = function()
    require('illuminate').configure({
      under_cursor = false,
      filetypes_denylist = {
        'Outline',
        'TelescopePrompt',
        'neo-tree',
        'harpoon',
        'NeogitStatus',
        'trouble',
      },
    })
  end,
}
