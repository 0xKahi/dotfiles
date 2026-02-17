---@param names string[]
---@param opts { glyph: string, hl?: string }
---@return table<string, { glyph: string, hl?: string }>
local function group_icons(names, opts)
  local result = {}
  for _, name in ipairs(names) do
    result[name] = { glyph = opts.glyph, hl = opts.hl }
  end
  return result
end

return {
  'nvim-mini/mini.icons',
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
        ['processor.ts'] = { glyph = ' ', hl = 'NestJsProcessorIcon' },
        ['conf'] = { glyph = '󰢻 ' },
        ['e2e-spec.ts'] = { glyph = '󰂖 ', hl = 'E2ESpecIcon' },
        ['e2e-seq-spec.ts'] = { glyph = '󱉋 ', hl = 'E2ESpecIcon' },
      },
      default = {
        directory = { hl = 'DefaultFolderIcon' },
      },
      -- directory = {
      --   apps = { glyph = '󱋣 ', hl = 'AppFolderIcon' },
      --   libs = { glyph = '󰣞 ', hl = 'LibraryFolderIcon' },
      --   test = { hl = 'TestFolderIcon' },
      --   ['.opencode'] = { glyph = '󱁿', hl = 'OpenCodeFolderIcon' },
      --   ['.nvim'] = { glyph = ' ', hl = 'NvimWorkspaceFolderIcon' },
      --   shared = { glyph = '󰉒 ', hl = 'SharedFolderIcon' },
      --   development = { glyph = '󱧼', hl = 'MiniIconsYellow' },
      --   dev = { glyph = '󱧼', hl = 'MiniIconsYellow' },
      --   production = { glyph = '󱧰', hl = 'MiniIconDarkPurple' },
      --   prod = { glyph = '󱧰', hl = 'MiniIconDarkPurple' },
      -- },
      directory = vim.tbl_extend(
        'force',
        {
          apps = { glyph = '󱋣 ', hl = 'AppFolderIcon' },
          libs = { glyph = '󰣞 ', hl = 'LibraryFolderIcon' },
          test = { hl = 'TestFolderIcon' },
          ['.opencode'] = { glyph = '󱁿', hl = 'OpenCodeFolderIcon' },
          ['.nvim'] = { glyph = ' ', hl = 'NvimWorkspaceFolderIcon' },
          shared = { glyph = '󰉒 ', hl = 'SharedFolderIcon' },
        },
        group_icons({ 'dev', 'development' }, { glyph = '󱧼', hl = 'MiniIconsYellow' }),
        group_icons({ 'prod', 'production' }, { glyph = '󱧰', hl = 'MiniIconDarkPurple' })
      ),
    })
  end,
}
