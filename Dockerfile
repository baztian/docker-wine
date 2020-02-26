FROM debian:buster
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
    apt-transport-https gnupg curl cabextract unzip winbind xvfb \
    # wine \
    && apt-get clean
# https://wiki.winehq.org/Debian:
RUN curl -LO https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/i386/libfaudio0_20.01-0~buster_i386.deb \
#         -LO https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/libfaudio0_20.01-0~buster_amd64.deb \
#         -LO https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/all/libfaudio-dev_20.01-0~buster_all.deb \
    && apt install -y ./libfaudio0_20.01-0~buster_i386.deb \
    #./libfaudio0_20.01-0~buster_amd64.deb \
    && rm libfaudio* && \
    apt-get clean

ENV WINE_VERSION=4.20~buster
RUN curl -O https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    rm winehq.key && \
    echo deb https://dl.winehq.org/wine-builds/debian/ buster main > /etc/apt/sources.list.d/winehq.list && \
    apt-get update && \
    apt-get install -y --install-recommends \
     wine-staging-i386=${WINE_VERSION} wine-staging:i386=${WINE_VERSION} winehq-staging:i386=${WINE_VERSION} && \
    apt-get clean
# https://wiki.winehq.org/Gecko
RUN mkdir -p /opt/wine-staging/gecko/ && cd /opt/wine-staging/gecko/ && \
   curl http://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86.tar.bz2 | tar xj
# https://wiki.winehq.org/Mono
RUN mkdir -p /opt/wine-staging/mono && cd /opt/wine-staging/mono && \
   curl -O https://dl.winehq.org/wine/wine-mono/4.9.4/wine-mono-4.9.4.msi
RUN curl https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /usr/local/bin/winetricks && \
    chmod +x /usr/local/bin/winetricks
ENV USER_PATH /opt/wineuser
RUN useradd -b /opt -m -d ${USER_PATH} wineuser
RUN mkdir /wine /Data && chown wineuser.wineuser /wine /Data
USER wineuser
ENV WINEPREFIX=/wine
ENV WINEARCH=win32
RUN wineboot --update && wineserver --wait

ENTRYPOINT [ "wine" ]
