#!/bin/sh

# package upgrade
apt-get update -y
apt-get upgrade -y

# get env vars
nextdns_id=`printenv NEXTDNS_ID`
nextdns_stamp=`printenv NEXTDNS_STAMP`
chrony_ntp_server_ip=`printenv NET_NTP_STATIC_SERVER`

# install chronyd (NTP client)
apt-get install -qy chrony

# install usbguard
apt-get install -qy usbguard

# install dnscrypt-proxy
apt-get install -qy dnscrypt-proxy

# install libnss-resolve for command line resolving
apt-get install -qy libnss-resolve

# copy nsswitch config
cp ./nsswitch.conf /etc/nsswitch.conf

# copy systemd resolved.conf (using local dnscrypt-proxy)
cp ./resolved.conf /etc/systemd/resolved.conf

# copy dnscrypt-config (next-dns template)
cp ./dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml

# disable / mask dnscrypt resolvconf service
systemctl disable dnscrypt-proxy-resolvconf.service
systemctl mask dnscrypt-proxy-resolvconf.service

# replace env vars
sed -i "s/\[NEXTDNS_ID\]/${nextdns_id}/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
sed -i "s/\[NEXTDNS_STAMP\]/${nextdns_stamp}/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml

# set static chrony config
cp ./chrony.conf /etc/chrony/
chmod 644 /etc/chrony/chrony.conf
sed -i "s/\[NET_NTP_STATIC_SERVER\]/${chrony_ntp_server_ip}/g" /etc/dnscrypt-proxy/dnscrypt-proxy.toml

# restart chronyd
systemctl restart chrony.service
systemctl restart chronyd.service

# restart dnscrypt-proxy
systemctl restart dnscrypt-proxy
