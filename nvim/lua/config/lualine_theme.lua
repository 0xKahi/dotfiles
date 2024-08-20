local M = {}
local cyberpunk = require('config.cyberpunk.colors')
-- TODO: intergate with theme
local colors = {
  black = '#1b1d2b',
  fg_gutter = '#3b4261',
  fg_sidebar = '#828bb8',
  bg_statusline = '#1e2030',
  green1 = '#4fd6be',
}

M.normal = {
  a = { bg = cyberpunk.core.blue, fg = colors.black },
  b = { bg = colors.fg_gutter, fg = cyberpunk.core.blue },
  c = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
}

M.insert = {
  a = { bg = cyberpunk.core.green, fg = colors.black },
  b = { bg = colors.fg_gutter, fg = cyberpunk.core.green },
}

M.command = {
  a = { bg = cyberpunk.core.red, fg = colors.black },
  b = { bg = colors.fg_gutter, fg = cyberpunk.core.red },
}

M.visual = {
  a = { bg = cyberpunk.core.magenta, fg = colors.black },
  b = { bg = colors.fg_gutter, fg = cyberpunk.core.magenta },
}

M.replace = {
  a = { bg = cyberpunk.core.yellow, fg = colors.black },
  b = { bg = colors.fg_gutter, fg = cyberpunk.core.yellow },
}

M.terminal = {
  a = { bg = colors.green1, fg = colors.black },
  b = { bg = colors.fg_gutter, fg = colors.green1 },
}

M.inactive = {
  a = { bg = colors.bg_statusline, fg = cyberpunk.core.blue },
  b = { bg = colors.bg_statusline, fg = colors.fg_gutter, gui = 'bold' },
  c = { bg = colors.bg_statusline, fg = colors.fg_gutter },
}

return M
