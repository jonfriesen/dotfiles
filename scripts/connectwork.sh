#!/bin/zsh

SESSIONNAME="connectwork"
echo -ne "\033]0;"$SESSIONNAME"\007"
printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "$SESSIONNAME" | base64)

tmux has-session -t $SESSIONNAME &> /dev/null
if [ $? != 0 ]
 then
	tmux new-session -s $SESSIONNAME -n "app" -d
	# frontend
	tmux send-keys -t $SESSIONNAME "cd ~/code/ft/connetwork/app" C-m
	tmux split-window -v
	tmux resize-pane -D 10
	tmux select-pane -t 0
	tmux send-keys -t $SESSIONNAME "cd ~/code/ft/connetwork/app" C-m
	# backend
	tmux new-window -t $SESSIONNAME -n "backend"
	tmux send-keys -t $SESSIONNAME "cd ~/code/ft/connetwork/api" C-m
	tmux split-window -v
	tmux resize-pane -D 10
	tmux select-pane -t 0
	tmux send-keys -t $SESSIONNAME "cd ~/code/ft/connectwork/api; clear" C-m
fi

tmux attach -t $SESSIONNAME

