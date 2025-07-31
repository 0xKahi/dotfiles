return {
  'cousine/opencode-context.nvim',
  opts = {
    tmux_target = nil, -- Manual override: "session:window.pane"
    auto_detect_pane = true, -- Auto-detect opencode pane in current window
  },
  keys = {
    {
      '<leader>oc',
      '<cmd>OpencodeSend<cr>',
      { mode = { 'n', 'v' }, desc = '[O]pen [C]ode' },
    },
  },
  cmd = { 'OpencodeSend' },
}
