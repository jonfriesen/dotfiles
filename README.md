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
- `stow tmux`
- install packer plugins `nvim +PackerSync`

## notes

- I think mason-lspconfig _should_ install the ensured lsp servers though I'm not totally confident on that. 
- I'm not sure the `sqlls` lsp is working.

## todo

- [ ] pair down the golang-ci linters to the bare minimum.
- [ ] add functionality to run specific tests under cursor (vim-go?)
- [ ] add markdown previewing (glow?)
- [ ] add cheatsheet file
- [ ] add git config template
- [ ] script the brew commands above
- [ ] add + configure floaterm
- [ ] document all the plugins
- [ ] replace tmux conf with tmux-sensible + dracula theme. inspo: [bashbunni/dotfiles/.tmux.conf](https://github.com/bashbunni/dotfiles/blob/mac/.tmux.conf)
