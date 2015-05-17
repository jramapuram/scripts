#!/usr/local/bin/fish
set CURRENT_WORKING_DIRECTORY $PWD
cd ~/Documents/vagrant;
vagrant up --provider parallels;
set -x DOCKER_HOST tcp://(vagrant ssh-config | sed -n 's/[ ]*HostName[ ]*//gp'):2375
cd $CURRENT_WORKING_DIRECTORY