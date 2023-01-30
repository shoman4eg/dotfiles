alias -g      ...=../..
alias -g     ....=../../..
alias -g    .....=../../../..
alias -g   ......=../../../../..
alias -g  .......=../../../../../..
alias -g ........=../../../../../../..

alias _="sudo"

alias ls='exa --group-directories-first -F'
alias ll='exa -lh --group-directories-first -F'
alias la='exa -la --group-directories-first -F'
alias lla='exa -lah --group-directories-first'
alias grep='grep --color=tty -d skip'

alias btop='btm --battery --group'
alias htopm='htop -s PERCENT_MEM'
alias htopc='htop -s PERCENT_CPU'
alias yaourt='yay'
alias cloc='tokei'
alias vim='nvim'
alias zshconfig="${EDITOR} ~/.zshrc"

hash -d pr=/home/askew/Projects/
hash -d projects=~pr

alias history-stat="history | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"


# alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
