#!/usr/bin/env bash
IFS=$'\n\t'

scroll=(unbuffer zscroll -l 10 -d 0.1)
icon_playing=$'\u25B6'
icon_paused=$'\u23F8'

while true; do
	# requires playerctl>=2.0
	playerctl --follow metadata --format \
		$'{{status}}\t{{artist}} - {{title}}' |
	while read -r status line; do
		(( ${#pid} )) && kill "$pid" > /dev/null 2>&1
		case $status in
			Paused) "${scroll[@]}" -b "$icon_paused " "$line" & ;;
			Playing) "${scroll[@]}" -b "$icon_playing " "$line" & ;;
			*) echo "(STOPPED)" ;;
		esac
		pid=$!
	done
	# no current players
	echo '(STOPPED)'
	sleep 15
done
