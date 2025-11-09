return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function()
      require('gitsigns').setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          vim.keymap.set(
            'n',
            '<leader>ob',
            ':Gitsigns blame<cr>',
            { desc = '[O]pen git [B]lame', silent = true, noremap = true }
          )

          vim.keymap.set(
            'n',
            '<leader>sh',
            ':Gitsigns preview_hunk<cr>',
            { desc = '[S]how [H]unk', silent = true, noremap = true }
          )

          vim.keymap.set(
            'n',
            '<leader>sb',
            ':Gitsigns blame_line<cr>',
            { desc = '[S]how [B]lame', silent = true, noremap = true }
          )
          vim.keymap.set(
            'n',
            '<leader>rh',
            ':Gitsigns reset_hunk<cr>',
            { desc = '[R]eset [H]unk', silent = true, noremap = true }
          )

          vim.keymap.set(
            'n',
            '<leader>Sh',
            ':Gitsigns stage_hunk<cr>',
            { desc = '[S]tage [H]unk', silent = true, noremap = true }
          )
          vim.keymap.set(
            'n',
            '<leader>dt',
            ':Gitsigns diffthis<cr>',
            { desc = '[D]iff [T]his', silent = true, noremap = true }
          )

          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = '(])Jump to next hunk' })

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = '([)Jump to previous hunk' })
        end,
      })
    end,
  },
}
