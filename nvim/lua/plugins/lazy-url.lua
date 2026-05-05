return {
  '0xKahi/lazy-url.nvim',
  -- dir = '/Users/kahi/Desktop/code/plugins/neovim/lazy-url.nvim',
  keys = {
    {
      '<leader>ou',
      function()
        require('lazy-url').smart_open()
      end,
      desc = '[O]pen [U]rl',
      silent = false,
      noremap = true,
      mode = { 'n', 'v' },
    },
  },
  opts = {
    browsers = { 'default', 'arc' },
    custom = {
      {
        pattern = 'discord%.com', -- Lua pattern: matches any URL containing "discord.com"
        handler = function(url)
          return {
            cmd = 'open',
            args = { (url:gsub('https://', 'discord://')) },
          }
        end,
      },
    },
  },
}
