#!/bin/zsh

SESSIONNAME="cloudline"
echo -ne "\033]0;"☎️  $SESSIONNAME"\007"
printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "$SESSIONNAME" | base64)

tmux has-session -t $SESSIONNAME &> /dev/null
if [ $? != 0 ]
 then
	tmux new-session -s $SESSIONNAME -n "frontend" -d
	# frontend
	tmux send-keys -t $SESSIONNAME "cd ~/code/cloudline/frontend; nvim ." C-m
	tmux split-window -v
	tmux resize-pane -D 10
	tmux select-pane -t 0
	tmux send-keys -t $SESSIONNAME "cd ~/code/cloudline/frontend; clear" C-m
	# backend
	tmux new-window -t $SESSIONNAME -n "backend"
	tmux send-keys -t $SESSIONNAME "cd ~/code/cloudline/backend; nvim ." C-m
	tmux split-window -v
	tmux resize-pane -D 10
	tmux select-pane -t 0
	tmux send-keys -t $SESSIONNAME "cd ~/code/cloudline/backend; clear" C-m
fi

tmux attach -t $SESSIONNAME

