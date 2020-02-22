#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo add-apt-repository ppa:mmstick76/alacritty -y

sudo apt install \
	curl \
	alacritty \
	git \
	docker.io \
	jq \
	stow \
	wget \
	tree \
	nodejs

# Add user to docker group
sudo usermod -aG docker $USER

# Get Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# install go
sudo snap install --classic go

# kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

#vscode (this should probably check if xserver or something is installed)
sudo ./vscode.sh