#!/bin/bash

sudo apt update && upgrade -y

sudo add-apt-repository ppa:mmstick76/alacritty -y

sudo apt install \
	curl \
	alacritty \
	git \
	docker.io \

# Add user to docker group
sudo usermod -aG docker $USER

# Get Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
	

