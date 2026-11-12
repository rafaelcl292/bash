alias v=nvim
alias ls="exa --group-directories-first"
alias la="exa -a"
alias l="exa -l --time-style long-iso --group-directories-first"
alias cls="echo -ne '\033c'"
alias pip="uv pip"
alias fd=fdfind
alias bat=batcat
alias copilot="gh copilot"
alias ??="copilot suggest -t shell"
unalias t 2>/dev/null
t() {
    _attach_or_new "$PWD"
}
alias lg=lazygit
alias g=git
alias ip="ip -c"

vssh() {
    local server=$1
    local path=${2-}
    nvim "oil-ssh://$server/$path"
}
