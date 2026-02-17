# tree stuff
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"

# lazy
alias lg="lazygit"
alias ldg="lazydocker"

# git
alias gcom="git commit -m"

# frequent access
alias code_file="z ~/Desktop/code"
alias obs_file="z ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/jojo-vault/"
alias SHUFFLE="z ~/Desktop/code/orgs/shuffle"
alias J2="z ~/Desktop/code/J2"
alias claude_config="cd ~/Library/Application\ Support/Claude"

# for configs 
alias MYZSHRC="nvim ~/.config/zsh/.zshrc"
alias MYZSHENV="nvim ~/.zshenv"
alias MYZSHPROFILE="nvim ~/.zprofile"

# for brew x86_64
alias brew86="arch -x86_64 /usr/local/bin/brew"
alias love="/Applications/love.app/Contents/MacOS/love"

# for tmux
alias tmux-attach="tmux a -t"

#for randomized opencode port
alias oc="opencode --port $(jot -r 1 4096 65000)"
