rex.action({
  name = 'jojo_cache',
  title = 'JoJo: Show Cache',
  description = 'Show the values cached in JoJo.store. Usage: rex do jojo_cache [refresh=true]',
  category = 'JoJo',
  args = { refresh = 'boolean?' },
  run = function(_, args)
    -- clear every key; each one is rebuilt the next time it's used
    if args.refresh then
      for key in pairs(JoJo.store._cache) do
        JoJo.store:set(key, nil)
      end
    end

    local function show(value)
      if value == nil then
        return 'None'
      end
      return value
    end

    local cache = {}
    for key, value in pairs(JoJo.store._cache) do
      cache[key] = show(value)
    end
    return cache
  end,
})
