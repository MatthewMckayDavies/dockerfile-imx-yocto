FROM ubuntu:16.04

# Update and upgrade
RUN apt-get update && apt-get -y upgrade

# Install basics
RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
build-essential chrpath socat libsdl1.2-dev xterm sed cvs subversion coreutils texi2html \
docbook-utils python-pysqlite2 help2man desktop-file-utils curl \
libgl1-mesa-dev libglu1-mesa-dev mercurial autoconf automake groff curl lzop asciidoc \
u-boot-tools xsltproc xmlstarlet xz-utils debianutils iputils-ping cpio vim

# Set up locale
RUN apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# User management
RUN groupadd -g 1000 cmonkey && useradd -u 1000 -g 1000 -ms /bin/bash cmonkey && usermod -a -G sudo cmonkey && usermod -a -G users cmonkey

USER cmonkey

# Git user setup
RUN git config --global user.email "cmonkey@cmonkey.com"
RUN git config --global user.name "cmonkey"

# Use volume mapping to map external build dir to /mnt/Yocto/users

# Workspace for Rootfs project checkout and dependencies
WORKDIR /home/workspace