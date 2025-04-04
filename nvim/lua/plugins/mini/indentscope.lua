return {
  'echasnovski/mini.indentscope',
  version = false,
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    -- symbol = '│',
    symbol = '╎',
    options = { try_as_border = true },
    mappings = {
      -- Textobjects
      object_scope = 'ii',
      object_scope_with_border = 'ai',
      -- Motions (jump to respective border line; if not present - body line)
      goto_top = '[i',
      goto_bottom = ']i',
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'noice',
        'cmdline',
        'help',
        'neo-tree',
        'Trouble',
        'trouble',
        'lazy',
        'mason',
        'notify',
        'lazyterm',
        'terminal',
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
