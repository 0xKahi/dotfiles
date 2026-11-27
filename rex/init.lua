-- luacheck: globals rex JoJo
-- stylua: ignore
_G.rex = rex

require('jojo')
require('keybinds')
require('actions')

require('extensions.session-pin').setup({
  key = JoJo.key.prefix('p'),
  session_name = 'scratch',
})
require('extensions.rex-thumbs').setup({
  key = JoJo.key.prefix('shift+f'),
})
require('extensions.nvim-lazy-url-open')
-- from `./rex/keybinds/pane-manage.lua` mode
require('extensions.batch-commands').setup({
  key = 'panemux/u',
  commands = {
    work = {
      description = 'Pull and update repos in the workspace',
      batch = JoJo.secrets.get('workspace_cmds'),
    },
    update_tools = {
      description = 'Update tools',
      batch = {
        { 'jojo', 'refresh' },
        { 'llw', 'upgrade' },
        { 'bash', '~/.config/rex/scripts/pane-mux-update.sh' },
      },
    },
  },
})
