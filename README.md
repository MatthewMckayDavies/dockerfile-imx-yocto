# dockerfile-imx-yocto
Ubuntu 18.04 i.MX  Yocto development.

## Build image

With or without cache:

```
docker image build --rm --no-cache -t mmd/imx-yocto:ub18 .
docker image build --rm  -t mmd/imx-yocto:ub18 .
```

If when building an image with bitbake, there are problems with 'fetch' similar to the error below, it is worth building the image with --no-cache to obtain the latest certificates.

fatal: unable to access ' https://source.codeaurora.org/external/imx/linux-imx.git/': server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none


## About the image

There is a user 'cmonkey' with uid/gid 1000 which is a member of the sudo group.

/home/workspace is the default folder which may be mapped for example to the host's Eclipse workspace. The Yocto BSP dir on the host, which has previously been obtained via repo init/sync etc. may be mapped to /mnt/Yocto/users.

In order to use bitbake -c menuconfig, devshell etc. which opens an additional shell, it is necessary to pass the DISPLAY environment variable and possibly also map the unix X11 pipe, see the WSL2 and Ubuntu examples below: 

## Run xterm with VcXsrv from Ubuntu WSL2

See [Ubuntu and WSL graphical apps](https://wiki.ubuntu.com/WSL#Running_Graphical_Applications) for more info.

```
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=1

docker run -it --rm \
-e DISPLAY=$DISPLAY \
-v "$PWD"/Yocto:/mnt/Yocto/users -v "$PWD":/home/workspace \
mmd/imx-yocto:ub18 xterm
```

## Run xterm from Ubuntu (native, VirtualBox etc.):

```
docker run -it --rm \
-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
-v "$PWD"/Yocto:/mnt/Yocto/users -v "$PWD":/home/workspace \
mmd/imx-yocto:ub18 xterm
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