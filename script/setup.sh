#!/bin/sh

# vim: ft=sh

cd ~/.dotfiles

# Bootstrap oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
  git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

if [ ! -d ~/.config/alacritty ]; then
  mkdir -p ~/.config/alacritty
fi

# Bootstrap vim-plug
if [ ! -d ~/.config/nvim/autoload ]; then
  mkdir -p ~/.config/nvim/{autoload,plugged}
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Remove file created by strap
rm -rf ~/.gitconfig

for i in git nvim zsh; do
  stow $i
done
