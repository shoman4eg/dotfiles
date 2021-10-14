
function f() { find . -iname "*$1*" ${@:2} }
function r() { grep "$1" ${@:2} -R . }

fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

fnpm() {
    local packages
    packages=$(all-the-package-names | fzf -m) &&
    echo "$packages" &&
    npm i $(echo $packages)2
}


fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

fh() {eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')}


function debinstall() {
  ar x $1 data.tar.xz
  mkdir /tmp/$1_dir
  tar -C /tmp/$1_dir -xf data.tar.xz
  sudo rsync /tmp/$1_dir /
  rm -f data.tar.xz
  rm -rf /tmp/$1_dir
}
