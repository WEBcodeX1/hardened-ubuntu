#!/bin/sh

# package upgrade
apt-get update -y
apt-get upgrade -y

# get env vars
nextdns_id=`printenv NEXTDNS_ID`
nextdns_stamp=`printenv NEXTDNS_STAMP`

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

# restart dnscrypt-proxy
systemctl restart dnscrypt-proxy
