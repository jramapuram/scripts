#!/bin/bash

######################################
## /usr/local/bin/hotplug_monitor.sh
######################################
X_USER=jramapuram
export DISPLAY=:0
export XAUTHORITY=/home/$X_USER/.Xauthority
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

INTERNAL_OUTPUT="eDP1"
EXTERNAL_OUTPUT="DVI-I-1-1"
EXTERNAL_POSTFIX="DVI-I-1"
# EXTERNAL_POSTFIX="DP-1" # thunderbolt
# EXTERNAL_OUTPUT="DP1" # thunderbolt

# determine what index the card is assigned
if [ -d "/sys/class/drm/card1" ]; then
    CARD_INDEX="/sys/class/drm/card1"
else
    CARD_INDEX="/sys/class/drm/card0"
fi
    
if [ $(cat ${CARD_INDEX}-$EXTERNAL_POSTFIX/status) == "connected" ] ; then
    # If at home disable laptop screen else use 'all' mode
    if [ $(head -n 1 ${CARD_INDEX}-$EXTERNAL_POSTFIX/modes) == "3440x1440" ] ; then
	xrandr --output $INTERNAL_OUTPUT --off --output $EXTERNAL_OUTPUT --auto
    else
	xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto --left-of $INTERNAL_OUTPUT
    fi
    killall -SIGUSR1 conky
    sleep 1 && nitrogen --restore
    i3-msg 'restart'    
elif [ $(cat ${CARD_INDEX}-$EXTERNAL_POSTFIX/status) == "disconnected" ] ; then
    xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --off
    killall -SIGUSR1 conky
    sleep 1 && nitrogen --restore
    i3-msg 'restart'
elif [ $(cat ${CARD_INDEX}-HDMI-A-1/status) == "connected" ] ; then
    xrandr --output $INTERNAL_OUTPUT --auto --output HDMI1 --auto --left-of $INTERNAL_OUTPUT
    killall -SIGUSR1 conky
    sleep 1 && nitrogen --restore
    i3-msg 'restart'
elif [ $(cat ${CARD_INDEX}-HDMI-A-1/status) == "disconnected" ] ; then
    xrandr --output $INTERNAL_OUTPUT --auto --output HDMI1 --off
    killall -SIGUSR1 conky
    sleep 1 && nitrogen --restore
    i3-msg 'restart'    
else
    exit
fi
