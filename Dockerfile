FROM arm32v7/debian:jessie-slim

LABEL maintainer="Protik <protik77@gmail.com>"
LABEL description="pixelserv-tls for arm based hardware"

# needed for automated build in docker hub.
# for details, see: https://github.com/docker/hub-feedback/issues/1261
COPY qemu-arm-static /usr/bin

ENV server pixelserv-tls
RUN mkdir -p /tmp/pixelserv
WORKDIR /tmp/pixelserv

# install necessary softwares
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        git \
        ca-certificates \
        easy-rsa \
        gcc \
        libc6-dev \
        make \
        autoconf \
        openssl \
        automake \
        libssl-dev

# download, compile and copy pixelserv executable
RUN git clone https://github.com/kvic-z/${server}.git . \
    && autoreconf -i \
    && ./configure \
    && make \
    && find . \! -name "$server" -delete \
    && chmod +x $server \
    && mv $server /usr/sbin

WORKDIR /usr/sbin

# cleanups
RUN rm -rf /tmp/pixelserv \
    && apt-get remove -y \
        make \
        automake \
        git \
    && apt-get autoremove -y \
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/*

EXPOSE 80/tcp 443/tcp

ENTRYPOINT ["pixelserv-tls","-f"]
CMD ["-u", "root", "-l", "5"]

