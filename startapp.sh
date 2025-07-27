#!/bin/bash

mkdir -p /pcaps
cd /pcaps

# Use the packetflix link if provided
if [ -n "${PACKETFLIX_LINK:-}" ]; then
    exec /usr/bin/wireshark -k -i packetflix -o "extcap.packetflix.url:${PACKETFLIX_LINK}"
else
    exec /usr/bin/wireshark
fi