# dockerfile-imx-yocto
Ubuntu 20.04 i.MX Yocto development.

## Build image

With or without cache:

```
docker image build --rm --no-cache -t mmd/imx-yocto:ub20 .
docker image build --rm  -t mmd/imx-yocto:ub20 .
```


## About the image

There is a user 'cmonkey' with uid/gid 1000 which is a member of the sudo group.

/home/workspace is the default folder which may be mapped for example to the host's Eclipse workspace. The Yocto BSP dir on the host, which has previously been obtained via repo init/sync etc. may be mapped to /mnt/Yocto/users.

In order to use bitbake -c menuconfig, devshell etc. which opens an additional shell, it is necessary to pass the DISPLAY environment variable and possibly also map the unix X11 pipe, see the WSL2 and Ubuntu examples below: 

## Run xterm from Ubuntu or recent WSL2 on Windows 11/10:

```
docker run -it --rm \
-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
-v "$PWD"/Yocto:/mnt/Yocto/users -v "$PWD":/home/workspace \
mmd/imx-yocto:ub20 xterm
```

## Bitbake

From the Yocto BSP dir.

First build after repo init/sync, accepting EULA etc:

```
DISTRO=fsl-imx-xwayland MACHINE=imx8mqevk source imx-setup-release.sh -b imx8mqevk_xwayland
bitbake imx-image-multimedia
```

Subsequent builds:

```
source setup-environment imx8mqevk_xwayland/
bitbake imx-image-multimedia
```