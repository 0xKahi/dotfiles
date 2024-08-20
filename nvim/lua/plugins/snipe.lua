return {
  'leath-dub/snipe.nvim',
  enabled = false,
  keys = {
    {
      '<leader>sn',
      function()
        require('snipe').open_buffer_menu()
      end,
      desc = '[S][N]ipe buffer',
    },
  },
  opts = {
    ui = {
      max_width = -1, -- -1 means dynamic width
      -- Where to place the ui window
      -- Can be any of "topleft", "bottomleft", "topright", "bottomright", "center", "cursor" (sets under the current cursor pos)
      position = 'cursor',
    },
    hints = {
      -- Charaters to use for hints (NOTE: make sure they don't collide with the navigation keymaps)
      dictionary = '0123456789',
    },
    navigate = {
      -- When the list is too long it is split into pages
      -- `[next|prev]_page` options allow you to navigate
      -- this list
      next_page = 'J',
      prev_page = 'K',

      -- You can also just use normal navigation to go to the item you want
      -- this option just sets the keybind for selecting the item under the
      -- cursor
      under_cursor = '<space>',

      -- In case you changed your mind, provide a keybind that lets you
      -- cancel the snipe and close the window.
      cancel_snipe = 'q',
    },
    -- Define the way buffers are sorted by default
    -- Can be any of "default" (sort buffers by their number) or "last" (sort buffers by last accessed)
    sort = 'default',
    max_path_width = 3,
  },
}
