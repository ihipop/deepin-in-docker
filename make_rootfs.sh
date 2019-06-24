#!/bin/bash
set -e
if [ "$(whoami)" != "root" ]
then
    sudo su -s "$0"
    exit
fi
code_name=lion
apt_mirror='https://mirrors.aliyun.com/deepin'
rm -rf deepin-keyring && git clone https://github.com/linuxdeepin/deepin-keyring
sudo apt install debootstrap
sudo ln -sf /usr/share/debootstrap/scripts/sid /usr/share/debootstrap/scripts/lion
ls -la ./deepin-keyring/keyrings/deepin-archive*.gpg
sudo debootstrap --variant=minbase --keyring=$(readlink -f ./deepin-keyring/keyrings/deepin-archive*.gpg) ${code_name} rootfs ${apt_mirror}
sudo cp -av ./deepin-keyring/keyrings/*.gpg rootfs/etc/apt/trusted.gpg.d/
sudo chroot ./rootfs <<EOF
set -e
unset HISTFILE
apt autoremove && apt autoclean && apt clean
find /var/lib/apt/lists/ -type f -delete
find /var/cache -type f -delete
find /var/log -type f -delete
find /usr/share/locale/ -mindepth 1 -not -name "zh_CN" -not -name 'en' -delete
rm -rf /usr/share/man/ /usr/share/doc /tmp/*
echo 'deb [by-hash=force] ${apt_mirror} ${code_name} main contrib non-free' > /etc/apt/sources.list
EOF
rm -f rootfs.tar.xz && cd  rootfs && sudo tar -Jcvf ../rootfs.tar.xz *
