# Docker wine

Docker image to start windows executables via
[wine](https://www.winehq.org/). Winetricks is already installed.

Since the `ENTRYPOINT` is sent to /usr/bin/wine, child images need
only supply a `CMD` to the path of the .exe file to run.

`C:` will get mapped to `/wine/drive_c`.

The image has been inspired by
[jamesnetherton/wine](https://hub.docker.com/r/jamesnetherton/wine/). Thanks!

## Building

    docker build . -t bbowe/wine

## Running

   docker run --rm -it -v /tmp/.X11-unix/:/tmp/.X11-unix/ -e DISPLAY=${DISPLAY} jamesnetherton/wine calc.exe

## Extending

For more sophisticated usage extending this image is required.

    FROM bbowe/wine
    RUN winetricks -q corefonts
    ENTRY