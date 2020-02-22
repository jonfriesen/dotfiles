#!/bin/bash

# Get Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb

# vscode (this should probably check if xserver or something is installed)
# ./vscode.sh