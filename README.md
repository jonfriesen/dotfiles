# dotfiles

A collection of my dotfiles for macos. This is a work in progress.

## install

- `brew install stow iterm2 zellij helix fzf`
- fonts
  - `brew tap homebrew/cask-fonts`
  - `brew install --cask font-fira-code-nerd-font`
- oh-my-zsh
  - `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- setup fzf
  - `source <(fzf --zsh)`

### hammerspoon

- `brew install hammerspoon`
- `defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"`

### iterm2

- set your iterm2 font to the one above

  There's lots missing here...

- Making alt + left/right error jump characters in iterm2 and tmux
  - Preferences > Profile > Keys > Key Mappings
  - Update alt + < to _Action: Esc Key_ and character to send to `b`
  - Update alt + > to _Action: Esc Key_ and character to send to `f`
