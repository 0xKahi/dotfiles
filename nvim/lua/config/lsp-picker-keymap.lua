local M = {}

function M.setup_snacks_lsp_keymaps(bufnr)
  vim.keymap.set('n', 'gd', function()
    Snacks.picker.lsp_definitions({
      layout = 'basic',
    })
  end, { buffer = bufnr, desc = '[G]o to [D]efinition' })

  vim.keymap.set('n', 'gp', function()
    Snacks.picker.lsp_definitions({ auto_confirm = false, layout = 'bottom' })
  end, { buffer = bufnr, desc = '[G]o to [P]review definition' })

  vim.keymap.set('n', 'gr', function()
    Snacks.picker.lsp_references({
      layout = 'basic',
    })
  end, { buffer = bufnr, desc = '[G]o to [R]eferences' })
end

function M.setup_telescope_lsp_keymaps(bufnr)
  local telescope = require('telescope.builtin')
  vim.keymap.set('n', 'gd', telescope.lsp_definitions, { buffer = bufnr, desc = '[G]o to [D]efinition' })

  vim.keymap.set('n', 'gp', function()
    telescope.lsp_definitions(require('telescope.themes').get_ivy({ jump_type = 'never' }))
  end, { buffer = bufnr, desc = '[G]o to [P]review definition' })

  vim.keymap.set('n', 'gr', function()
    telescope.lsp_references({ fname_width = 60 })
  end, { buffer = bufnr, desc = '[G]o to [R]eferences' })

  vim.keymap.set('n', 'go', telescope.lsp_type_definitions, { buffer = bufnr, desc = 'Go to type definition' })

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = '[G]o to [D]eclaration' })

  vim.keymap.set('n', 'gi', telescope.lsp_implementations, { buffer = bufnr, desc = '[G]o to [I]mplementation' })
end

local function add_to_avante(filepath)
  -- Convert to relative path as needed
  local relative_path = require('avante.utils').relative_path(filepath)

  -- Get the Avante sidebar
  local sidebar = require('avante').get()

  local was_closed = not sidebar:is_open()
  -- Ensure Avante sidebar is open
  if was_closed then
    require('avante.api').ask()
    sidebar = require('avante').get()
  end

  -- Add the file to Avante
  sidebar.file_selector:add_selected_file(relative_path)

  -- Notify the user
  vim.notify('Added ' .. relative_path .. ' to Avante', vim.log.levels.INFO)
end

local function format_path(filepath)
  local cwd = vim.fs.normalize(vim.fn.getcwd(), { _fast = true, expand_env = false })
  local home = vim.fs.normalize('~')
  local path = vim.fs.normalize(filepath, { _fast = true, expand_env = false })

  if path:find(cwd .. '/', 1, true) == 1 and #path > #cwd then
    path = path:sub(#cwd + 2)
  else
    local root = require('snacks').git.get_root(path)
    if root and root ~= '' and path:find(root, 1, true) == 1 then
      local tail = vim.fn.fnamemodify(root, ':t')
      path = '⋮' .. tail .. '/' .. path:sub(#root + 2)
    elseif path:find(home, 1, true) == 1 then
      path = '~' .. path:sub(#home + 1)
    end
  end
  path = path:gsub('/$', '')
  return path
end

function M.setup_avante_lsp_keymaps(bufnr)
  vim.keymap.set('n', 'ga', function()
    vim.lsp.buf.definition({
      on_list = function(options)
        if not options or not options.items or #options.items == 0 then
          vim.notify('No definition found', vim.log.levels.WARN)
          return
        end

        -- Get the first definition location
        local item = options.items[1]
        local filepath = item.filename or item.uri

        -- Convert URI to file path if needed
        if filepath:match('^file://') then
          filepath = filepath:gsub('^file://', '')
          -- Handle URL encoding
          filepath = filepath:gsub('%%(%x%x)', function(h)
            return string.char(tonumber(h, 16))
          end)
        end

        local formated = format_path(filepath)
        -- Add the definition file to Avante
        add_to_avante(formated)
      end,
    })
  end, { buffer = bufnr, desc = '[G]rab [A]vante ' })
end

return M
