local snippet_commands = {
  [' nestJs-basic'] = require('snippets.nestjs-basic'),
  [' nestJs-graphql'] = require('snippets.nestjs-graphql'),
  [' typeorm'] = require('snippets.typeorm'),
  ['󱢨 shuffle'] = require('snippets.shuffle'),
  ['󰙨 test'] = require('snippets.quick-tests'),
}

vim.api.nvim_create_user_command('SnippetPaste', function()
  vim.ui.select(vim.tbl_keys(snippet_commands), {
    prompt = 'Select Snippet Type',
  }, function(choice)
    if choice == nil then
      print('No choice made.')
      return
    end

    local snippetType = snippet_commands[choice]

    vim.ui.select(vim.tbl_keys(snippetType), {
      prompt = 'Choose Snippet To Paste',
    }, function(pasteChoice)
      if pasteChoice == nil then
        print('No choice made.')
        return
      end

      snippetType[pasteChoice].pasteSnippet()
    end)
  end)
end, {
  desc = 'Paste Snippet',
})
