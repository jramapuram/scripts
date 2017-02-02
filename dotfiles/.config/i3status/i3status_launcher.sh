#!/bin/sh
# shell script to prepend i3status with more stuff

i3status | while :
do
    read line
    gpuusage=`cat /proc/acpi/bbswitch | cut -d' ' -f 2`
    cputemp=`sensors | grep Physical | cut -d' ' -f5`
    echo "CPU Temp: $cputemp | GPU: $gpuusage | $line" || exit 1
done
