#!/usr/bin/env python3
#
# Copyright (C) 2016 James Murphy
# Licensed under the GPL version 2 only
#
# A battery indicator blocklet script for i3blocks

import re
from subprocess import check_output
device ="/org/freedesktop/UPower/devices/battery_BAT0"
status = check_output(['upower', '-i', device], universal_newlines=True).strip().replace("\n", " ")

if not status:
    # stands for no battery found
    fulltext = "<span color='red'><span font='FontAwesome'>\uf00d \uf240</span></span>"
    percentleft = 100
else:
    percentleft = float(re.match( r'.* +percentage: +(\d+)%', status).group(1))
    state = re.match( r'.* +state: +(\w+)', status).group(1)
    percentage = re.match( r'.* +percentage: +(\d+.*\d+)%', status).group(1)

    # stands for charging
    FA_LIGHTNING = "<span color='yellow'><span font='FontAwesome'>\uf0e7</span></span>"

    # stands for plugged in
    FA_PLUG = "<span font='FontAwesome'>\uf1e6</span>"

    # stands for using battery
    FA_BATTERY = "<span font='FontAwesome'>\uf240</span>"

    # stands for unknown status of battery
    FA_QUESTION = "<span font='FontAwesome'>\uf128</span>"

    if state == "discharging":
        r = re.match( r'.*time to empty: +(\d+\.*\d+) +(\w+)', status)
        timeleft = r.group(1)
        hour_or_min = "min" if r.group(2) == "minutes" else "hrs"
        fulltext = FA_BATTERY + " "
    elif state == "fully":
        fulltext = FA_PLUG + " "
        hour_or_min = ""
        timeleft = ""
    elif state == "charging":
        r = re.match( r'.* +time to full: +(\d+.*\d+) +(\w+)', status)
        timeleft = r.group(1)
        hour_or_min = "min" if r.group(2) == "minutes" else "hrs"
        fulltext = FA_LIGHTNING + " " + FA_PLUG + " "
    else:
        hour_or_min = ""
        timeleft = ""
        fulltext = FA_QUESTION + " " + FA_BATTERY + " "

    def color(percent):
        # if percent < 10:
        #     # exit code 33 will turn background red
        #     return "#FFFFFF"
        if percent < 20:
            return "#FF3300"
        if percent < 30:
            return "#FF6600"
        if percent < 40:
            return "#FF9900"
        if percent < 50:
            return "#FFCC00"
        if percent < 60:
            return "#FFFF00"
        if percent < 70:
            return "#FFFF33"
        if percent < 80:
            return "#FFFF66"
        return "#FFFFFF"

    form =  '<span color="{}">{}% {} {}</span>'
    fulltext += form.format(color(percentleft), percentleft, timeleft, hour_or_min)

print(fulltext)
print(fulltext)
# if percentleft < 10:
#     exit(33)
