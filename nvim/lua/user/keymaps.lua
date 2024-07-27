-- personal keymap
vim.api.nvim_set_keymap('i', 'kj', '<ESC>', { noremap = true })
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, desc = 'Redo' })
vim.keymap.set('n', '<leader>gb', ':bp <CR>', { noremap = true, desc = '[G]o [B]ack' })

--- Plugin Remaps --

-- Telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', telescope.git_files, { desc = 'find files in git', noremap = true })
vim.keymap.set(
  'n',
  '<C-f>',
  telescope.current_buffer_fuzzy_find,
  { desc = 'fuzzy find in current buffer', noremap = true }
)
vim.keymap.set('n', '<leader>ff', function()
  telescope.find_files({ no_ignore = false, hidden = true })
end, { desc = '[F]ind all [F]iles', noremap = true })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = '[F]ind [G]rep in directory', noremap = true })
vim.keymap.set(
  'n',
  '<leader>fw',
  telescope.grep_string,
  { desc = '[F]ind current [W]ord in directory', noremap = true }
)
vim.keymap.set('n', '<leader>fp', telescope.oldfiles, { desc = '[F]ind [P]ast files', silent = false, noremap = true })
vim.keymap.set(
  'n',
  '<leader>pp',
  telescope.resume,
  { desc = '[P]ast telescope [P]ickers', silent = false, noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>nc',
  '<cmd>Telescope neoclip<CR>',
  { desc = '[N]eo [C]lip', silent = false, noremap = true }
)

-- undotree
vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle, { desc = '[U]ndo [T]ree', silent = true, noremap = true })

-- Conform (Formatter)
local conform = require('conform')
-- Keybinding for manual formatting
-- in normal mode format whole file
-- in visual mode format selected buffer only
vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, { desc = '[F]or[M]at file or range (in visual mode)' })

-- Harpoon
-- personal config to setup webdev icons
local harpoon_config = require('config.harpoon')
harpoon_config.setup()

local harpoon = require('harpoon')

vim.keymap.set('n', '<leader>ac', function()
  harpoon:list():add()
end, { desc = '[A]n[C]hor current file', silent = false, noremap = true })

vim.keymap.set('n', '<leader>ha', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = '[HA]rpoon', silent = true, noremap = true })

harpoon:extend({
  UI_CREATE = function(cx)
    vim.keymap.set('n', '<C-v>', function()
      harpoon.ui:select_menu_item({ vsplit = true })
    end, { buffer = cx.bufnr })

    vim.keymap.set('n', '<C-h>', function()
      harpoon.ui:select_menu_item({ split = true })
    end, { buffer = cx.bufnr })
  end,
})

-- vim.keymap.set('n', '<leader>sh', function()
--   harpoon_config.toggle_telescope(harpoon:list())
-- end, { desc = 'Open harpoon window' })

-- NeoTree
vim.keymap.set('n', '<leader>oe', ':Neot reveal<CR>', { desc = '[O]pen [E]xplorer', noremap = true, silent = true })

-- LazyGit
vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<CR>', { desc = '[L]azy [G]it', noremap = true, silent = true })

-- Oil
vim.keymap.set('n', '<leader>oo', '<CMD>Oil --float<CR>', { desc = '[O]pen [O]il window', noremap = true })

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
})

vim.g.copilot_no_tab_map = true

-- gitsigns
vim.keymap.set('n', '<leader>ob', ':Gitsigns blame<cr>', { desc = '[O]pen git [B]lame', silent = true, noremap = true })

-- noice
vim.keymap.set(
  'n',
  '<leader>nn',
  ':Noice dismiss<CR>',
  { desc = '[N]o [N]otification', silent = false, noremap = true }
)
