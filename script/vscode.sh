#!/bin/bash
wget https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable -O /tmp/code_latest_amd64.deb
dpkg -i /tmp/code_latest_amd64.deb
