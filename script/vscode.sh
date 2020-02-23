#!/bin/bash

if [ $EUID != 0 ]; then
    echo "Please run command with sudo!"
    exit 1
fi

wget https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable -O /tmp/code_latest_amd64.deb
dpkg -i /tmp/code_latest_amd64.deb
