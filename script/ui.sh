#!/bin/bash

# Get Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb

# Spotify
snap install spotify

# vscode (this should probably check if xserver or something is installed)
. ./vscode.sh
apt install code-insiders -y

# Add VS Code extensions
code-insiders --install-extension CoenraadS.bracket-pair-colorizer-2
code-insiders --install-extension ms-azuretools.vscode-docker
code-insiders --install-extension dracula-theme.theme-dracula
code-insiders --install-extension usernamehw.errorlens
code-insiders --install-extension dbaeumer.vscode-eslint
code-insiders --install-extension eamodio.gitlens
code-insiders --install-extension ms-vscode.Go
code-insiders --install-extension shyykoserhiy.vscode-spotify
code-insiders --install-extension redhat.vscode-yaml