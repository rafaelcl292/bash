# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias v="nvim"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls="echo -ne '\033c'"
alias python=python3
alias pip=pip3
alias fd="fdfind"
alias copilot="gh copilot"

t() {
    dir=$(pwd)
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
