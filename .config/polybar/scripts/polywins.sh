#!/bin/bash

active_text_color="#d8dee9"
active_bg="#3b4252"
active_underline="#81a1c1"

inactive_text_color="#a5abb6"
inactive_bg=
inactive_underline=

hidden_text_color="#4c566a"
hidden_bg=
hidden_underline=

char_limit=10
class_char_limit=8

active_left="%{F$active_text_color}"
active_right="%{F-}"
inactive_left="%{F$inactive_text_color}"
inactive_right="%{F-}"
hidden_left="%{F$hidden_text_color}"
hidden_right="%{F-}"
separator="  "
separator="%{F$inactive_text_color}$separator%{F-}"

char_case="upper" # normal, upper, lower

if [ -n "$active_bg" ]; then
	active_left="${active_left}%{B$active_bg}"
	active_right="%{B-}${active_right}"
fi

if [ -n "$inactive_bg" ]; then
	inactive_left="${inactive_left}%{B$inactive_bg}"
	inactive_right="%{B-}${inactive_right}"
fi

format_underline() {
	echo -n "%{u#0a6cf5}%{+u}$(shorten "$1")%{-u}   "
}

wm_class() {
	echo $(xprop WM_CLASS -id $1 | awk '{print $4}' | sed -e 's/^"//' -e 's/"$//')
}
wm_title() {
	echo $(xtitle $1)
}

# Truncate displayed name to user-selected limit
truncate() {
	if [ "${#1}" -gt "$2" ]; then
		echo "$1" | cut -c1-$($2-1)
	else
		echo "$1"
	fi
}

is_hidden_wid() {
	if xprop -id "$1" | grep -q "window state: Normal"
	then
		return 1
	else
		return 0
	fi
}

raise_or_minimize() {
	if [ "$(get_active_wid)" = "$1" ]; then
		wmctrl -ir "$1" -b toggle,hidden
	else
		wmctrl -ia "$1"
		wmctrl -ir "$1" -b remove,hidden; wmctrl -ia "$1"
		# wmctrl -ia "$1"
	fi
	retile_after_hide "$1"
}

close() {
	wmctrl -ic "$1"
}

add_action() {
	w_name=""
	window_count=0
	windows=$(xtitle $(bspc query -N -n .window --desktop $MONITOR:focused))
	id_windows=$(bspc query -N -n .window --desktop $MONITOR:focused)
	focused=$(xtitle $(bspc query -N -n))
	id_focused=$(bspc query -N -n)
	win_id=$(wmctrl -lx | awk '{$2=$3=$4=" ";print}')
	while IFS="[ .\.]" read -r w; do
		w_name=$(wm_title $w)

		if [ "${#w_name}" -gt "$char_limit" ]; then
			w_name="$(echo "$w_name" | cut -c1-$((char_limit-1)))…"
		fi

		w_class=$(wm_class $w)

		if [ "${#w_class}" -gt "$class_char_limit" ]; then
			w_class="$(echo "$w_class" | cut -c1-$((class_char_limit-1)))"
		fi

		w_name=" $w_name - $w_class "

		# Use user-selected character case
		case "$char_case" in
			"lower") w_name=$(
				echo "$w_name" | tr '[:upper:]' '[:lower:]'
				) ;;
			"upper") w_name=$(
				echo "$w_name" | tr '[:lower:]' '[:upper:]'
				) ;;
		esac

		if [ "$w" = "$id_focused" ]; then
			w_name="${active_left}${w_name}${active_right}"
		elif ( is_hidden_wid "$w"); then
			w_name="${hidden_left}${w_name}${hidden_right}"
		else
			w_name="${inactive_left}${w_name}${inactive_right}"
		fi

		# Add separator unless the window is first in list
		if [ "$window_count" != 0 ]; then
			printf "%s" "$separator"
		fi

		printf "%s" "%{A1:$on_click bspc node -f $w:}"
		printf "%s" "%{A2:$on_click close $w:}"
		# Print the final window name
		printf "%s" "$w_name"
		printf "%s" "%{A}%{A}"

		window_count=$(( window_count + 1 ))
	done <<-EOF
		$id_windows
	EOF

	if [ "$window_count" = 0 ]; then
		printf "%s" " "
	fi
	echo ""
}

xtitle -s | while read; do add_action; done
