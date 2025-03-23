export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="avit"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

export GOPATH=~/go
export GOBIN=~/go/bin
export PATH=$PATH:$(go env GOPATH)/bin
export CGO_ENABLED="0"

source <(fzf --zsh)

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
