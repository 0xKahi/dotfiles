-- personal keymap
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true }) -- set space as leader key
vim.api.nvim_set_keymap('i', 'kj', '<ESC>', { noremap = true })
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, desc = 'Redo' })

vim.api.nvim_set_keymap('n', '<leader>bp', ':bprev<enter>', { desc = '[B]uffer [P]revious', noremap = false })
vim.api.nvim_set_keymap('n', '<leader>bn', ':bnext<enter>', { desc = '[B]uffer [N]ext', noremap = false })
vim.api.nvim_set_keymap('n', '<leader>bd', ':bdelete<enter>', { desc = '[B]uffer [Delete]', noremap = false })

vim.keymap.set('x', '<leader>p', '"_dP', { desc = '[P]aste to blackhole register', noremap = true, silent = true })
-- vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { noremap = true, silent = true })
vim.keymap.set(
  { 'n', 'v' },
  '<leader>d',
  '"_d',
  { desc = '[D]elete to blackhole register', noremap = true, silent = true }
)
--- Plugin Remaps --

-- Telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', function()
  telescope.git_files({ show_untracked = true })
end, { desc = 'find files in git', noremap = true })

vim.keymap.set('n', '<leader>/', function()
  telescope.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
    previewer = true,
  }))
end, { desc = '[/] Fuzzy Find in current buffer]' })

vim.keymap.set('n', '<leader>ff', function()
  telescope.find_files({ no_ignore = true, hidden = true })
end, { desc = '[F]ind all [F]iles', noremap = true })

vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = '[F]ind [G]rep in directory', noremap = true })

vim.keymap.set(
  'n',
  '<leader>fw',
  telescope.grep_string,
  { desc = '[F]ind current [W]ord in directory', noremap = true }
)

vim.keymap.set('n', '<leader>fp', function()
  telescope.oldfiles({ only_cwd = true })
end, { desc = '[F]ind [P]ast files', silent = false, noremap = true })

vim.keymap.set('n', '<leader>fb', function()
  telescope.buffers(require('telescope.themes').get_ivy())
end, { desc = '[F]ind [B]uffers', silent = false, noremap = true })

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

-- lualine
-- Map <leader>ll{number} to jump to that buffer
for i = 1, 9 do
  vim.keymap.set(
    'n',
    '<leader>ll' .. i,
    string.format('<cmd>LualineBuffersJump! %d<CR>', i),
    { desc = string.format('[L]ua [L]ine jump to buffer %d', i), silent = false, noremap = true }
  )
end

vim.keymap.set('n', '<leader>llr', function()
  require('lualine').refresh()
  print('Lualine refreshed')
end, { desc = '[L]ua [L]ine [R]efresh', silent = false, noremap = true })

-- Conform (Formatter)
local conform = require('conform')
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

    vim.keymap.set('n', '<C-s>', function()
      harpoon.ui:select_menu_item({ split = true })
    end, { buffer = cx.bufnr })
  end,
})

-- vim.keymap.set('n', '<leader>sh', function()
--   harpoon_config.toggle_telescope(harpoon:list())
-- end, { desc = 'Open harpoon window' })

-- NeoTree
vim.keymap.set('n', '<leader>oe', ':Neot reveal<CR>', { desc = '[O]pen [E]xplorer', noremap = true, silent = true })
vim.keymap.set(
  'n',
  '<leader>ds',
  ':Neot document_symbols<CR>',
  { desc = '[D]ocument [S]ymbols', noremap = true, silent = true }
)
