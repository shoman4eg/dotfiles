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
for monitor in $(polybar --list-all-monitors | awk '{print substr($1, 1, length($1)-1)}'); do
  MONITOR="$monitor" polybar "main_$monitor" -c $(dirname $0)/config.ini &
done



curl 'https://localhost/v2/getSwagger' \
  -H 'authority: localhost' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'accept: application/json,*/*' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'origin: https://petstore.swagger.io' \
  -H 'sec-fetch-site: cross-site' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  -H 'referer: https://petstore.swagger.io/' \
  -H 'accept-language: en-US,en;q=0.9,ru;q=0.8' \
  --compressed
