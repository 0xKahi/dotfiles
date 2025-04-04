local M = {}
local cyberpunk = require('config.cyberpunk.colors')

M.normal = {
  a = { bg = cyberpunk.core.blue, fg = cyberpunk.core.black },
  b = { bg = cyberpunk.lualine.fg_gutter, fg = cyberpunk.core.blue },
  c = { bg = cyberpunk.lualine.bg_statusline, fg = cyberpunk.lualine.fg_sidebar },
}

M.insert = {
  a = { bg = cyberpunk.core.green, fg = cyberpunk.core.black },
  b = { bg = cyberpunk.lualine.fg_gutter, fg = cyberpunk.core.green },
}

M.command = {
  a = { bg = cyberpunk.core.red, fg = cyberpunk.core.black },
  b = { bg = cyberpunk.lualine.fg_gutter, fg = cyberpunk.core.red },
}

M.visual = {
  a = { bg = cyberpunk.core.magenta, fg = cyberpunk.core.black },
  b = { bg = cyberpunk.lualine.fg_gutter, fg = cyberpunk.core.magenta },
}

M.replace = {
  a = { bg = cyberpunk.core.yellow, fg = cyberpunk.core.black },
  b = { bg = cyberpunk.lualine.fg_gutter, fg = cyberpunk.core.yellow },
}

M.terminal = {
  a = { bg = cyberpunk.lualine.green, fg = cyberpunk.core.black },
  b = { bg = cyberpunk.lualine.fg_gutter, fg = cyberpunk.lualine.green },
}

M.inactive = {
  a = { bg = cyberpunk.lualine.bg_statusline, fg = cyberpunk.core.blue },
  b = { bg = cyberpunk.lualine.bg_statusline, fg = cyberpunk.lualine.fg_gutter, gui = 'bold' },
  c = { bg = cyberpunk.lualine.bg_statusline, fg = cyberpunk.lualine.fg_gutter },
}

return M
