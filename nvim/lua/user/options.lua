-- Make sure to setup `mapleader` and `maplocalleader` before
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.nu = true
vim.opt.rnu = true

vim.opt.title = true
vim.opt.showcmd = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.completeopt = 'menuone,noselect'

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.shell = 'zsh'
vim.opt.fileencoding = 'utf-8' -- the encoding written to a file

vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.o.autoindent = true -- copy indent from current line when starting new one

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.termguicolors = true
vim.opt.colorcolumn = ''
vim.opt.cursorline = true

vim.o.winborder = 'single'
vim.o.winblend = 0

vim.opt.clipboard:append('unnamedplus')

vim.opt.conceallevel = 0

-- Highlight settings
vim.cmd('highlight Visual cterm=NONE gui=NONE guibg=#311b92')
