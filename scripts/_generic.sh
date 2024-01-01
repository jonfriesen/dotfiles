#!/bin/zsh

# This is my preferred generic setup and will be used for one off envs.
# Pass in a directory.

# Check if a directory path was passed as a parameter
if [[ -z "$1" ]]; then
    echo "Error: Please provide a directory path as a parameter."
    exit 1
fi

# Assign the passed directory path to a variable
dir=$1

# Check if the provided path is a valid directory
if [[ ! -d $dir ]]; then
    echo "Error: The provided path is not a valid directory."
    exit 1
fi

# Create a variable with the root directory name
root_dir=$(basename $dir)

SESSIONNAME="$root_dir"
echo -ne "\033]0;"$SESSIONNAME"\007"
printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "$SESSIONNAME" | base64)

tmux has-session -t $SESSIONNAME &> /dev/null
if [ $? != 0 ]
 then
	tmux new-session -s $SESSIONNAME -d
	tmux send-keys -t $SESSIONNAME "cd $dir; hx ." C-m
	tmux split-window -v
	tmux resize-pane -D 10
	tmux send-keys -t $SESSIONNAME "cd $dir; clear" C-m
	tmux select-pane -t 1
fi

tmux attach -t $SESSIONNAME
