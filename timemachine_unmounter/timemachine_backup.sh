#!/bin/bash

# Set the drive name that we mount for our backups
vol_mount="Time Machine"

if mount | grep "$vol_mount" ; then
    tmutil startbackup -b && diskutil eject "$vol_mount"
fi
