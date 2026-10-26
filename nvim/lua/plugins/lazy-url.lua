return {
  '0xKahi/lazy-url.nvim',
  -- dir = '/Users/kahi/Desktop/code/plugins/neovim/lazy-url.nvim',
  keys = {
    {
      '<leader>ou',
      function()
        require('lazy-url').smart_open()
      end,
      desc = '[O]pen [U]rl',
      silent = false,
      noremap = true,
      mode = { 'n', 'v' },
    },
  },
  opts = {
    browsers = { 'default', 'arc' },
    custom = {
      {
        pattern = 'discord%.com', -- Lua pattern: matches any URL containing "discord.com"
        handler = function(url)
          return {
            cmd = 'open',
            args = { (url:gsub('https://', 'discord://')) },
          }
        end,
      },
      {
        pattern = 'slack%.com', -- matches app.slack.com / <workspace>.slack.com URLs
        handler = function(url)
          -- https://app.slack.com/client/<TEAM>/<CHANNEL> -> slack://channel?team=<TEAM>&id=<CHANNEL>
          local team, channel = url:match('app%.slack%.com/client/(T%w+)/([CDG]%w+)')
          if team and channel then
            return { cmd = 'open', args = { ('slack://channel?team=%s&id=%s'):format(team, channel) } }
          end
          -- https://<workspace>.slack.com/archives/<CHANNEL>/p<TS> -> slack://channel?team=..&id=..&message=<TS>
          local slack_teams = { shuffleorg = 'T03GF46KJHE' } -- workspace subdomain -> team id
          local workspace, chan, ts = url:match('://([%w%-]+)%.slack%.com/archives/([CDG]%w+)/?p?(%d*)')
          local team_id = workspace and slack_teams[workspace]
          if team_id then
            local deep_link = ('slack://channel?team=%s&id=%s'):format(team_id, chan)
            if ts and #ts > 6 then
              deep_link = deep_link .. '&message=' .. ts:sub(1, -7) .. '.' .. ts:sub(-6)
              local thread_ts = url:match('[?&]thread_ts=([%d%.]+)')
              if thread_ts then
                deep_link = deep_link .. '&thread_ts=' .. thread_ts
              end
            end
            return { cmd = 'open', args = { deep_link } }
          end
          -- unknown workspace: let the desktop app resolve it
          return { cmd = 'open', args = { '-a', 'Slack', url } }
        end,
      },
    },
  },
}
