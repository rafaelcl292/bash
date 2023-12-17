# Ctrl + F
fzf_session() {
    dir=$(fd -t d . ~ ~/.config | fzf)
    [ -z "$dir" ] && return

    session=$(basename $dir)

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
bind '"\ec": "\C-ucd $(fd -t d . ~ ~/.config | fzf)\n"'
