#!/usr/bin/env bash

# Colors
source <(grep = $HOME/.config/polybar/colors.ini | sed 's/ *= */=/g' | sed 's/-/_/g')

icon_active=''
icon_active_foreground="$magenta"
icon_inactive=''
icon_inactive_foreground="$red"

get_camera_status() {
    camera_status=$(lsusb | grep -c Webcam)
}

function output() {
    get_camera_status
    if [ "${camera_status}" -eq 1 ]; then
        echo "%{F$icon_active_foreground}$icon_active%{F-}"
	else
		echo "%{F$icon_inactive_foreground}$icon_inactive%{F-}"
	fi
}

case "$1" in
    *)
        # By default print output for bar
        output
        ;;
esac
