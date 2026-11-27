-- for nvim plugin https://github.com/0xKahi/lazy-url.nvim
rex.action({
  name = 'lazy_url_open',
  title = 'lazy-url: Open URL',
  description = 'Open a URL sent by lazy-url.nvim on this machine',
  args = { url = 'string', app = 'string?' },
  run = function(_, args)
    -- only URLs with a scheme (https:, discord:, ...); also stops a leading '-' reaching `open`
    if not args.url:match('^%a[%w+.-]*:') then
      error('lazy_url_open: not a URL: ' .. args.url)
    end
    local argv = args.app and { 'open', '-a', args.app, args.url } or { 'open', args.url }
    local result, err = rex.exec(argv, { timeout = 10 })
    if not (result and result.ok) then
      error('lazy_url_open: ' .. tostring(err or (result and result.stderr)))
    end
  end,
})
