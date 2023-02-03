#!/bin/zsh

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

# Check if the directory contains a file called "buildpack.toml"
if [[ ! -f "$dir/buildpack.toml" ]]; then
    echo "Error: The directory does not appear to contain a buildpack."
    exit 1
fi

# Create a variable with the root directory name
root_dir=$(basename $dir)

SESSIONNAME="$root_dir"
echo -ne "\033]0;"📦 $SESSIONNAME"\007"

tmux has-session -t $SESSIONNAME &> /dev/null
if [ $? != 0 ]
 then
	tmux new-session -s $SESSIONNAME -d
	tmux send-keys -t $SESSIONNAME "cd $dir; nvim ." C-m
	tmux split-window -v
	tmux resize-pane -D 10
	tmux send-keys -t $SESSIONNAME "cd $dir; clear" C-m
	tmux select-pane -t 1
fi

tmux attach -t $SESSIONNAME
