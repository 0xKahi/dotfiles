return {
  'otavioschwanck/arrow.nvim',
  opts = {
    show_icons = true,
    leader_key = '<leader>ao', -- Recommended to be a single key
    buffer_leader_key = '<leader>m', -- Per Buffer Mappings

    separate_by_branch = false, -- Bookmarks will be separated by git branch
    hide_handbook = false, -- set to true to hide the shortcuts on menu.

    mappings = {
      edit = 'e',
      delete_mode = 'd',
      clear_all_items = 'C',
      toggle = 'w', -- used as save if separate_save_and_remove is true
      open_vertical = 'v',
      open_horizontal = 's',
      quit = 'q',
      remove = 'x', -- only used if separate_save_and_remove is true
      next_item = ']',
      prev_item = '[',
    },

    -- controls the appearance and position of an arrow window (see nvim_open_win() for all options)
    window = {
      width = 'auto',
      height = 'auto',
      row = 'auto',
      col = 'auto',
      border = 'rounded',
    },
    separate_save_and_remove = true, -- if true, will remove the toggle and create the save/remove keymaps.
  },
}
