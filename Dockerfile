FROM debian:buster
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
    apt-transport-https gnupg curl cabextract unzip winbind xvfb wine && \
    apt-get clean
# RUN curl -O https://dl.winehq.org/wine-builds/Release.key && \
#     apt-key add Release.key && \
#     rm Release.key && \
#     echo deb https://dl.winehq.org/wine-builds/debian/ stretch main > /etc/apt/sources.list.d/winehq.list && \
#     apt-get update && \
#     apt-get install -y --install-recommends \
#      winehq-stable && \
#     apt-get clean
RUN curl  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /usr/local/bin/winetricks && \
    chmod +x /usr/local/bin/winetricks

ENV USER_PATH /opt/wineuser
RUN useradd -b /opt -m -d ${USER_PATH} wineuser
RUN mkdir /wine /Data && chown wineuser.wineuser /wine /Data
USER wineuser
ENV WINEPREFIX=/wine

ENTRYPOINT [ "wine" ]
