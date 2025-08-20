local M = {}

function M.setup_snacks_lsp_keymaps(bufnr)
  vim.keymap.set('n', 'gd', function()
    Snacks.picker.lsp_definitions({
      layout = 'basic',
    })
  end, { buffer = bufnr, desc = '[G]o to [D]efinition' })

  vim.keymap.set('n', 'gp', function()
    Snacks.picker.lsp_definitions({ auto_confirm = false, layout = 'bottom' })
  end, { buffer = bufnr, desc = '[G]o to [P]review definition' })

  vim.keymap.set('n', 'gr', function()
    Snacks.picker.lsp_references({
      layout = 'basic',
    })
  end, { buffer = bufnr, desc = '[G]o to [R]eferences' })
end

function M.setup_telescope_lsp_keymaps(bufnr)
  local telescope = require('telescope.builtin')
  vim.keymap.set('n', 'gd', telescope.lsp_definitions, { buffer = bufnr, desc = '[G]o to [D]efinition' })

  vim.keymap.set('n', 'gp', function()
    telescope.lsp_definitions(require('telescope.themes').get_ivy({ jump_type = 'never' }))
  end, { buffer = bufnr, desc = '[G]o to [P]review definition' })

  vim.keymap.set('n', 'gr', function()
    telescope.lsp_references({ fname_width = 60 })
  end, { buffer = bufnr, desc = '[G]o to [R]eferences' })

  vim.keymap.set('n', 'go', telescope.lsp_type_definitions, { buffer = bufnr, desc = 'Go to type definition' })

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = '[G]o to [D]eclaration' })

  vim.keymap.set('n', 'gi', telescope.lsp_implementations, { buffer = bufnr, desc = '[G]o to [I]mplementation' })
end

return M
