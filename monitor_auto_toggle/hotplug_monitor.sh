#!/bin/bash

######################################
## /usr/local/bin/hotplug_monitor.sh
######################################
X_USER=jramapuram
export DISPLAY=:0
export XAUTHORITY=/home/$X_USER/.Xauthority
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

INTERNAL_OUTPUT="eDP1"

# determine what index the card is assigned
if [ -d "/sys/class/drm/card0" ]; then
    CARD_INDEX="/sys/class/drm/card0"
else
    CARD_INDEX="/sys/class/drm/card1"
fi
    
if [ $(cat ${CARD_INDEX}-DP-1/status) == "connected" ] ; then
    # If at home disable laptop screen else use 'all' mode
    if [ $(head -n 1 ${CARD_INDEX}-DP-1/modes) == "3440x1440" ] ; then
	xrandr --output $INTERNAL_OUTPUT --off --output DP1 --auto
    else
	xrandr --output $INTERNAL_OUTPUT --auto --output DP1 --auto --left-of $INTERNAL_OUTPUT
    fi
    killall -SIGUSR1 conky
    sleep 1 && nitrogen --restore
elif [ $(cat ${CARD_INDEX}-DP-1/status) == "disconnected" ] ; then
    xrandr --output $INTERNAL_OUTPUT --auto --output DP1 --off
    killall -SIGUSR1 conky
    sleep 1 && nitrogen --restore
elif [ $(cat ${CARD_INDEX}-HDMI-A-1/status) == "connected" ] ; then
    xrandr --output $INTERNAL_OUTPUT --auto --output HDMI1 --auto --left-of $INTERNAL_OUTPUT
    killall -SIGUSR1 conky
    sleep 1 && nitrogen --restore
elif [ $(cat ${CARD_INDEX}-HDMI-A-1/status) == "disconnected" ] ; then
    xrandr --output $INTERNAL_OUTPUT --auto --output HDMI1 --off
    killall -SIGUSR1 conky
    sleep 1 && nitrogen --restore
else
    exit
fi
