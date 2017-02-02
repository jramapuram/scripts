#!/bin/bash


if bt-device --info $(bt-device --list | grep KBtalKing | awk {'print $3'} | tr -d "()") | grep -q "Connected: 1"; then
    echo "detected KBtalking"
    xmodmap ~/.xmodmap_kb
elif xinput | grep -q -w "USB Keyboard"; then
    echo "detected usb keyboard"
    xmodmap ~/.xmodmap_kb
else
    echo "utilizing standard key remap"
    xmodmap ~/.xmodmap
fi
