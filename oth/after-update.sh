#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo == touch environment ==

if ! grep -q en_GB /etc/environment;
then
    echo 'LC_ALL="en_GB.utf8"' >> /etc/environment
fi

if ! grep -q PS1 ~/.profile;
then
    echo "export PS1='\h:\w\$ '" >> ~/.profile
fi

echo == apps ==

apt install vim-nox

echo == hostname ==

vim /etc/hostname

echo == add proper pampi startup ==

cp autostart /home/pi/.config/lxsession/LXDE/
cp pampinit /etc/init.d/pampinit


