#!/bin/bash

# Get Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb

# Spotify
snap install spotify

# vscode (this should probably check if xserver or something is installed)
./vscode.sh
apt-get install code-insiders -y

# TODO add VS Code extensions
# code-insiders --install-extension ADD_EXTENSION_HERE