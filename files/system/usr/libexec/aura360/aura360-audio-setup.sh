#!/bin/bash
# Aura 360 OS - agrega el primer usuario normal a los grupos @audio y @realtime
# (patron caracal: rtprio 95 + memlock unlimited via /etc/security/limits.d)
# Se reintenta en cada arranque hasta que el usuario existe (se crea en el
# primer inicio del escritorio) y se marca la tarea como completada.

marker=/var/lib/aura360-audio-setup.done

if [ -f "$marker" ]; then
    exit 0
fi

user=$(getent passwd | awk -F: '$3 >= 1000 && $3 < 60000 { print $1; exit }')

if [ -z "$user" ]; then
    exit 0
fi

usermod -aG audio,realtime "$user" || true
touch "$marker"
exit 0
