# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/vi-mode/vi-mode.plugin.zsh
typeset -g VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
# Control whether to change the cursor style on mode change.
#
# Set to "true" to change the cursor on each mode change.
# Unset or set to any other value to do the opposite.
typeset -g VI_MODE_SET_CURSOR=true

# Control how the cursor appears in the various vim modes. This only applies
# if $VI_MODE_SET_CURSOR=true.
#
# See https://vt100.net/docs/vt510-rm/DECSCUSR for cursor styles
typeset -g VI_MODE_CURSOR_NORMAL=${VI_MODE_CURSOR_NORMAL:=2}
typeset -g VI_MODE_CURSOR_VISUAL=${VI_MODE_CURSOR_VISUAL:=6}
typeset -g VI_MODE_CURSOR_INSERT=${VI_MODE_CURSOR_INSERT:=6}
typeset -g VI_MODE_CURSOR_OPPEND=${VI_MODE_CURSOR_OPPEND:=0}

typeset -g VI_KEYMAP=${VI_KEYMAP:=main}

function _vi-mode-set-cursor-shape-for-keymap() {
  [[ "$VI_MODE_SET_CURSOR" = true ]] || return

  # https://vt100.net/docs/vt510-rm/DECSCUSR
  local _shape=0
  case "${1:-${VI_KEYMAP:-main}}" in
    main)    _shape=$VI_MODE_CURSOR_INSERT ;; # vi insert: line
    viins)   _shape=$VI_MODE_CURSOR_INSERT ;; # vi insert: line
    isearch) _shape=$VI_MODE_CURSOR_INSERT ;; # inc search: line
    command) _shape=$VI_MODE_CURSOR_INSERT ;; # read a command name
    vicmd)   _shape=$VI_MODE_CURSOR_NORMAL ;; # vi cmd: block
    visual)  _shape=$VI_MODE_CURSOR_VISUAL ;; # vi visual mode: block
    viopp)   _shape=$VI_MODE_CURSOR_OPPEND ;; # vi operation pending: blinking block
    *)       _shape=0 ;;
  esac
  printf $'\e[%d q' "${_shape}"
}

function _visual-mode {
  typeset -g VI_KEYMAP=visual
  _vi-mode-set-cursor-shape-for-keymap "$VI_KEYMAP"
  zle .visual-mode
}
zle -N visual-mode _visual-mode

function _vi-mode-should-reset-prompt() {
  # If $VI_MODE_RESET_PROMPT_ON_MODE_CHANGE is unset (default), dynamically
  # check whether we're using the prompt to display vi-mode info
  if [[ -z "${VI_MODE_RESET_PROMPT_ON_MODE_CHANGE:-}" ]]; then
    [[ "${PS1} ${RPS1}" = *'$(vi_mode_prompt_info)'* ]]
    return $?
  fi

  # If $VI_MODE_RESET_PROMPT_ON_MODE_CHANGE was manually set, let's check
  # if it was specifically set to true or it was disabled with any other value
  [[ "${VI_MODE_RESET_PROMPT_ON_MODE_CHANGE}" = true ]]
}

# Updates editor information when the keymap changes.
function zle-keymap-select() {
  # update keymap variable for the prompt
  typeset -g VI_KEYMAP=$KEYMAP

  if _vi-mode-should-reset-prompt; then
    zle reset-prompt
    zle -R
  fi
  _vi-mode-set-cursor-shape-for-keymap "${VI_KEYMAP}"
}
zle -N zle-keymap-select

# These "echoti" statements were originally set in lib/key-bindings.zsh
# Not sure the best way to extend without overriding.
function zle-line-init() {
  local prev_vi_keymap="${VI_KEYMAP:-}"
  typeset -g VI_KEYMAP=main
  [[ "$prev_vi_keymap" != 'main' ]] && _vi-mode-should-reset-prompt && zle reset-prompt
  (( ! ${+terminfo[smkx]} )) || echoti smkx
  _vi-mode-set-cursor-shape-for-keymap "${VI_KEYMAP}"
}
zle -N zle-line-init

function zle-line-finish() {
  typeset -g VI_KEYMAP=main
  (( ! ${+terminfo[rmkx]} )) || echoti rmkx
  _vi-mode-set-cursor-shape-for-keymap default
}
zle -N zle-line-finish

bindkey -v
