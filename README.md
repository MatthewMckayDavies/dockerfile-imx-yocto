# dockerfile-ub16-imx6-yocto
Ubuntu 16.04 i.MX6 Yocto development.


# i.MX6 4.9.11 BSP

Notes:

After repo init/sync in the imx-4.9.11-1.0.0_ga BSP directory...

There are two things to fix before launching the build.

 1. The connectivity check. Search the .inc files for example.com and swap for another URL.
 2. Update the firmware-imx 6.0 recipe and change the IMX_FIRMWARE_SRC URL to "git://github.com/NXP/imx-firmware;protocol=git".


Launch Yocto container from the directory that contains the imx-4.9.11-1.0.0_ga directory
```
docker run --rm -it -v ${PWD}:/mnt/Yocto/users mmd/ub16-imx6-yocto /bin/bash
```

Move to the BSP directory

```
cd /mnt/Yocto/users/imx-4.9.11-1.0.0_ga
```

Example commands

```
DISTRO=fsl-imx-x11 MACHINE=imx6qsabresd source fsl-setup-release.sh -b build-x11
bitbake fsl-image-validation-imx
source setup-environment build-x11
```

## Benchmarks

 Build system: Ryzen 7 3700X, 64 GB RAM, Windows 10 Pro, built via Ubuntu 20 (WSL 2) and Docker (WSL 2 backend).

  - fsl-image-validation-imx, compile only (no downloads) - 53 minutes.
  - Add Chromium to local.conf, fetch and compilation of extra packages - 1 hour 8 mins (Chromium: 47 mins compiling, 7 mins linking).
