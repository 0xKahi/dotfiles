-- Pick a `keymaps.pulls.review` action and replay its configured buffer-local key.
-- `path` points to a nested table inside `review`, e.g. { 'view' }.
local function select_review_key(prompt, path, choices)
  vim.ui.select(choices, { prompt = prompt }, function(choice)
    if choice == nil then
      return
    end

    local keys = require('atlas.config').options.keymaps.pulls.review or {}
    for _, segment in ipairs(path) do
      keys = keys[segment] or {}
    end

    local key = keys[choice]
    if type(key) == 'table' then
      key = key[1]
    end
    if type(key) ~= 'string' then
      vim.notify('No keymap configured for ' .. choice, vim.log.levels.WARN)
      return
    end

    -- Replay once the picker has closed so the Atlas buffer mapping receives it.
    key = key:gsub('<[lL]eader>', vim.g.mapleader or '\\')
    vim.schedule(function()
      vim.api.nvim_feedkeys(vim.keycode(key), 'm', false)
    end)
  end)
end

return {
  'emrearmagan/atlas.nvim',
  dependencies = {
    'esmuellert/codediff.nvim', -- optional (PullRequest diff)
  },
  cmd = 'Atlas',
  keys = {
    {
      '<leader>pr',
      function()
        local choices = { 'browse', 'current PR' }
        vim.ui.select(choices, { prompt = 'Atlas' }, function(choice)
          if choice == nil then
            return
          end

          if choice == 'browse' then
            vim.cmd('Atlas pulls')
            return
          end

          vim.system({ 'gh', 'pr', 'view', '--json', 'url', '-q', '.url' }, { text = true }, function(res)
            vim.schedule(function()
              local url = vim.trim(res.stdout or '')
              if res.code ~= 0 or url == '' then
                vim.notify('No PR found for current branch: ' .. vim.trim(res.stderr or ''), vim.log.levels.WARN)
                return
              end
              vim.cmd('Atlas review ' .. url)
            end)
          end)
        end)
      end,
      { desc = '[P]ull [R]equest', silent = false, noremap = true },
      mode = { 'n' },
    },
  },
  opts = {
    ui = {
      -- Set either to false to keep your existing statusline.
      statusline = {
        atlas = true, -- Dashboards, details, and other non-diff Atlas views.
        diff = true, -- Diff and review views.
      },
      -- "auto", "default", "snacks", or "fzf-lua".
      picker = 'snacks',
      -- Make the main Atlas dashboard a listed buffer.
      listed_buffer = false,
    },

    providers = {
      github = {
        -- hostname = "github.company.com", -- Defaults to GH_HOST, then github.com.
        cache_ttl = 300, -- Set to 0 to disable caching.
      },
    },

    -- See Pulls Configuration below.
    pulls = {
      delete_notes = false, -- Delete notes after approval or merge.
      default_merge_method = 'squash', -- "merge" or "squash".
      default_delete_source_branch = false,
      git_transport = 'https', -- "https" or "ssh" for Atlas-managed Git remotes.

      description = {
        include_summary = true,
        include_commit_hashes = true,
        include_related = true,
        include_diffstat = false,
      },

      -- Replaces the built-in Conventional Comments templates.
      comment_templates = {
        insert_mode = true, -- Enter Insert mode after applying a template.
        items = {
          { label = 'Suggestion', text = 'suggestion: ' },
          { label = 'Issue', text = 'issue: ' },
          { label = 'Nitpick', text = 'nitpick: ' },
        },
      },

      diff = {
        -- "auto", or a command that accepts explicit <base>...<head> Git revisions.
        open_cmd = 'CodeDiff', -- CodeDiff, DiffviewOpen or AtlasDiff
        comment_display = 'virtual_lines', -- "virtual_lines" or compact "virtual_text" hints.
        review_panel = {
          hidden = true, -- Set false to show the review panel when a diff opens.
          height = 10,
        },

        -- AtlasDiff options; external viewers use their own configuration.
        layout = 'inline', -- "inline" or "side-by-side".
        compact = true, -- Start with only changed hunks and surrounding context visible.
        lsp = {
          -- Back the new side of the diff with a detached worktree at the PR head so it is made of
          -- real files and your language servers attach to it (AtlasDiff and CodeDiff). Off by default.
          enabled = true,
          -- Defaults to `stdpath("cache")/atlas/worktrees/<repo>/pr-<id>` (or `<repo>/<sha>` without a PR).
          -- May be an absolute path, or a function receiving
          -- { repo_root, repo_full_name, pr_id, head_sha, default } that returns a path or nil.
          dir = nil,
          -- Directories symlinked from your checkout into the worktree so servers can resolve
          -- dependencies. These are the same directories on disk, not copies.
          link = { 'node_modules', '.nvim', '.venv' }, -- e.g. { "node_modules", ".venv" }
        },
        explorer = {
          grouped = true, -- Group changed files by directory.
          hidden = false,
          show_commits = false, -- Set true to show commits below changed files initially.
          width = 40,
          initial_focus = 'explorer', -- "explorer" or "diff".
          preview = false, -- Show a file as soon as the explorer cursor moves onto it.
          focus_on_select = false, -- Move into the diff after selecting a file.
          ignore = { '.git/**', '.jj/**' },
        },
      },
      github = {
        views = {
          {
            name = 'Current',
            key = '1',
            layout = 'plain',
            current_repo = true, -- Limit this view to the local repository.
            search = 'state:open',
          },
          {
            name = 'My PRs',
            key = '2',
            layout = 'plain', -- "compact", "grouped", or "plain"
            -- current_repo = true, -- Limit this view to the local repository.
            search = 'author:@me sort:updated-desc',
          },
        },
      },
      repo_config = {},
      custom_actions = {}, -- See :help atlas-custom-actions.
    },

    -- See Issue Configuration below.
    issues = {},
    keymaps = {
      ui = {
        help = 'g?', -- { "g?", "<leader>?" } would add aliases
        close = 'q', -- false would disable it
        next_item = 'j',
        previous_item = 'k',
        previous_column = 'h',
        next_column = 'l',
        first_item = 'gg',
        last_item = 'G',
        select = '<CR>',
        submit = '<C-s>',
        delete = 'dd',
        comments = {
          add = { 'a', 'i' },
          reply = 'c',
          edit = 'e',
          react = 'gr',
        },
        toggle_panel = 'p',
        cycle_layout = 't',
        toggle_fold = 'za',
        toggle_all_folds = 'zA',
        toggle_description_mode = '<leader>m',
        previous_panel_tab = '<S-Tab>',
        next_panel_tab = '<Tab>',
        notifications = {
          open = 'N',
          mark_read = 'r',
          mark_done = 'd',
        },
        toggle_subscription = 'gS',
        toggle_star = '*',
        refresh = 'r',
        refresh_view = 'R',
        next_page = ']p',
        previous_page = '[p',
        open_actions = '<leader>a',
        open_in_browser = 'gx',
        open_references = 'gl',
        copy_id = 'y',
        copy_url = 'Y',
        show_details = 'K',
        search = '?',
        edit_search = 'i',
      },
      picker = {
        next_item = { '<Down>', '<C-n>', '<C-j>' },
        previous_item = { '<Up>', '<C-p>', '<C-k>' },
        select = { '<CR>', '<C-s>' },
        toggle = '<Tab>',
        close = { 'q', '<Esc>' },
      },
      issues = {
        transition_issue = 'gs',
        change_assignee = 'ga',
        change_reporter = 'gr',
        edit_issue = 'ge',
        create_issue = 'c',
      },
      pulls = {
        open_diff = 'gd',
        checkout = 'gc',
        open_repository = 'o',
        edit_pr = 'ge',
        review = {
          show_details = '<leader>sd', -- File/commit details.
          toggle_file_reviewed = '-',
          approve = '<leader>ga',
          request_changes = '<leader>gr',
          submit_review = '<leader>gs',
          add_task = '<leader>t',
          comment_templates = 'gT',
          toggle_resolved = 'x',
          next_comment = ']c',
          prev_comment = '[c',
          next_note = ']n',
          prev_note = '[n',
          add_comment = 'c',
          submit_comment = 'C',
          add_suggestion = 's',
          submit_suggestion = 'S',
          add_note = '<leader>n',
          view = {
            external_help = 'gA', -- External diff viewer help.
            toggle_review_panel = '<leader>vr', -- Also available via <leader>op menu.
            toggle_detail_panel = '<leader>vd', -- Also available via <leader>op menu.
            toggle_comments = 'gH',
          },
          explorer = {
            toggle_commits = 'gC',
            next_unreviewed_file = ']u',
            prev_unreviewed_file = '[u',
            find_file = '<leader>f',
          },
          -- Built-in navigation; external viewers use their own keys.
          atlas = {
            next_file = { ']f', '<Tab>' },
            prev_file = { '[f', '<S-Tab>' },
            toggle_explorer = '<leader>b',
            focus_explorer = '<leader>e',
            open_file = 'gf',
            toggle_view_mode = 'i',
            next_hunk = ']h',
            prev_hunk = '[h',
            toggle_layout = 't',
            toggle_compact = 'gc',
          },
        },
        pipelines = {
          next_job = { ']j', '<Tab>' },
          previous_job = { '[j', '<S-Tab>' },
          show_history = 'gH',
          toggle_raw_logs = 'gL',
          toggle_auto_refresh = 'gR',
        },
        filters = {
          open = 'gpo',
          merged = 'gpm',
          declined = 'gpd',
        },
        custom = {
          {
            key = '<leader>oa',
            desc = '[O]pen [A]ction',
            callback = function()
              select_review_key('Atlas review action', {}, { 'show_details', 'add_comment', 'add_suggestion' })
            end,
          },
          {
            key = '<leader>op',
            desc = '[O]pen [P]anel',
            callback = function()
              select_review_key(
                'Atlas panel',
                { 'view' },
                { 'external_help', 'toggle_review_panel', 'toggle_detail_panel', 'toggle_comments' }
              )
            end,
          },
        },
      },
    },
  },
}
