# dotfiles

On a fresh machine, run:
1. sudo ./script/bootstrap.sh
2. ./script/setup.sh

and if you have a UI
3. ./script/ui.sh

Run SUDO!!! [script/bootstrap.sh](https://github.com/jonfriesen/dotfiles/blob/master/script/bootstrap.sh) to configure an OS
Run NO SUDO!!! [script/setup.sh](https://github.com/jonfriesen/dotfiles/blob/master/script/setup.sh) to setup configs
Run SUDO!!! [script/ui.sh](https://github.com/jonfriesen/dotfiles/blob/master/script/ui.sh) to setup configs

Updating VSCode, us the UI or run this script:
Run [script/vscode.sh](https://github.com/jonfriesen/dotfiles/blob/master/script/vscode.sh) to update VS Code

## next steps

### Install Go
Gotta do this yourself from the golang.org

### Vim Language Service Config (CoC)

1. `vim +CocConfig`
2. Paste in:
```
{
  "languageserver": {
    "golang": {
      "command": "gopls",
      "rootPatterns": ["go.mod", ".vim/", ".git/", ".hg/"],
      "filetypes": ["go"]
    }
  }
}
```
3. Save

## Optional

### Audio Switcher
This is my prefered audio switcher:
```
 sudo apt-add-repository ppa:yktooo/ppa
 sudo apt update && sudo apt install indicator-sound-switcher
```
