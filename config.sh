#!/bin/sh

# netplan ethernet
export NET_IF_NAME="enp2s0"
export NET_IF_MACADDRESS="12:34:56:78:9a:9b"
export NET_IF_MTU="9000"

# netplan wifi
export NET_WIFI_IF_NAME="wlp0s20f3"
export NET_WIFI_AUTH_SSID="Wifi-SSID"
export NET_WIFI_AUTH_PASS="Wifi-Password"

# nextdns
export NEXTDNS_ID="a1b2c3"
export NEXTDNS_STAMP="Base64Hash"

# kernel
export KERNEL_DOMAIN_NAME="domain.name"

# sysusers (must exist in autoinstall.yaml)
export USER_IDS="admin user1"
