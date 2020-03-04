#!/bin/bash

if [ $EUID != 0 ]; then
    echo "Please run command with sudo!"
    exit 1
fi

# if sudoer, set user/home
USER=${SUDO_USER:-$USER}
HOME=$(eval echo ~$USER)

apt update && apt upgrade -y

apt install software-properties-common -y

add-apt-repository -y -u \
	ppa:mmstick76/alacritty

add-apt-repository -y -u \
	ppa:neovim-ppa/stable

apt update

apt install -y \
	zsh \
	neovim \
	curl \
	alacritty \
	git \
	docker.io \
	jq \
	stow \
	wget \
	tree \
	nodejs \
	npm

# Add user to docker group
if [[ -v $USER ]]; then
	su - $USER -c "usermod -aG docker $USER"
	su - $USER -c "newgrp docker"
fi

# install go
# this will not work if snap doesn't exist ;) 
# this install is broken af, install it yourself
# snap install --classic go

# install tmux
snap install tmux --classic

# kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

# fzf
su - $USER -c "git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf"
# we don't install zsh completions because this is preconfigured in our setup.sh
su - $USER -c "$HOME/.fzf/install --all --no-zsh"

# yarn
npm install -g yarn

# change user shell to ZSH
chsh -s $(which zsh) $USER
