PROMPT_COMMAND='if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then PS1_CMD1=" $(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2)"; else PS1_CMD1=""; fi'
PS1='[\[\033[36;1m\]\w\[\033[32;1m\]${PS1_CMD1}\[\033[0m\]] \n\$ '

export EDITOR=nvim
export VISUAL=nvim

# `apt show fzf` for bindings
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_DEFAULT_COMMAND="fd --type file --color=always"
export FZF_DEFAULT_OPTS="--ansi"
