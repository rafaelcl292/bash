_attach_or_new() {
    dir=$1
    session=$(basename $dir)
    # replace . with _
    session=${session//./_}

    # create a new session if it doesn't exist
    sessions=$(tmux list-sessions -F '#S' 2>/dev/null)

    if ! echo "$sessions" | rg -q "^$session$"; then
        tmux new-session -d -s $session -c $dir

        # run .tmux.sh if it exists
        if [ -f "$dir/.tmux.sh" ]; then
            tmux send-keys -t $session "source $dir/.tmux.sh" Enter
        fi
    fi

    # if in tmux
    if ! tmux info &>/dev/null; then
        tmux attach-session -t $session
    else
        tmux switch-client -t $session
    fi
}

# Ctrl + F
fzf_session() {
    dir=$(fd -t d . ~ ~/.config | fzf)
    [ -z "$dir" ] && return

    _attach_or_new $dir
}

bind -x '"\C-f": fzf_session'

# Alt + C
fzf_dir() {
    dir=$(fd -t d | fzf)
    [ -z "$dir" ] && return

    cd $dir
}

bind '"\ec": "\C-ufzf_dir\nclear\n"'

# Ctrl + D
bind -x '"\C-d": exit'

# completion
bind "set completion-ignore-case on"
bind '"\C-i": menu-complete'
