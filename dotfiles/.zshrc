plugins=(git tmux encode64 extract pip python sublime sudo urltools z)

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="$HOME/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

# Aliases
alias clr='clear'
alias find='fd'
alias gad='git add'
alias gcm='git commit'
alias gpl='git pull'
alias gps='git push'
alias gst='git status'
alias l='exa -lgh --git'
alias ll='exa -lagh --git'
alias llt='exa -laTgh --git'
alias lt='exa -lTgh --git'
