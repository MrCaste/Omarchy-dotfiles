#!/bin/bash

player="spotify"

get_info() {
    playerctl -p "$player" status 2>/dev/null
}

status=$(get_info)

if [ -z "$status" ]; then
    echo '{"text": "", "class": "stopped", "tooltip": "Spotify no está activo"}'
    exit 0
fi

artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
title=$(playerctl -p "$player" metadata title 2>/dev/null)

# Truncar si es muy largo
text="${artist} - ${title}"
max_len=40
if [ ${#text} -gt $max_len ]; then
    text="${text:0:$max_len}..."
fi

if [ "$status" = "Playing" ]; then
    icon=""
else
    icon=""
fi

echo "{\"text\": \"${icon}  ${text}\", \"class\": \"${status,,}\", \"tooltip\": \"${artist} - ${title}\"}"
