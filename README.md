# dotfiles

A collection of my dotfiles for macos. This is a work in progress.

## prereqs

- `brew install stow`
- `brew install nvim`
- `brew tap homebrew/cask-fonts`
- `brew install --cask font-fira-code-nerd-font`
    - set your iterm2 font to the one above
- `brew install ripgrep`
    - this is for telescope find grep fuzzy searching
- `brew install lazygit`

## installing

from the this repo's root run:
- `stow nvim`
- open nvim and run `PackerSync`

## todo

- [ ] pair down the golang-ci linters to the bare minimum.
- [ ] add functionality to run specific tests under cursor (vim-go?)
- [ ] add mysql lsp
- [ ] add svelte lsp (and generic js?)
- [ ] add tailwind lsp
- [ ] add bash lsp + linting support
- [ ] add markdown previewing (glow?)
- [ ] add cheatsheet file
- [ ] add git config template
- [ ] add tmux config
