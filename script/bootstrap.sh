#!/bin/bash

apt update && apt upgrade -y

apt install software-properties-common -y

add-apt-repository ppa:mmstick76/alacritty -y

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
	usermod -aG docker $USER
	newgrp docker
fi

# install go
# this will not work if snap doesn't exist ;) 
snap install --classic go

# kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# we don't install zsh because this is preconfigured in our setup.sh
~/.fzf/install --all --no-zsh

# yarn
npm install -g yarn