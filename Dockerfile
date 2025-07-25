FROM jlesage/baseimage-gui:debian-11-v4

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    SCREEN_WIDTH=1280 \
    SCREEN_HEIGHT=800 \
    SCREEN_DEPTH=24 \
    APP_NAME="Wireshark" \
    WIRESHARK_RUN_DUMPCAP_AS_ROOT=1

RUN echo "wireshark-common wireshark-common/install-setuid boolean false" | debconf-set-selections

COPY cshargextcap.deb /tmp/cshargextcap.deb

RUN apt-get update && apt-get install -y --no-install-recommends wireshark /tmp/cshargextcap.deb && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN rm /tmp/cshargextcap.deb

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh
