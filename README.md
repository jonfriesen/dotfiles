# dotfiles

A collection of my dotfiles for macos. This is a work in progress.

## prereqs

### neovim
- `brew install stow`
- `brew install nvim`
- `brew tap homebrew/cask-fonts`
- `brew install --cask font-fira-code-nerd-font`
    - set your iterm2 font to the one above
- `brew install ripgrep`
    - this is for telescope find grep fuzzy searching
- `brew install lazygit`

### tmux
- `brew install tmux reattach-to-user-namespace`
- install tpm
    - `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`

## installing

from the this repo's root run:
- `stow nvim`
- `stow tmux`
- install packer plugins `nvim +PackerSync`
- install tmux tmux plugins
    - `<prefix>+I` (note: default prefix in this config is `<C-a>`)
- add the following line to the ~/.zprofile
	- `alias tenv='~/dotfiles/scripts/_init.sh`

## notes

- I think mason-lspconfig _should_ install the ensured lsp servers though I'm not totally confident on that. 
- I'm not sure the `sqlls` lsp is working.

### iterm2 configs
There's lots missing here...

- Making alt + left/right error jump characters in iterm2 and tmux
	- Preferences > Profile > Keys > Key Mappings
	- Update alt + < to *Action: Esc Key* and character to send to `b`
	- Update alt + > to *Action: Esc Key* and character to send to `f`

## todo

- [ ] pair down the golang-ci linters to the bare minimum.
- [ ] add functionality to run specific tests under cursor (vim-go?)
- [ ] add markdown previewing (glow?)
- [ ] add cheatsheet file
- [ ] add git config template
- [ ] script the brew commands above
- [ ] add + configure floaterm
