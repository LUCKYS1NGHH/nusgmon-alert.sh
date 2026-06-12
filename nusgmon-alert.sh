#!/bin/bash

# get UID and set runtime DIR
UID_NUM=$(id -u)
export XDG_RUNTIME_DIR=/run/user/$UID_NUM

# set environment variables according display server (X11/Wayland)
if [ -n "$(pgrep -u $(id -u) [Xx]org)" ]; then
   export DISPLAY=$(who | grep -m1 '(:' | grep -oP '\(:\K[^)]+' | sed 's/^/:/')
   export XAUTHORITY=$(find /home -name '.Xauthority' -user $(id -un) 2>/dev/null | head -1)
else
   export WAYLAND_DISPLAY=$(ls /run/user/$UID_NUM/ | grep -m1 'wayland-')
fi

# set few more important env
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$UID_NUM/bus
export PATH="/usr/local/bin:/bin:$HOME/.local/bin:$PATH"

# user home directory
PREFIX=/home/$(id -un)

# get tools source path
nusgmon=$(command -v nusgmon)
notify=$(command -v notify-send)

# get down/up and mb/gb args
_usage_type="$1"
_unit="$2"
usage_type=${_usage_type:-down}
usage_unit=${_unit:-MB}

# set alert info
icon=$PREFIX/.local/share/nusgmon-alert/icons/cellular-network.png
heading="Bandwidth Alert"

# run commands
comm=$($nusgmon --today --json)
value=$(echo "$comm" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['total'][0]['$usage_type'])")

thresholds=(5120 4096 3072 2048 1024 500 100) # add more if you want

# notify once per threshold breach, highest unnotified first
for threshold in "${thresholds[@]}"; do
    if [ -f /tmp/${usage_type}_data_exceed_${threshold} ]; then
        break
    fi

    if awk "BEGIN { exit !($value >= $threshold) }"; then
        "$notify" -i "$icon" "$heading" "${usage_type^}load usage exceeded ${threshold} ${usage_unit}"
        touch /tmp/${usage_type}_data_exceed_${threshold}
        break
    fi
done


# =====================================================
# nusgmon-alert.sh - Sends Data Usage Alerts
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Author: LUCKYS1NGHH
# Repo: https://github.com/LUCKYS1NGHH/nusgmon-alert.sh
# ======================================================
