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
