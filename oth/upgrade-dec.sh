cp autostart /home/pi/.config/lxsession/LXDE/

if ! grep -q temp_limit /tmp/xxx; 
then
cat >> /tmp/razgele <<EOF 
 gpu_mem=320
 arm_freq=1000
 sdram_freq=500
 core_freq=500
 over_voltage=2
 temp_limit=80 #Will throttle to default clock speed if hit.
EOF
fi

apt update
apt upgrade
apt install xautomation

mkdir -p 
cp autostart /home/pi/

# 
# tell GPSD to not start IPV6
# 