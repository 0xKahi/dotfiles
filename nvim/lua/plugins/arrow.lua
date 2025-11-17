return {
  '0xKahi/arrow.nvim',
  -- dir = '~/Desktop/code/editor_extras/vim_plugins/arrow.nvim',
  -- dev = true,
  opts = {
    show_icons = true,
    icon_provider = 'mini',
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
      toggle_bookmark_type = '<TAB>',
    },
    -- controls the appearance and position of an arrow window (see nvim_open_win() for all options)
    window = {
      width = 'auto',
      height = 'auto',
      row = 'auto',
      col = 'auto',
      border = 'rounded',
    },

    dir_bookmark_config = {
      open_action = function(dir_path, _)
        -- print('Opening dir:', dir_path)
        require('oil').open_float(dir_path)
      end,
    },
    separate_save_and_remove = true, -- if true, will remove the toggle and create the save/remove keymaps.
  },
}
