#!/bin/bash
# Set the drive name that we mount for our backups
vol_mount="Time Machine"

if ! mount | grep "$vol_mount" ; then
    diskutil mount "$vol_mount"
else
    timemachine_backup.sh
fi
