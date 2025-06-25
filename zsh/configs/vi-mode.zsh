bindkey -v
bindkey -M viins 'kj' vi-cmd-mode
export KEYTIMEOUT=10 # Makes switching modes quicker (should set to 1 but idk why my mac is slow)
export VI_MODE_SET_CURSOR=true 

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne '\e[1 q' # block
  else
    echo -ne '\e[5 q' # beam
  fi
}

zle -N zle-keymap-select

zle-line-init() {
  zle -K viins # initiate 'vi insert' as keymap (can be removed if 'binkey -V has been set elsewhere')
  echo -ne '\e[5 q'
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup


# Yank to the system clipboard
function vi-yank-xclip {
  zle vi-yank
  echo "$CUTBUFFER" | pbcopy -i
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip
