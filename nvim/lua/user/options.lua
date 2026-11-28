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
vim.o.breakindent = true -- wrap lines with indent

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

-- No pbcopy means a remote host (Rex Server over Tailscale, or SSH): copy to the local clipboard via OSC 52.
-- Paste from the unnamed register since Rex doesn't answer OSC 52 read requests (nvim would hang).
if vim.fn.executable('pbcopy') == 0 then
  local osc52 = require('vim.ui.clipboard.osc52')
  local function paste()
    return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
  end
  vim.g.clipboard = {
    name = 'OSC 52 (copy only)',
    copy = { ['+'] = osc52.copy('+'), ['*'] = osc52.copy('*') },
    paste = { ['+'] = paste, ['*'] = paste },
  }
end

vim.opt.conceallevel = 0

vim.opt.diffopt = 'internal,indent-heuristic,filler,closeoff,linematch:60,iwhite,context:4,vertical,inline:char'
-- Highlight settings
vim.cmd('highlight Visual cterm=NONE gui=NONE guibg=#311b92')
