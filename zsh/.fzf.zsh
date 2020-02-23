# Setup fzf
# ---------
if [[ ! "$PATH" == */home/jon/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/jon/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/jon/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/jon/.fzf/shell/key-bindings.zsh"
