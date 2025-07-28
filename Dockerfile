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
RUN echo "wireshark-common wireshark-common/install-setuid boolean false" | debconf-set-selections && \
    apt-get update && \
    apt-get install -y --no-install-recommends wireshark adwaita-qt curl jq ca-certificates && \
    ARCH=$(dpkg --print-architecture) && \
    LATEST_RELEASE=$(curl -s https://api.github.com/repos/siemens/cshargextcap/releases/latest | jq -r .tag_name) && \
    curl -L -o /tmp/cshargextcap.deb "https://github.com/siemens/cshargextcap/releases/download/${LATEST_RELEASE}/cshargextcap_${LATEST_RELEASE#v}_linux_${ARCH}.deb" && \
    dpkg -i /tmp/cshargextcap.deb || apt-get -f install -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/cshargextcap.deb

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh