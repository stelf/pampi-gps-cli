#!/bin/bash

echo = font =

sudo dpkg-reconfigure console-setup

echo = security =

if ! test -e ~/.ssh/id_ecdsa.pub;
then
  echo === GENERATE ECDSA key ===
  ssh-keygen -t ecdsa
  ssh-copy-id -i ~/.ssh/id_ecdsa.pub pi-chan@dev2-bg.plan-vision.com -p2299
fi

echo = apps =

apt update
apt install xautomation chromium-browser
apt install rpi-update lightdm ack-grep
apt install libgl1-mesa-dri xcompmgr lxde-core

echo = kiosk =
mkdir -p /home/pi/.config/lxsession/LXDE/
cp autostart /home/pi/.config/lxsession/LXDE/

echo = gps =
sudo cp gpsd.socket /lib/systemd/system/
sudo cp gpsd /etc/default/

echo * tuning

sudo ./config-boot.sh
