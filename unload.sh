#!/bin/bash

. functions.sh

n=$1

if [[ -n "$n" ]] && dev_has_mon "wlan$n"; then
    echo Removing monitor interface mon$n
    iw mon$n interface del
    exit 0
fi



if module_is_loaded "batman_adv"; then
    echo Removing batman-adv module
    rmmod batman_adv || exit 1
fi

if module_is_loaded "mac80211_hwsim"; then
    echo Removing mac80211_hwsim module
    rmmod mac80211_hwsim || exit 1
fi


