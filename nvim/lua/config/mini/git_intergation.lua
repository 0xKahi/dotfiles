local M = {}

-- Cache for git status
M.gitStatusCache = {}
local cacheTimeout = 2000 -- Cache timeout in milliseconds

-- Create namespace once, outside of any function
local nsMiniFiles = vim.api.nvim_create_namespace('mini_files_git')

-- Function to map Git status to symbols and highlight groups
function M.mapSymbols(status)
  local statusMap = {
    ['M '] = { symbol = '', hlGroup = 'MiniDiffSignAdd' }, -- modified in index
    ['MM'] = { symbol = '', hlGroup = 'MiniDiffSignChange' }, -- modified in both working tree and index
    ['AM'] = { symbol = '', hlGroup = 'MiniDiffSignChange' }, -- added in working tree, modified in index

    ['A '] = { symbol = '', hlGroup = 'MiniDiffSignAdd' }, -- Added to the staging area, new file
    ['AA'] = { symbol = '', hlGroup = 'MiniDiffSignAdd' }, -- file is added in both working tree and index
    ['D '] = { symbol = '', hlGroup = 'MiniDiffSignDelete' }, -- Deleted from the staging area
    ['AD'] = { symbol = '', hlGroup = 'MiniDiffSignDelete' }, -- Added in the index and deleted in the working directory

    [' M'] = { symbol = '󱔢 ', hlGroup = 'MiniDiffSignAdd' }, -- Modified in the working directory
    ['??'] = { symbol = '󱔢 ', hlGroup = 'MiniDiffSignAdd' }, -- Untracked files
    ['!!'] = { symbol = '', hlGroup = 'MiniDiffSignIgnored' }, -- Ignored files
    ['R '] = { symbol = '', hlGroup = 'MiniDiffSignChange' }, -- Renamed in the index

    ['U '] = { symbol = '‖', hlGroup = 'MiniDiffSignChange' }, -- Unmerged path
    ['UU'] = { symbol = '⇄', hlGroup = 'MiniDiffSignAdd' }, -- file is unmerged
    ['UA'] = { symbol = '⊕', hlGroup = 'MiniDiffSignAdd' }, -- file is unmerged and added in working tree
  }

  local result = statusMap[status] or { symbol = '?', hlGroup = 'NonText' }
  return result.symbol, result.hlGroup
end

-- Function to fetch Git status
function M.fetchGitStatus(cwd, callback)
  local function on_exit(content)
    if content.code == 0 then
      callback(content.stdout)
    end
  end
  vim.system({ 'git', 'status', '--ignored', '--porcelain' }, { text = true, cwd = cwd }, on_exit)
end

-- Function to parse Git status
function M.parseGitStatus(content)
  local gitStatusMap = {}
  for line in content:gmatch('[^\r\n]+') do
    local status, filePath = string.match(line, '^(..)%s+(.*)')
    local parts = {}
    for part in filePath:gmatch('[^/]+') do
      table.insert(parts, part)
    end
    local currentKey = ''
    for i, part in ipairs(parts) do
      if i > 1 then
        currentKey = currentKey .. '/' .. part
      else
        currentKey = part
      end
      if i == #parts then
        gitStatusMap[currentKey] = status
      else
        if not gitStatusMap[currentKey] and status ~= '!!' then --idw gitignore colours and file icons going up teh tree
          gitStatusMap[currentKey] = status
        end
      end
    end
  end
  return gitStatusMap
end

-- Function to update mini.files with Git status
function M.updateMiniWithGit(buf_id, gitStatusMap)
  vim.schedule(function()
    if not vim.api.nvim_buf_is_valid(buf_id) then
      return
    end
    local nlines = vim.api.nvim_buf_line_count(buf_id)
    local cwd = vim.fn.getcwd()
    local escapedcwd = M.escapePattern(cwd)
    if vim.fn.has('win32') == 1 then
      escapedcwd = escapedcwd:gsub('\\', '/')
    end

    for i = 1, nlines do
      local entry = require('mini.files').get_fs_entry(buf_id, i)
      if not entry then
        break
      end
      local relativePath = entry.path:gsub('^' .. escapedcwd .. '/', '')
      local status = gitStatusMap[relativePath]

      if status then
        local symbol, hlGroup = M.mapSymbols(status)
        local line = vim.api.nvim_buf_get_lines(buf_id, i - 1, i, false)[1]
        local name_start = line:find('%S[^%s]*$') -- Find start of the last word (filename/foldername)
        local name = line:sub(name_start)

        -- Clear previous extmarks
        vim.api.nvim_buf_clear_namespace(buf_id, nsMiniFiles, i - 1, i)

        -- Highlight filename/foldername
        vim.api.nvim_buf_add_highlight(buf_id, nsMiniFiles, hlGroup, i - 1, name_start - 1, -1)

        -- Add git symbol to the right
        vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
          virt_text = { { symbol, hlGroup } },
          virt_text_pos = 'eol',
          priority = 2,
        })
      end
    end
  end)
end

-- Helper function to escape pattern
function M.escapePattern(str)
  return str:gsub('([%^%$%(%)%%%.%[%]%*%+%-%?])', '%%%1')
end

-- Function to check if current directory is a valid Git repo
function M.is_valid_git_repo()
  return vim.fn.isdirectory('.git') == 1
end

-- Main function to update Git status
function M.updateGitStatus(buf_id)
  if not M.is_valid_git_repo() then
    return
  end
  local cwd = vim.fn.expand('%:p:h')
  local currentTime = os.time()
  if M.gitStatusCache[cwd] and currentTime - M.gitStatusCache[cwd].time < cacheTimeout then
    M.updateMiniWithGit(buf_id, M.gitStatusCache[cwd].statusMap)
  else
    M.fetchGitStatus(cwd, function(content)
      local gitStatusMap = M.parseGitStatus(content)
      M.gitStatusCache[cwd] = {
        time = currentTime,
        statusMap = gitStatusMap,
      }
      M.updateMiniWithGit(buf_id, gitStatusMap)
    end)
  end
end

-- Function to clear the Git status cache
function M.clearCache()
  M.gitStatusCache = {}
end

-- Function to set up autocommands
function M.setup_autocommands()
  local function augroup(name)
    return vim.api.nvim_create_augroup('MiniFiles_' .. name, { clear = true })
  end

  vim.api.nvim_create_autocmd('User', {
    group = augroup('start'),
    pattern = 'MiniFilesExplorerOpen',
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      M.updateGitStatus(bufnr)
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    group = augroup('close'),
    pattern = 'MiniFilesExplorerClose',
    callback = function()
      M.clearCache()
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    group = augroup('update'),
    pattern = 'MiniFilesBufferUpdate',
    callback = function(sii)
      local bufnr = sii.data.buf_id
      local cwd = vim.fn.expand('%:p:h')
      if M.gitStatusCache[cwd] then
        M.updateMiniWithGit(bufnr, M.gitStatusCache[cwd].statusMap)
      end
    end,
  })
end

return M
