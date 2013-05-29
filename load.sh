#!/bin/bash

. functions.sh

n=$1
dev=wlan$n
bat=bat$n
mon=mon$n
dev_ip=10.0.0.$n/24
bat_ip=10.0.1.$n/24
freq=2462
ssid=rlnc
bssid=A2:79:F9:9F:60:80
mtu=1550
qlen=500

module_path=/home/hundeboll/projects/catwoman/batman-adv.ko

if ! module_is_loaded "mac80211_hwsim"; then
    echo Loading mac80211_hwsim module
    modprobe mac80211_hwsim || exit 1
fi

echo Configuring $dev
if ! dev_has_ip $dev $dev_ip; then
    ip link set dev $dev down
    iw dev $dev set type ibss
    ip link set dev $dev up
    iw dev $dev ibss join $ssid $freq $bssid
    #iw dev $dev set noack_map 0xffff
    #iw dev $dev set bitrates legacy-2.4 12
    ip addr add dev $dev $dev_ip
    #ip link set dev $dev mtu $mtu
    #ip link set dev $dev txqueuelen $qlen
    #ip link set dev $dev promisc on
fi

exit 0

if ! module_is_loaded "batman_adv"; then
    echo Modprobing batman-adv module
    modprobe libcrc32c || exit 1
    insmod $module_path || exit 1
fi

if ! dev_has_ip $bat $bat_ip; then
    echo Adding $dev to batman-adv
    batctl -m $bat if add $dev || exit 1
    ip addr add dev $bat $bat_ip
    ip link set dev $bat mtu 1300
    ip link set dev $bat up
fi

if ! dev_has_mon $dev; then
    echo Adding monitor interface to $dev
    iw dev $dev interface add $mon type monitor
    ip link set dev $mon up
fi
