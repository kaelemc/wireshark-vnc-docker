FROM jlesage/baseimage-gui:debian-11-v4

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    SCREEN_WIDTH=1280 \
    SCREEN_HEIGHT=720 \
    SCREEN_DEPTH=24 \
    APP_NAME="Wireshark" \
    WIRESHARK_RUN_DUMPCAP_AS_ROOT=1

RUN sed -i "s/UI.initSetting('resize', resize);/UI.initSetting('resize', 'remote');/g" /opt/noVNC/app/ui.js

# Preseed wireshark debconf and install dependencies in one layer
COPY cshargextcap.deb /tmp/

RUN echo "wireshark-common wireshark-common/install-setuid boolean false" | debconf-set-selections && \
    apt-get update && \
    apt-get install -y --no-install-recommends wireshark && \
    apt-get install -y /tmp/cshargextcap.deb || apt-get -f install -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/cshargextcap.deb

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

EXPOSE 5900/tcp 5800/tcp