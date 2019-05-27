# pixelserv-tls-arm
Dockerized pixelserv-tls for ARM based Raspberry Pi

:warning: This project is inherited from [imTHAI/docker-pixelserv-tls](https://github.com/imTHAI/docker-pixelserv-tls).

## Features

* Based on `[arm32v7/debian:buster-slim](https://hub.docker.com/r/arm32v7/debian/)`.
* Image size is around 200MB.


## Using the docker image

* Pull the image from docker hub by doing,

```bash
docker pull protik77/pixelserv-tls-arm
```

```bash
#!/bin/bash

SERVICE=rpi_pix
TAG=pixr

# stop if running
docker container stop $SERVICE

# remove container
docker container rm $SERVICE

docker container run \
	-d \
	--name $SERVICE \
    -p 80:80 \
    -p 443:443 \
    -v /home/pi/build_docker/docker-pixelserv-tls/pixelserv/cache:/var/cache/pixelserv \
	--restart unless-stopped \
	$TAG

docker container exec -it $SERVICE chown -R nobody /var/cache/pixelserv
```

## Changes made from the original repository

* Python `3.4.2` based.
* Based on official `arm32v7/debian:buster-slim`.
