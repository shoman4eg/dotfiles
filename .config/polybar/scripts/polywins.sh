#!/bin/bash

# Colors
source <(grep = $HOME/.config/polybar/colors.ini | sed 's/ *= */=/g' | sed 's/-/_/g')

active_foreground=
active_background="$background_alt"

inactive_foreground=
inactive_background=

hidden_foreground="$foreground_darker"
hidden_background=

char_limit=10
class_char_limit=10

active_left="%{F$active_foreground}"
active_right="%{F-}"
inactive_left="%{F$inactive_foreground}"
inactive_right="%{F-}"
hidden_left="%{F$hidden_foreground}"
hidden_right="%{F-}"
separator=" "
separator="%{F$inactive_foreground}$separator%{F-}"
char_case="normal" # normal, upper, lower

w_add_icon() {
	shopt -s nocasematch
	w_class="$1"
	case "$w_class" in
		code) w_name="" w_class='VS Code';;
		alacritty) w_name="";;
		telegramdesktop) w_name=""; w_class='Telegram';;
		slack) w_name="";;
		firefoxdeveloperedition) w_name=""; w_class='Firefox';;
		firefox) w_name="";;
		jetbrains-phpstorm) w_name=""; w_class='phpStorm';;
		google-chrome) w_name="";;
		iwgtk) w_name="";;
		discord) w_name="";;
		thunar) w_name="";;
		lxappearance) w_name="";;
		*) w_name="";;
	esac
	echo "$w_name $w_class"
}

if [ -n "$active_background" ]; then
	active_left="${active_left}%{B$active_background}"
	active_right="%{B-}${active_right}"
fi

if [ -n "$inactive_background" ]; then
	inactive_left="${inactive_left}%{B$inactive_background}"
	inactive_right="%{B-}${inactive_right}"
fi

wm_class() {
	echo $(bspc query -T -n $1 | jq .client.className | sed -e 's/^"//' -e 's/"$//')
}

node_flags() {
	echo $(bspc query -n $1 --tree | jq '. | {sticky,private,locked,marked} | to_entries | .[] | select(.value) | .key | .[0:1]' | sed 's/"//g' | tr -d '\n')
}

# Truncate displayed name to user-selected limit
truncate() {
	if [ "${#1}" -gt "$2" ]; then
		echo "$1" | cut -c1-$($2-1)
	else
		echo "$1"
	fi
}

get_hidden_wid() {
	echo $(bspc query -N -n .hidden)
}

get_focused_wid() {
	return $(bspc query -N -n .focused --desktop $MONITOR:focused)
}

get_active_wid() {
	echo $(bspc query -N -n)
}

raise_or_minimize() {
	if get_active_wid | grep -q "$1"; then
		bspc node -g hidden=on
	else
		if get_hidden_wid | grep -q "$w"; then
			bspc node "$1" -g hidden=off
		fi
		bspc node -f "$1"
	fi
}

floating() {
	bspc node "$1" -t \~floating
}

close() {
	bspc node "$1" -c
}

add_action() {
	w_name=""
	window_count=0
	windows_ids=$(bspc query -N -n .window --desktop $MONITOR:focused)
	focused_id=$(get_active_wid)
	hidden_ids=$(get_hidden_wid)
	on_click="$0"
	while IFS="[ .\.]" read -r w; do
		if [ "$w" == "" ]; then
			continue
		fi
		w_class=$(wm_class $w)
		w_name=$(w_add_icon $w_class)


		# Use user-selected character case
		case "$char_case" in
		"lower") w_name=$(
			echo "$w_name" | tr '[:upper:]' '[:lower:]'
		) ;;
		"upper") w_name=$(
			echo "$w_name" | tr '[:lower:]' '[:upper:]'
		) ;;
		esac

		if [ "$w" = "$focused_id" ]; then
			w_name="${active_left} ${w_name} ${active_right}"
		elif (echo "$hidden_ids" | grep -q "$w"); then
			w_name="${hidden_left} ${w_name} ${hidden_right}"
		else
			w_name="${inactive_left} ${w_name} ${inactive_right}"
		fi

		# Add separator unless the window is first in list
		if [ "$window_count" != 0 ]; then
			printf "%s" "$separator"
		fi

		printf "%s" "%{A1:$on_click raise_or_minimize $w:}"
		printf "%s" "%{A2:$on_click close $w:}"
		printf "%s" "%{A3:$on_click floating $w:}"

		# Print the final window name
		printf "%s" "$w_name"

		printf "%s" "%{A}%{A}%{A}"

		window_count=$((window_count + 1))
	done <<-EOF
		$windows_ids
	EOF

	if [ "$window_count" = 0 ]; then
		printf "%s" " "
	fi
	echo ""
}

main() {
	# If no argument passed...
	if [ -z "$2" ]; then
		bspc subscribe report | while read; do add_action; done
	# If arguments are passed, run requested on-click function
	else
		"$@"
	fi
}

main "$@"
