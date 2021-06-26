alias wat="git status"
alias puff="git commit -a"
alias bigpuff="git add -A . && puff"
alias pull="git pull --rebase"
alias pass="git push"
alias fpass="git push --force-with-lease"
alias sup="git checkout"
alias fetch="git fetch -p -P -t -v"
alias glog="git log"
alias giff="git diff"

if [[ -n `whence doas` ]]; then
    alias pls="doas"
else
    alias pls="sudo"
fi

alias b="bundle"
alias be="bundle exec"
alias brake="be rake"
alias brails="be rails"
alias brs="brails s"
alias brc="brails c"
