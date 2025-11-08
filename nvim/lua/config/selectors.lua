local M = {}
local utils = require('utils.misc')

---@param onComplete fun(value: string) Callback function called with the selected git reference
function M.git_ref(onComplete)
  local get_ref_completions = function(key_prefix)
    key_prefix = key_prefix or ''
    local completions = { key_prefix .. 'HEAD' }
    local ok, refs = utils.execute_cmd('git show-ref')
    if not ok then
      return {}
    end
    for _, ref in ipairs(refs) do
      local _, i = ref:find('refs%/%a+%/')
      if i then
        table.insert(completions, key_prefix .. ref:sub(i + 1))
      end
    end

    return completions
  end

  local choices = get_ref_completions()

  vim.ui.select(choices, {
    prompt = 'Select Git Ref',
  }, function(choice)
    if choice == nil then
      print('No choice made')
      return
    end

    onComplete(choice)
  end)
end

return M
