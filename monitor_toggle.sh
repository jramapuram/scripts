#!/bin/bash

# Get input types
INTERNAL_OUTPUT="eDP1"
if xrandr | grep -q -w "DP1 connected"; then
    EXTERNAL_OUTPUT="DP1"
elif xrandr | grep -q -w "HDMI1 connected"; then
    EXTERNAL_OUTPUT="HDMI1"
else
    EXTERNAL_OUTPUT="NONE"
    return 0
fi

# if we don't have a file, start at zero
if [ ! -f "/tmp/monitor_mode.dat" ] ; then
    monitor_mode="all"
else
    # otherwise read the value from the file
    monitor_mode=`cat /tmp/monitor_mode.dat`
fi

if [ $monitor_mode = "all" ]; then
    monitor_mode="EXTERNAL"
    xrandr --output $INTERNAL_OUTPUT --off --output $EXTERNAL_OUTPUT --auto
    #xset -dpms
    sh ~/.fehbg
elif [ $monitor_mode = "EXTERNAL" ]; then
    monitor_mode="INTERNAL"
    xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --off
    #xset dpms 60
    sh ~/.fehbg
elif [ $monitor_mode = "INTERNAL" ]; then
    monitor_mode="CLONES"
    xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto --same-as $INTERNAL_OUTPUT
    #xset -dpms
    sh ~/.fehbg
else
    monitor_mode="all"
    xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto --left-of $INTERNAL_OUTPUT
    #xset -dpms
    sh ~/.fehbg
fi
echo "${monitor_mode}" > /tmp/monitor_mode.dat
