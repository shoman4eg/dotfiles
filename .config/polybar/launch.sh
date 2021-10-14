#!/usr/bin/env bash
export SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Terminate already running bar instances
killall polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar main -c $(dirname $0)/config.ini &
if [[ $(xrandr --query | grep " connected" | wc -l) -gt 1 ]]; then
  polybar main_external -c $(dirname $0)/config.ini &
fi

