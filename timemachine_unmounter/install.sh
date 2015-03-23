#!/bin/bash

cp com.apple.TimeMachine_OnLoadSchedule.plist ~/Library/LaunchAgents/
cp com.apple.TimeMachine_OnMount.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.apple.TimeMachine_OnMount.plist
launchctl load ~/Library/LaunchAgents/com.apple.TimeMachine_OnLoadSchedule.plist

cp timemachine_* /usr/local/bin/
chmod +x /usr/local/bin/timemachine_*.sh
