#!/bin/bash

if [ $EUID != 0 ]; then
    echo "Please run command with sudo!"
    exit 1
fi

wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O /tmp/code_latest_amd64.deb
dpkg -i /tmp/code_latest_amd64.deb
