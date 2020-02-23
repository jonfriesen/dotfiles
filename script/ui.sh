#!/bin/bash

# if sudoer, set user/home
USER=${SUDO_USER:-$USER}
HOME=$(eval echo ~$USER)

# Get Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb

# Spotify
snap install spotify

# vscode (this should probably check if xserver or something is installed)
wget https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable -O /tmp/code_latest_amd64.deb
dpkg -i /tmp/code_latest_amd64.deb

# Add VS Code extensions
su - $USER -c "code --install-extension CoenraadS.bracket-pair-colorizer-2"
su - $USER -c "code --install-extension ms-azuretools.vscode-docker"
su - $USER -c "code --install-extension dracula-theme.theme-dracula"
su - $USER -c "code --install-extension usernamehw.errorlens"
su - $USER -c "code --install-extension dbaeumer.vscode-eslint"
su - $USER -c "code --install-extension eamodio.gitlens"
su - $USER -c "code --install-extension ms-vscode.Go"
su - $USER -c "code --install-extension shyykoserhiy.vscode-spotify"
su - $USER -c "code --install-extension redhat.vscode-yaml"
