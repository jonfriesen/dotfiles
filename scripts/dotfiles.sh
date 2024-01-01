#!/bin/zsh

SESSIONNAME="dotfiles"
echo -ne "\033]0;"⚙️	 $SESSIONNAME"\007"
printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "$SESSIONNAME" | base64)

tmux has-session -t $SESSIONNAME &> /dev/null
if [ $? != 0 ]
 then
	tmux new-session -s $SESSIONNAME -d
	tmux send-keys -t $SESSIONNAME "~/dotfiles; hx ." C-m
	tmux split-window -v
	tmux resize-pane -D 10
	tmux send-keys -t $SESSIONNAME "~/dotfiles; clear" C-m
	tmux select-pane -t 1
fi

tmux attach -t $SESSIONNAME
