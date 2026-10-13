#!/bin/sh

# replace http URL with https
sed -i 's/http:/https:/g' /etc/apt/sources.list.d/ubuntu.sources

# replace default archive URL with configured mirror if MIRROR_ADDRESS is set
if [ -n "${MIRROR_ADDRESS}" ]; then
    sed -i "s|https\?://archive\.ubuntu\.com/ubuntu|${MIRROR_ADDRESS}|g" /etc/apt/sources.list.d/ubuntu.sources
fi
