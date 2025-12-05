#!/bin/sh
netplan_dir="/etc/netplan"

# get env vars
netplan_if_name=`printenv NET_IF_NAME`
netplan_if_mac=`printenv NET_IF_MACADDRESS`
netplan_if_mtu=`printenv NET_IF_MTU`

# remove networkmanager control
rm ${netplan_dir}/01-network-manager-all.yaml 2>/dev/null

# remove installer config
rm ${netplan_dir}/00-installer-config.yaml 2>/dev/null

# switch net management to networkd
cp ./01-networkd-all.yaml ${netplan_dir}/

# copy interface template
cp ./02-net-if-config.yaml ${netplan_dir}/

# replace env vars
sed -i "s/\[NET_IF_NAME\]/${netplan_if_name}/g" ${netplan_dir}/02-net-if-config.yaml
sed -i "s/\[NET_IF_MACADDRESS\]/${netplan_if_mac}/g" ${netplan_dir}/02-net-if-config.yaml
sed -i "s/\[NET_IF_MTU\]/${netplan_if_mtu}/g" ${netplan_dir}/02-net-if-config.yaml

# correct permissions
chown root:root ${netplan_dir}/*
chmod 600 ${netplan_dir}/*

# apply settings
netplan apply
