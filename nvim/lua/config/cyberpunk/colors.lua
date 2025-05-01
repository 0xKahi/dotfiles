local M = {}

M.core = {
  fg = '#c8d3f5', --tky fg
  bg = '#312954',
  dark_bg = '#261d45',
  black = '#1b1d2b',
  secondary_black = '#1e2030',
  white = '#c8d3f5',
  magenta = '#D498F8',
  red = '#ED7892',
  green = '#72F6B2',
  blue = '#55BBF9',
  yellow = '#FDF980',
  cyan = '#95C9F8',
  bright_magenta = '#DDAFF8',
  bright_red = '#EF8FA4',
  bright_green = '#74F2BF',
  bright_blue = '#5FC8F7',
  bright_yellow = '#FDF796',
  bright_cyan = '#95C9F8',
  semi_light_black = '#444a73',
  light_black = '#545e8a',
  neon_green = '#00FF9C',
  neon_blue = '#3d5afe',
  highlight = '#311b92',
  highlight2 = '#2d3f76', -- combination of cyberpunk highlight and tky highlight kinda like it so gona leave it here
  orange = '#ff966c',
  hint = '#41a6b5',
  tky_blue = '#82aaff',
}

M.lsp = {
  comments = '#636da6', --tky comments
  interface = '#83c3fc',
  property = '#4fd6be',
  class = '#B4BAF8',
  enum = '#ffbfa6',
  keyword_red = '#f97e9d',
  html_tag = '#ff757f',
  react_tag = '#86e1fc',
  builtin = '#E5D97D',
  builtin_bright = '#ffe96c',
  weirdbrown = '#D1C5C0',
  string = '#a4d6ff',
  operator = '#fca7ea',
  keyword_purple = '#c099ff',
  func = '#82aaff',
  delimiter = '#89DDFF',
}

M.markview = {
  gem = '#00e1ff',
  tip = '#a7e683',
  candy = '#ff94f1',
  note = '#e9973f',
  dev = '#e0e0e0',
  warn = '#e9973f',
  success = '#56f586',
  fail = '#fb464c',
  important = '#ff3838',
  info = '#6F94FF',
}

M.lualine = {
  fg_gutter = '#3b4261',
  fg_sidebar = '#828bb8',
  bg_statusline = '#1e2030',
  green = '#4fd6be',
}

return M
