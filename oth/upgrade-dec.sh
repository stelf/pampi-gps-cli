
echo = font =

sudo dpkg-reconfigure console-setup

echo = security =

if ! test -e ~/.ssh/id_ecdsa.pub;
then
  echo === GENERATE ECDSA key ===
  ssh-keygen -t ecdsa
  ssh-copy-id -i ~/.ssh/id_ecdsa.pub pi-chan@dev2-bg.plan-vision.com -p2299
fi

echo = tuning =

if ! grep -q temp_limit /boot/config.txt;
then
  echo === IMPROVE SPEED ===
sudo -s cat >> /boot/config.txt <<EOF
 gpu_mem=320
 arm_freq=1000
 sdram_freq=500
 core_freq=500
 over_voltage=2
 temp_limit=80 #Will throttle to default clock speed if hit.
EOF
fi

echo = apps =

apt update
apt install xautomation chromium-browser
apt install rpi-update lightdm
apt install libgl1-mesa-dri xcompmgr lxde-core

echo = kiosk =
mkdir -p /home/pi/.config/lxsession/LXDE/
cp autostart /home/pi/.config/lxsession/LXDE/

echo = gps =
sudo cp gpsd.socket /lib/systemd/system/
sudo cp gpsd /etc/default/

sudo -s raspi-config
sudo -s rpi-update
