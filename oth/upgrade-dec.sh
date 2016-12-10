#!/bin/bash

echo * security

sudo dpkg-reconfigure console-setup

if ! test -e ~/.ssh/id_ecdsa.pub;
then
  echo === GENERATE ECDSA key ===
  ssh-keygen -t ecdsa
  ssh-copy-id -i ~/.ssh/id_ecdsa.pub pi-chan@dev2-bg.plan-vision.com -p2299
fi

echo * apps

apt update
apt upgrade
apt install xautomation chromium-browser
apt install raspi-update lightdm ack-grep
apt install libgl1-mesa-dri xcompmgr lxde-core

echo * autostart

echo ## kiosk
mkdir -p /home/pi/.config/lxsession/LXDE/
cp autostart /home/pi/.config/lxsession/LXDE/

echo # gps
cp gpsd.socket /lib/systemd/system
cp gpsd

echo * tuning

sudo ./config-boot.sh
