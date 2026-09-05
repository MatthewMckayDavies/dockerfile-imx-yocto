FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Setup timezone
ARG TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update and upgrade
RUN apt-get update && apt-get -y upgrade

# Set up locale
RUN apt-get install -y locales tzdata \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8

# Install basics
RUN apt-get install -y gawk wget gcc git libacl1 liblz4-tool diffstat file unzip texinfo gcc-multilib \
    build-essential chrpath socat cpio pylint python3 python3-pip python3-pexpect python3-subunit \
    xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
    xterm rsync curl zstd lz4 libssl-dev efitools 

RUN apt-get install -y autoconf automake autotools-dev libncurses-dev
RUN apt-get install -y u-boot-tools xsltproc xmlstarlet subversion vim jq sqlite3 srecord tree

RUN apt-get install -y terminator tmux

RUN rm -rf /var/lib/apt/lists/*

# User management
RUN groupadd -g 1000 cmonkey && useradd -u 1000 -g 1000 -ms /bin/bash cmonkey && usermod -a -G sudo cmonkey && usermod -a -G users cmonkey

USER cmonkey

COPY --chown=cmonkey:cmonkey .Xdefaults /home/cmonkey
COPY --chown=cmonkey:cmonkey .Xdefaults /home/cmonkey/XTerm

# Git user setup
RUN git config --global user.email "cmonkey@cmonkey.com"
RUN git config --global user.name "cmonkey"

# Use volume mapping to map external build dir to /mnt/Yocto/users

# Workspace for Rootfs project checkout and dependencies
WORKDIR /home/workspace
