#!/bin/bash

module_is_loaded()
{
    local module=$1
    local loaded=$(lsmod | grep -E "^$module")

    [[ -n "$loaded" ]]
}

batman_has_dev()
{
    local bat=$1
    local dev=$2

    [[ -n "$(batctl -m $bat if | grep $dev)" ]]
}

dev_has_ip()
{
    local dev=$1
    local ip=$2

    [[ -n "$(ip link | grep $dev)" && -n "$(ip addr show dev $dev | grep $ip)" ]]
}

dev_has_mon()
{
    local dev=$1
    local dev_addr="/sys/class/net/$dev/address"
    local id=$(echo $dev | sed -E "s/^[a-z]+//")
    local mon_path="/sys/class/net/mon$id"
    local mon_addr="$mon_path/address"

    [[ -d $mon_path && "$(cat $dev_addr)" == "$(cat $mon_addr)" ]]
}
