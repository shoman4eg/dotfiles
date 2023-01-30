if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='code'
fi

export GOPATH=$HOME/.go
export BROWSER='/usr/bin/firefox-developer-edition'
export PATH=$HOME/.local/bin:$GOROOT/bin:$GOPATH/bin:$PATH
export TERMINAL=alacritty
export PAGER='less -RF'
export TERM=xterm-256color
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
