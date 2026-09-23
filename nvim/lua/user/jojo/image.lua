-- Image helpers.
-- snacks.image rasterizes svg via ImageMagick (only its args are configurable, not the tool),
-- so for places snacks doesn't cover (e.g. neo-tree's preview) we rasterize with resvg ourselves.

---@class user.jojo.image
local M = {}

M.svg_cache = vim.fn.stdpath('cache') .. '/jojo-svg'

--- Background color matching the current colorscheme, so transparent svgs stay visible.
---@return string hex
function M.background()
  local bg = vim.api.nvim_get_hl(0, { name = 'Normal', link = false }).bg
  if bg then
    return ('#%06x'):format(bg)
  end
  return vim.o.background == 'dark' and '#000000' or '#ffffff'
end

--- Rasterize an svg to a cached png with resvg, without blocking the UI.
--- Renders are cached per file; a new mtime or background invalidates the old render.
---@param src string absolute path to an svg file
---@param cb fun(png: string|nil) called on the main loop with the png path, or nil on failure
function M.render_svg(src, cb)
  if vim.fn.executable('resvg') ~= 1 then
    return cb(nil)
  end

  local stat = vim.uv.fs_stat(src)
  if not stat then
    return cb(nil)
  end

  local bg = M.background()
  -- path prefix groups renders of the same file; mtime + bg identify the current one
  local prefix = vim.fn.sha256(src):sub(1, 12)
  local key = vim.fn.sha256(('%d.%d%s'):format(stat.mtime.sec, stat.mtime.nsec, bg)):sub(1, 8)
  local png = ('%s/%s-%s.png'):format(M.svg_cache, prefix, key)
  if vim.uv.fs_stat(png) then
    return cb(png)
  end

  vim.fn.mkdir(M.svg_cache, 'p')
  for _, old in ipairs(vim.fn.glob(('%s/%s-*.png'):format(M.svg_cache, prefix), false, true)) do
    vim.uv.fs_unlink(old)
  end

  -- --zoom trades render time for sharpness
  vim.system({ 'resvg', '--zoom', '2', '--background', bg, src, png }, { text = true }, function(out)
    vim.schedule(function()
      if out.code ~= 0 then
        vim.notify(('resvg failed for %s: %s'):format(src, out.stderr or ''), vim.log.levels.DEBUG)
        return cb(nil)
      end
      cb(png)
    end)
  end)
end

return M
