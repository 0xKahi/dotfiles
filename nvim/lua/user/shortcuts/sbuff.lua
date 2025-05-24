local scratch_buffers = {
  ['󰃬 calculator'] = {
    func = function()
      Snacks.scratch.open({
        name = 'calculator',
        ft = 'lua',
        icon = '󰃬',
        autowrite = true,
        root = vim.fn.stdpath('data') .. '/scratch',
        filekey = {
          cwd = false, -- use current working directory
          branch = false, -- use current branch name
          count = false, -- use vim.v.count1
        },
        win = { style = 'scratch', relative = 'editor' },
      })
    end,
  },
  ['  scrap-paper'] = {
    func = function()
      Snacks.scratch.open({
        name = 'scrap-paper',
        ft = 'markdown',
        icon = ' ',
        autowrite = true,
        root = vim.fn.stdpath('data') .. '/scratch',
        filekey = {
          cwd = false, -- use current working directory
          branch = false, -- use current branch name
          count = false, -- use vim.v.count1
        },
        win = { style = 'scratch', relative = 'editor' },
      })
    end,
  },
  [' playground'] = {
    func = function()
      Snacks.scratch.open({
        name = 'playground',
        ft = 'lua',
        icon = ' ',
        autowrite = true,
        root = vim.fn.stdpath('data') .. '/scratch',
        filekey = {
          cwd = false, -- use current working directory
          branch = false, -- use current branch name
          count = false, -- use vim.v.count1
        },
        win = { style = 'scratch', relative = 'editor' },
      })
    end,
  },
}

vim.api.nvim_create_user_command('SBuff', function()
  vim.ui.select(vim.tbl_keys(scratch_buffers), {
    prompt = 'Select Scratch Buffer',
  }, function(choice)
    if choice == nil then
      print('No choice made.')
      return
    end

    scratch_buffers[choice].func()
  end)
end, {
  desc = 'Toggle Scratch Buffers',
})
