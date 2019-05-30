# pixelserv-tls-arm
Dockerized pixelserv-tls for ARM based Raspberry Pi

:information_source: This project is derived from [imTHAI/docker-pixelserv-tls](https://github.com/imTHAI/docker-pixelserv-tls).

## Features

* (From >v0.2) Based on [arm32v7/debian:jessie-slim](https://hub.docker.com/r/arm32v7/debian/).
* Image size is around 176MB.
* (For >v0.2) Based on [arm32v7/debian:buster-slim](https://hub.docker.com/r/arm32v7/debian/). HTTPS connection fails for unknown reason in buster based images.


## Using the docker image

* Pull the image from docker hub by doing,

```bash
docker pull protik77/pixelserv-tls-arm
```

* Create a script named `run_container.sh` by copying the code below.

```bash
#!/bin/bash

SERVICE=rpi_pix
TAG=protik77/pixelserv-tls-arm

# stop if running
docker container stop $SERVICE

# remove container
docker container rm $SERVICE

docker container run \
    -d \
    --name $SERVICE \
    -p 80:80 \
    -p 443:443 \
    -v $(pwd)/cache:/var/cache/pixelserv \
    --restart unless-stopped \
    $TAG

docker container exec -it $SERVICE chown -R nobody /var/cache/pixelserv
```
* Give the script executable permission by doing,

```bash
chmod u+x run_container.sh
```
* Generate a CA cert using pixelserv developer kvic's [guide](https://github.com/kvic-z/pixelserv-tls/wiki/Create-and-Import-the-CA-Certificate#generate-your-pixelserv-ca-cert).

* Now one should have a `ca.crt` and `ca.key` file from the key generation command.
* Create a directory named `cache` in the same directory as the `run_container.sh` script.
* Copy the `ca.crt` and `ca.key` file into the `cache` directory.
* Now from the same directory, run the `run_container.sh` script by doing,

```bash
./run_container.sh
```

This script defines two variables named `SERVICE` and `TAG`. The `SERVICE` variable is the name of the container or the service. The `TAG` variable is the docker hub image name. The script first stops any running container or service of the same name and then removes it. If the container or service does not exist, it will throw an error but the rest of the commands will run without any issues. Finally creates another container or service with the same name. Along the way it mounts the `cache` directory to the `/var/cache/pixelserv` directory, opens port 80 and 443 and sets `restart` policy to `unless-stopped`. Finally in the last line, the necessary permissions are given to the `/var/cache/pixelserv` directory.

## Final folder structure

If the folder is named `pixelserv-tls-arm`, then the final folder structure should look something like this,

```bash
pixelserv-tls-arm
├── cache
│   ├── ca.crt
│   └── ca.key
└── run_container.sh

```

## What's different? Or why not [imTHAI/docker-pixelserv-tls](https://github.com/imTHAI/docker-pixelserv-tls)?

* The [imTHAI/docker-pixelserv-tls](https://github.com/imTHAI/docker-pixelserv-tls) image is based on `alpine` image which does not work on Raspberry Pi, as it's based on ARM processor.
* I am not very familiar with `alpine`, so could not stabilize the `alipine` based image on my Raspberry Pi. The image was very unstable. So decided to change the base image to a `debian` based one. So far in my testing, the image is rock solid.
* Even though the size is a bit larger compared to the `alpine` one, use of debian based image provides stability and extensibility.

