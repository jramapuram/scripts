#!/bin/sh

for x in /sys/devices/system/cpu/cpu*/online; do
    echo 1 >"$x"
done
