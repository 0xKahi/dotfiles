local M = {}

M.git_status = {
  added = '',
  modified = '',
  deleted = '',
  renamed = '',
  untracked = '󱔢',
  ignored = '',
  -- unstaged = '[-S]',
  staged = '',
  conflict = ' ',
  unmerged = ' ',
  commit = '󰜘 ',
}

M.git_status_glyphs = {
  generic = '┃',
  deleted = '_',
  untracked = '┆',
  ignored = '',
}

M.git_signs = {
  add = { text = '┃' },
  change = { text = '┃' },
  delete = { text = '_' },
  topdelete = { text = '‾' },
  changedelete = { text = '~' },
  untracked = { text = '┆' },
}

return M
