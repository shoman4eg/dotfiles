#!/usr/bin/env bash
export SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Terminate already running bar instances
killall polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
export MONITOR="eDP1"
export BSPWM_MONITOR_CMD="cat ~/.cache/polybar-desktops/eDP1_monitor"
polybar main -c $(dirname $0)/config.ini &
# if [[ $(xrandr --query | grep " connected" | wc -l) -gt 1 ]]; then
#   export MONITOR="eDP1"
#   export BSPWM_MONITOR_CMD="cat ~/.cache/polybar-desktops/eDP1_monitor"
#   polybar main_external -c $(dirname $0)/config.ini &
# fi

for monitor in $( polybar --list-all-monitors | awk '{print substr($1, 1, length($1)-1)}' | grep -v ^eDP1); do
  export MONITOR="$monitor"
  export BSPWM_MONITOR_CMD="cat ~/.cache/polybar-desktops/${monitor}_monitor"
  polybar main_external -c $(dirname $0)/config.ini &
done
