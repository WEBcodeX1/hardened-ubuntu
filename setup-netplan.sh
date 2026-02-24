#!/bin/sh
netplan_dir="/etc/netplan"

# get env vars
netplan_if_name=`printenv NET_IF_NAME`
netplan_if_mac=`printenv NET_IF_MACADDRESS`
netplan_if_mtu=`printenv NET_IF_MTU`

netplan_wifi_if_name=`printenv NET_WIFI_IF_NAME`
netplan_wifi_auth_ssid=`printenv NET_WIFI_AUTH_SSID`
netplan_wifi_auth_pass=`printenv NET_WIFI_AUTH_PASS`

# remove networkmanager control
rm ${netplan_dir}/01-network-manager-all.yaml 2>/dev/null

# remove installer config
rm ${netplan_dir}/00-installer-config.yaml 2>/dev/null

# switch net management to networkd
cp ./01-networkd-all.yaml ${netplan_dir}/

# copy ethernet interface template
net_config_eth="02-net-if-config.yaml"
cp ./${net_config_eth} ${netplan_dir}/

# replace env vars
sed -i "s/\[NET_IF_NAME\]/${netplan_if_name}/g" ${netplan_dir}/${net_config_eth}
sed -i "s/\[NET_IF_MACADDRESS\]/${netplan_if_mac}/g" ${netplan_dir}/${net_config_eth}
sed -i "s/\[NET_IF_MTU\]/${netplan_if_mtu}/g" ${netplan_dir}/${net_config_eth}

# copy wifi interface template
if [ -n "${netplan_wifi_if_name}" ]; then
    net_config_wifi="03-net-wifi-config.yaml"
    cp ./${net_config_wifi} ${netplan_dir}/

    # replace env vars
    sed -i "s/\[NET_WIFI_IF_NAME\]/${netplan_wifi_if_name}/g" ${netplan_dir}/${net_config_wifi}
    sed -i "s/\[NET_WIFI_AUTH_SSID\]/${netplan_wifi_auth_ssid}/g" ${netplan_dir}/${net_config_wifi}
    sed -i "s/\[NET_WIFI_AUTH_PASS\]/${netplan_wifi_auth_pass}/g" ${netplan_dir}/${net_config_wifi}

    # copy global networkmanager dns config
    cp ./wifi-networkmanager-dns.conf /etc/NetworkManager/conf.d/90-dns.conf
fi

# correct permissions
chown root:root ${netplan_dir}/*
chmod 600 ${netplan_dir}/*

# apply settings
netplan apply
