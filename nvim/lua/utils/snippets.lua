local M = {}

---@class SnippetHandlerConfig
---@field snippet string The raw snippet string with placeholders.
---@field promptName string The noun to use in the input prompt (e.g., "Service", "Resolver").
---@field formatArgsFn fun(name: string): string[] A function that takes the user-provided name and returns a table of arguments for string.format.

---@class SnippetActions
---@field getSnippet fun(): string Returns the raw snippet string.
---@field pasteSnippet fun(): nil Prompts for a name, formats the snippet, and pastes it.

--- Factory function to create snippet handlers.
---@param config SnippetHandlerConfig The configuration for this specific snippet type.
---@return SnippetActions A table containing getSnippet and pasteSnippet functions.
M.basicSnippetHandler = function(config)
  return {
    getSnippet = function()
      return config.snippet
    end,

    pasteSnippet = function()
      local inputName = vim.fn.input('Enter ' .. config.promptName .. ' Name: ')

      local snippetText
      if inputName == '' then
        snippetText = config.snippet:format(unpack(config.formatArgsFn('Test')))
      else
        snippetText = config.snippet:format(unpack(config.formatArgsFn(inputName)))
      end

      vim.api.nvim_paste(snippetText, false, -1)
    end,
  }
end

--- Factory function for repeating snippet arg values
---@param input string arg you want to repeat.
---@param count number ammount of times it should be repeated.
---@return string[]  table containing all args.
M.repeatArgsValue = function(input, count)
  local t = {}
  for i = 1, count do
    t[i] = input
  end
  return t
end

return M
