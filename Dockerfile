FROM debian:bullseye
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
    apt-transport-https gnupg curl cabextract unzip winbind xvfb \
    wine32 \
    && apt-get clean
# https://wiki.winehq.org/Debian:
#RUN curl -LO https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/i386/libfaudio0_20.01-0~buster_i386.deb \
#         -LO https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/libfaudio0_20.01-0~buster_amd64.deb \
#         -LO https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/all/libfaudio-dev_20.01-0~buster_all.deb \
#    && apt install -y ./libfaudio0_20.01-0~buster_i386.deb \
    #./libfaudio0_20.01-0~buster_amd64.deb \
#    && rm libfaudio* && \
#    apt-get clean

#ENV WINE_VERSION=4.20~buster
#RUN curl -O https://dl.winehq.org/wine-builds/winehq.key && \
#    apt-key add winehq.key && \
#    rm winehq.key && \
#    echo deb https://dl.winehq.org/wine-builds/debian/ buster main > /etc/apt/sources.list.d/winehq.list && \
#    apt-get update && \
#    apt-get install -y --install-recommends \
#     wine-staging-i386=${WINE_VERSION} wine-staging:i386=${WINE_VERSION} winehq-staging:i386=${WINE_VERSION} && \
#    apt-get clean
# https://wiki.winehq.org/Gecko
RUN mkdir -p /usr/share/wine/gecko/ && cd /usr/share/wine/gecko/ && \
   curl -O http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86.msi
# https://wiki.winehq.org/Mono
RUN mkdir -p /usr/share/wine/mono && cd /usr/share/wine/mono && \
   curl -O https://dl.winehq.org/wine/wine-mono/6.3.0/wine-mono-6.3.0-x86.msi
RUN curl https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /usr/local/bin/winetricks && \
    chmod +x /usr/local/bin/winetricks
ENV USER_PATH /opt/wineuser
RUN useradd -b /opt -m -d ${USER_PATH} wineuser
RUN mkdir /wine /Data && chown wineuser.wineuser /wine /Data
USER wineuser
RUN mkdir -p /opt/wineuser/.cache/winetricks/
ENV WINEPREFIX=/wine
ENV WINEARCH=win32
RUN wineboot --update && wineserver --wait

ENTRYPOINT [ "wine" ]
