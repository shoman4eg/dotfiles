#!/usr/bin/env bash

# Terminate already running bar instances
killall polybar -w

outputs=$(polybar --list-all-monitors | awk '{print substr($1, 1, length($1)-1)}')
for m in $outputs; do
  current_path="$( cd "$(dirname "$0")" ; pwd -P )"
  MONITOR=$m SCRIPTPATH=$current_path polybar --reload "main_$m" -c $(dirname $0)/config.ini </dev/null >/var/tmp/polybar-$m.log 2>&1 200>&- &
done
