#!/usr/bin/env bash
export SCRIPTPATH="$(
  cd "$(dirname "$0")"
  pwd -P
)"

# Terminate already running bar instances
killall polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
for monitor in $(xrandr --query | grep " connected" | awk '{print $1}'); do
  export MONITOR="$monitor"
  polybar "main_$monitor" -c $(dirname $0)/config.ini &
done
