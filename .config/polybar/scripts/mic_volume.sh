#!/usr/bin/env bash

# Colors
source <(grep = $HOME/.config/polybar/colors.ini | sed 's/ *= */=/g' | sed 's/-/_/g')

icon=""
icon_foreground="$cyan"

muted_icon=""
muted_icon_foreground="$red"
active_source=""
inc='7'
limit=$((100 - inc))

reload_source() {
    active_source=$(pactl get-default-source)
}

function volume_up {
    get_current_volume
	if [ "$current_volume" -le 100 ] && [ "$current_volume" -ge "$limit" ]; then
		pactl set-source-volume "$active_source" 100%
	elif [ "$current_volume" -lt "$limit" ]; then
		pactl set-source-volume "$active_source" "+$inc%"
	fi
    get_current_volume
}

function volume_down {
    pactl set-source-volume "$active_source" "-$inc%"
    get_current_volume
}

function volume_mute {
	pactl set-source-mute "$active_source" toggle
	notify-send "Mic mute:" "$(pactl get-source-mute $active_source | awk '{print $2}')"  -h string:x-canonical-private-synchronous:mic
}

function get_mute_status {
    mute_status=$(pactl get-source-mute $active_source | awk '/Mute: /{ print $2}')
}

function get_current_volume {
	current_volume=$(pactl get-source-volume $active_source | awk '{gsub("%,?", ""); print $5; exit}')
}

# Prints output for bar
# Listens for events for fast update speed
function listen {
    firstrun=0

    pactl subscribe 2>/dev/null | {
        while true; do
            {
                # If this is the first time just continue
                # and print the current state
                # Otherwise wait for events
                # This is to prevent the module being empty until
                # an event occurs
                if [ $firstrun -eq 0 ]
                then
                    firstrun=1
                else
                    read -r event || break
                    if ! echo "$event" | grep -e "on card" -e "on source"
                    then
                        # Avoid double events
                        continue
                    fi
                fi
            } &>/dev/null
            output
        done
    }
}

function output() {
    reload_source
    get_current_volume
    get_mute_status
    if [ "${mute_status}" = 'yes' ]; then
        echo "%{F$muted_icon_foreground}$muted_icon%{F-}"
	else
		echo "%{F$icon_foreground}$icon%{F-} $current_volume%"
	fi
}

reload_source
case "$1" in
    --up)
        volume_up
        ;;
    --down)
        volume_down
        ;;
    --togmute)
        volume_mute mute
        ;;
    --sync)
        volSync
        ;;
    --listen)
        # Listen for changes and immediately create new output for the bar
        # This is faster than having the script on an interval
        listen
        ;;
    *)
        # By default print output for bar
        output
        ;;
esac


# subscribe_volume() {
# 	volume=$(pactl get-source-volume @DEFAULT_SOURCE@ | awk '{gsub("%,?", ""); print $5; exit}')
# 	mute=$(pactl get-source-mute @DEFAULT_SOURCE@)
# 	if [ -z "$volume" ]; then
# 		echo "No Mic Found"
# 	else
# 		volume="${volume//[[:blank:]]/}"
# 		if [[ "$mute" == *"yes"* ]]; then
# 			echo "%{F$muted_icon_foreground}$muted_icon%{F-}"
# 		elif [[ "$mute" == *"no"* ]]; then
# 			echo "%{F$icon_foreground}$icon%{F-} $volume%"
# 		else
# 			echo "$volume !"
# 		fi
# 	fi
# }

# case $1 in
# 	"show-vol")
# 		volume=$(pactl get-source-volume @DEFAULT_SOURCE@ | awk '{gsub("%,?", ""); print $5; exit}')
# 		mute=$(pactl get-source-mute @DEFAULT_SOURCE@)
# 		display_volume
# 		;;

# 	"subscribe")
# 		subscribe_volume
# 		pactl subscribe | grep --line-buffered "source" | while read; do subscribe_volume; done
# 		;;

# 	"inc-vol")
# 		pactl set-source-volume @DEFAULT_SOURCE@  +7%
# 		;;
# 	"dec-vol")
# 		pactl set-source-volume @DEFAULT_SOURCE@ -7%
# 		;;
# 	"mute-vol")
# 		pactl set-source-mute @DEFAULT_SOURCE@ toggle
# 		notify-send "Mic mute:" "$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')"  -h string:x-canonical-private-synchronous:mic
# 		;;
# 	*)
# 		echo "Invalid script option"
# 		;;
# esac
