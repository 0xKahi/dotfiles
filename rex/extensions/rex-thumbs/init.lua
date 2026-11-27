-- rex-thumbs: copy text from a Rex pane by its hint, like tmux-thumbs.
-- https://github.com/chaosteil/rex-thumbs
--
--   require('extensions.rex-thumbs').setup({ key = 'cmd+shift+f' })
--   require('extensions.rex-thumbs').setup({ key = 'cmd+shift+f', patterns = { 'JIRA%-%d+' } })
--
-- No key is bound unless `key` is given; the `thumbs` action is always registered.
---@class rex_thumbs
local M = {}

---@class rex_thumbs.pattern
---@field pat? string Lua pattern; two empty captures `()` select the part to copy
---@field token? string anchored pattern for one whole `[%w_]+` word, used instead of `pat`
---@field lit? string plain text every match contains; lines without it are skipped
---@field word? boolean match must not touch a word character on either side
---@field after? boolean match must not touch a word character on its right
---@field min? integer minimum length of the copied text
---@field max? integer maximum length of the copied text
---@field trim? boolean strip trailing whitespace and sentence punctuation
---@field bol? boolean match must start in column 1
---@field ext? string pattern that may follow the match, up to `ext_n` times
---@field ext_n? integer max repeats of `ext`
---@field ip? boolean each number has at most 3 digits

---@class rex_thumbs.opts
---@field key? string key that opens the picker, e.g. 'cmd+shift+f'; nil binds none
---@field alphabet? string hint letters in order of use, defaults to the tmux-thumbs qwerty alphabet
---@field patterns? (string|rex_thumbs.pattern)[] extra patterns; they win ties with the built-in ones

local here = debug.getinfo(1, 'S').source:gsub('^@', ''):match('^(.*)/') or '.'
local matcher = dofile(here .. '/matcher.lua')

local terminal = 'com.superlogical.terminal'
local shell = 'com.superlogical.terminal.shell'

local DIM, MATCH, HINT, RESET = '\27[0;2m', '\27[0;32m', '\27[0;1;30;43m', '\27[0m'

-- The picker pane. It shows each frame that Lua writes to $1, and sends
-- each key to the thumbs_key action. When Lua removes the frame file, or a
-- call fails, it puts the pane back where it was and stops. Its tab then
-- closes. It needs only sh, stty, dd, od, tr, and cat.
local picker_sh = [[
frame=$1 session=$2 pane=$3
rex=${REX_BIN_DIR:+$REX_BIN_DIR/}rex
stty raw -echo 2>/dev/null
cat "$frame" 2>/dev/null
while [ -f "$frame" ]; do
  code=$(dd bs=1 count=1 2>/dev/null | od -An -tu1 | tr -d ' \n')
  [ -n "$code" ] || break
  "$rex" do -s "$session" thumbs_key code="$code" >/dev/null 2>&1 || break
  cat "$frame" 2>/dev/null
done
cat "$frame.end" 2>/dev/null
rm -f "$frame" "$frame.end"
"$rex" swap -s "$session" "$REX_BLOCK" "$pane" >/dev/null 2>&1
"$rex" focus -s "$session" "$pane" >/dev/null 2>&1
exit 0]]

-- The open pickers, by the block ID of the picker pane.
local pickers = {}
local options = {}

-- The last lines of a terminal's text, enough for one screen. With
-- unwrap, Rex joins the rows that it wrapped, so each line is one line
-- that the program wrote. format drops blank lines at the bottom.
local function read_tail(block_id, size, unwrap)
  local r, err = rex.block.call(terminal, 'format', { block_id = block_id, max_bytes = 65536, unwrap = unwrap })
  if not r then
    error(err, 0)
  end
  local text = r.content
  if r.id then
    local offset = math.max(0, r.total - size.rows * (size.columns * 4 + 1))
    local parts = {}
    repeat
      local d
      d, err =
        rex.block.call(terminal, 'blob_read', { block_id = block_id, id = r.id, offset = offset, max_bytes = 983040 })
      if not d then
        error(err, 0)
      end
      parts[#parts + 1] = d.data
      offset = offset + #d.data
    until d.eof or d.data == ''
    text = table.concat(parts)
  end
  local all = {}
  for line in (text .. '\n'):gmatch('(.-)\n') do
    all[#all + 1] = line
  end
  return all
end

-- The rows on a terminal's screen, and the groups of rows that make one
-- line (see matcher.join). format has no screen-only option, so keep the
-- last `rows` rows. A cleared screen moves up.
local function screen(block_id)
  local size, err = rex.block.call(terminal, 'size', { block_id = block_id })
  if not size then
    error(err, 0)
  end
  local all = read_tail(block_id, size, false)
  local rows = {}
  for k = math.max(1, #all - size.rows + 1), #all do
    rows[#rows + 1] = all[k]
  end
  return rows, matcher.join(rows, read_tail(block_id, size, true))
end

-- The screen with the hints, as escape sequences. A hint covers the first
-- letters of its text. A match that wraps shows on each of its rows.
-- Hints that don't start with `typed` go dim.
local function render(st)
  local by_row = {}
  for _, p in ipairs(st.spans) do
    by_row[p[1]] = by_row[p[1]] or {}
    table.insert(by_row[p[1]], p)
  end
  local out = { '\27[?25l\27[?7l\27[H\27[2J' }
  for row, line in ipairs(st.lines) do
    out[#out + 1] = '\27[' .. row .. ';1H'
    local spans = by_row[row] or {}
    table.sort(spans, function(a, b)
      return a[2] < b[2]
    end)
    local col = 1
    for _, p in ipairs(spans) do
      local hint = p[4][5]
      out[#out + 1] = DIM .. line:sub(col, p[2] - 1)
      if hint:sub(1, #st.typed) ~= st.typed then
        out[#out + 1] = DIM .. line:sub(p[2], p[3])
      elseif p[5] then
        local rest = hint:sub(#st.typed + 1)
        out[#out + 1] = HINT .. rest .. MATCH .. line:sub(p[2] + #rest, p[3])
      else
        out[#out + 1] = MATCH .. line:sub(p[2], p[3])
      end
      col = p[3] + 1
    end
    out[#out + 1] = DIM .. line:sub(col) .. RESET
  end
  return table.concat(out)
end

local function write_file(path, data)
  local f = assert(io.open(path, 'w'))
  f:write(data)
  f:close()
end

local b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function base64(s)
  local out = {}
  for i = 1, #s, 3 do
    local a, b, c = s:byte(i, i + 2)
    local n = a * 65536 + (b or 0) * 256 + (c or 0)
    local chars = {}
    for k = 3, 0, -1 do
      local v = math.floor(n / 64 ^ k) % 64
      chars[#chars + 1] = b64:sub(v + 1, v + 1)
    end
    if not b then
      chars[3] = '='
    end
    if not c then
      chars[4] = '='
    end
    out[#out + 1] = table.concat(chars)
  end
  return table.concat(out)
end

-- Copy with pbcopy when the server has it. Else the picker pane sends
-- OSC 52 as it closes, and the Rex app puts the text on its clipboard.
-- With osc52 set (a remote session, see open_remote), skip pbcopy: it would
-- copy to the clipboard of the host that runs the pane, not the app's.
local function copy(st, text)
  local r = not st.osc52 and rex.exec({ 'pbcopy' }, { stdin = text, timeout = 5 })
  if not (r and r.ok) then
    write_file(st.frame .. '.end', '\27]52;c;' .. base64(text) .. '\7')
  end
end

-- Type text into the pane. Use a bracketed paste when the program in the
-- pane asked for one, so that a shell doesn't run a line on its own.
local function paste(st, text)
  local modes = rex.block.call(terminal, 'modes', { block_id = st.pane })
  for _, m in ipairs(modes and modes.modes or {}) do
    if m.number == 2004 and m.set then
      text = '\27[200~' .. text .. '\27[201~'
      break
    end
  end
  rex.block.call(terminal, 'write', { block_id = st.pane, data = text })
end

-- Stop a picker. The picker pane sees that its frame file is gone, puts
-- the pane back, and closes.
local function finish(picker, text, upper)
  local st = pickers[picker]
  pickers[picker] = nil
  if text then
    copy(st, text)
    if upper then
      paste(st, text)
    end
  end
  os.remove(st.frame)
  return { text = text, pasted = upper and text ~= nil or false }
end

-- Start the picker in a background tab, then swap it into the place of the
-- pane, as tmux-thumbs does with swap-pane. The picker pane then has the
-- size of the pane, so the hints sit on the text.
-- A session on another host: this action runs on the app's home server, but
-- the picker pane runs on ctx.server. The frame file, the pickers table, and
-- the picker's `rex do thumbs_key` calls must all be on the picker's server,
-- so run the whole thumbs action there. client.action goes to ctx.server.
local function open_remote(ctx)
  local res, err = rex.call('client.action', {
    action = 'thumbs',
    session_id = ctx.session_id,
    block_id = ctx.block_id,
    args = { osc52 = true },
  })
  if not res then
    error(('rex-thumbs: thumbs on %s failed: %s'):format(ctx.server, tostring(err)), 0)
  end
  return res
end

local function open(ctx, args)
  if ctx.server then
    return open_remote(ctx)
  end
  local pane = ctx.block_id
  if not pane then
    error('no pane has focus', 0)
  end
  if pickers[pane] then
    -- The key again, from inside the picker: stop it, as Esc does.
    rex.block.call(terminal, 'write', { block_id = pane, data = '\27' })
    return nil
  end
  local rows, groups = screen(pane)
  local texts, from = {}, {}
  for k, g in ipairs(groups) do
    texts[k], from[k] = g.text, g.at[1]
  end
  local marks = matcher.assign(texts, options.patterns, options.alphabet, from)
  if #marks == 0 then
    return { matches = 0 }
  end

  local st = {
    pane = pane,
    lines = rows,
    marks = marks,
    spans = matcher.spans(groups, marks),
    typed = '',
    frame = os.tmpname(),
    osc52 = args and args.osc52 or false,
  }
  write_file(st.frame, render(st))
  local w, err = rex.session.new_window({
    window_label = 'thumbs',
    focus = false,
    layout = rex.layout.block({
      flavor = shell,
      label = 'rex-thumbs',
      options = {
        shell = 'none',
        command = { '/bin/sh', '-c', picker_sh, 'rex-thumbs', st.frame, ctx.session_id, pane },
      },
    }),
  })
  if not w then
    os.remove(st.frame)
    error(err, 0)
  end
  local picker = w.block_ids[1]
  local _, swap_err = rex.session.swap_blocks({ block_id = pane, other_block_id = picker })
  if swap_err ~= nil then
    os.remove(st.frame)
    rex.session.close_window({ window_id = w.window_id })
    error(swap_err, 0)
  end
  pickers[picker] = st
  rex.session.focus_block({ block_id = picker })
  return { matches = #marks, picker = picker }
end

-- One key in the picker, as a byte. A lowercase hint copies its text. An
-- uppercase hint also types it into the pane.
local function key(ctx, args)
  local picker = ctx.block_id
  local st = picker and pickers[picker]
  if not st then
    error('no rex-thumbs picker in this pane', 0)
  end
  local code = tonumber(args.code) or 0
  local ch = string.char(code % 256)
  if code == 27 or code == 3 or code == 7 then
    return finish(picker)
  end
  if code == 127 or code == 8 then
    st.typed = st.typed:sub(1, -2)
    if st.typed == '' then
      st.upper = false
    end
  else
    local lower = ch:lower()
    if not (options.alphabet or matcher.ALPHABET):find(lower, 1, true) then
      return {}
    end
    if st.typed == '' then
      st.upper = ch ~= lower
    end
    local typed = st.typed .. lower
    local hit, prefix = nil, false
    for _, m in ipairs(st.marks) do
      if m[5] == typed then
        hit = m[4]
      end
      if m[5]:sub(1, #typed) == typed then
        prefix = true
      end
    end
    if hit then
      return finish(picker, hit, st.upper or ch ~= lower)
    end
    if prefix then
      st.typed = typed
    end
  end
  write_file(st.frame, render(st))
  return {}
end

--- Register the `thumbs` action and bind `opts.key` to it.
---@param opts? rex_thumbs.opts
function M.setup(opts)
  opts = opts or {}
  options.alphabet = opts.alphabet and opts.alphabet:lower() or nil
  options.patterns = matcher.compile(opts.patterns)

  rex.action({
    name = 'thumbs',
    title = 'Copy Text With Hints',
    description = 'Puts a hint on each URL, path, and hash on the screen. Type a hint to copy its text, or Shift and the hint to also type it into the pane.',
    category = 'Pane',
    keywords = 'thumbs hints tmux-thumbs fingers url path hash copy paste',
    args = { osc52 = 'boolean?' },
    run = open,
  })
  rex.action({
    name = 'thumbs_key',
    title = 'rex-thumbs: Key (internal)',
    description = 'Used by the rex-thumbs picker pane.',
    category = 'Pane',
    args = { code = 'integer' },
    run = key,
  })

  if opts.key then
    rex.bind(opts.key, 'thumbs')
  end
end

return M
