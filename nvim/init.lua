-- luacheck: globals vim
-- stylua: ignore
_G.vim = vim
vim.uv = vim.uv or vim.loop

require('user.jojo')
require('user.options')
require('user.lazy')
require('user.pack')
require('user.colorscheme')
require('user.keymaps')
require('user.shortcuts')
require('user.autocmd')
