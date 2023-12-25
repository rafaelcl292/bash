# Ctrl + F
fzf_session() {
    dir=$(fd -t d . ~ ~/.config | fzf)
    [ -z "$dir" ] && return

    session=$(basename $dir)
    # replace . with _
    session=${session//./_}

    # create a new session if it doesn't exist
    if ! tmux has-session -t $session 2>/dev/null; then
        tmux new-session -d -s $session -c $dir
    fi

    # if in tmux
    if ! tmux info &> /dev/null; then
        tmux attach-session -t $session
    else
        tmux switch-client -t $session
    fi
}

bind -x '"\C-f": fzf_session'

# Alt + C
fzf_dir() {
    dir=$(fd -t d . ~ ~/.config | fzf)
    [ -z "$dir" ] && return

    cd $dir
}

bind '"\ec": "\C-ufzf_dir\n"'

# Ctrl + D
bind -x '"\C-d": exit'
