#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo == touch environment ==

if ! grep -q en_GB /etc/environment;
then
    echo LC_ALL="en_GB.utf8" >>re /etc/environment
fi

cp pampinit /etc/init.d/pampinit
