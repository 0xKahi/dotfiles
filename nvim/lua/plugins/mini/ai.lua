return {
  'nvim-mini/mini.ai',
  version = false,
  event = 'VeryLazy',
  config = function()
    require('mini.ai').setup()
  end,
}
