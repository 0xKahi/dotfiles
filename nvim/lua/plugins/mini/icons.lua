return {
  'echasnovski/mini.icons',
  opts = {},
  lazy = true,
  specs = {
    { 'nvim-tree/nvim-web-devicons', enabled = false, optional = true },
  },
  init = function()
    package.preload['nvim-web-devicons'] = function()
      require('mini.icons').mock_nvim_web_devicons()
      return package.loaded['nvim-web-devicons']
    end

    -- highlights defined in config.cyberpunk
    require('mini.icons').setup({
      extension = {
        ['module.ts'] = { glyph = ' ', hl = 'NestJsModuleIcon' },
        ['service.ts'] = { glyph = ' ', hl = 'NestJsServiceIcon' },
        ['resolver.ts'] = { glyph = ' ', hl = 'NestJsResolverIcon' },
        ['controller.ts'] = { glyph = ' ', hl = 'NestJsControllerIcon' },
        ['conf'] = { glyph = '󰢻 ' },
      },
      default = {
        directory = { hl = 'DefaultFolderIcon' },
      },
      directory = {
        apps = { glyph = '󱋣 ', hl = 'AppFolderIcon' },
        libs = { glyph = '󰣞 ', hl = 'LibraryFolderIcon' },
        test = { hl = 'TestFolderIcon' },
      },
    })
  end,
}
