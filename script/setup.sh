#!/bin/sh

# vim: ft=sh

cd ~/.dotfiles

# Bootstrap oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
  git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  mkdir -p ~/.oh-my-zsh/custom/plugins
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
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

for i in git nvim zsh alacritty ; do
  stow $i
done

# Install vim plugins
nvim +PlugInstall +qall
