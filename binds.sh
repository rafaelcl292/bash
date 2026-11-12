_attach_or_new() {
    local dir=$1
    local session
    session=$(basename -- "$dir")
    # replace . with _
    session=${session//./_}

    # create a new session if it doesn't exist
    local sessions
    sessions=$(tmux list-sessions -F '#S' 2>/dev/null)

    if ! printf '%s\n' "$sessions" | rg -Fxq -- "$session"; then
        tmux new-session -d -s "$session" -c "$dir" || return

        # run .tmux.sh if it exists
        if [ -f "$dir/.tmux.sh" ]; then
            local startup_cmd
            printf -v startup_cmd 'source %q' "$dir/.tmux.sh"
            tmux send-keys -t "=$session" "$startup_cmd" Enter
        fi
    fi

    # if in tmux
    if [ -z "${TMUX:-}" ]; then
        tmux attach-session -t "=$session"
    else
        tmux switch-client -t "=$session"
    fi
}

# Ctrl + F
fzf_session() {
    local dir
    dir=$(fd -t d . ~ ~/.config | fzf)
    [ -z "$dir" ] && return

    _attach_or_new "$dir"
}

bind -x '"\C-f": fzf_session'

# Alt + C
fzf_dir() {
    local dir
    dir=$(fd -t d | fzf)
    [ -z "$dir" ] && return

    cd -- "$dir"
}

bind '"\ec": "\C-ufzf_dir\nclear\n"'

# Ctrl + D
bind -x '"\C-d": exit'

bind -x '"\ee": openai_regenerate_cmd'

# completion
bind "set completion-ignore-case on"
bind '"\C-i": menu-complete'
