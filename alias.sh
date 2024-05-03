alias v=nvim
alias ls=exa
alias la="exa -a"
alias l="exa -l --time-style long-iso --group-directories-first"
alias cls="echo -ne '\033c'"
alias python=python3
alias pip=pip3
alias fd=fdfind
alias bat=batcat
alias copilot="gh copilot"
alias ??="copilot suggest -t shell"
alias t="_attach_or_new $(pwd)"
alias lg=lazygit
alias g=git
alias ai=aichat
alias ip="ip -c"

vssh() {
    server=$1
    path=$2
    v oil-ssh://$server/$path
}
