#!/bin/bash
set -e
if [ "$(whoami)" != "root" ]
then
    sudo bash "$0"
    exit $?
fi
source "$(dirname "$0")"'/common.sh'

if [ -f "$rootfs_xz" ];then
    echo "$rootfs_xz"' exists,quiting'
    exit 0
fi
echo 'set rootfs dir: '" $rootfs_dir"

if ! ls -la  "$working_dir"/deepin-keyring/keyrings/deepin-archive*.gpg >/dev/null 2>&1;then
    git clone https://github.com/linuxdeepin/deepin-keyring "$working_dir"/deepin-keyring/
fi
ls -la  "$working_dir"/deepin-keyring/keyrings/deepin-archive*.gpg

sudo apt install debootstrap
sudo ln -sf /usr/share/debootstrap/scripts/sid /usr/share/debootstrap/scripts/lion
rm -rf "$rootfs_dir"
sudo debootstrap --variant=minbase --keyring=$(readlink -f "$working_dir"/deepin-keyring/keyrings/deepin-archive*.gpg) ${code_name} "$rootfs_dir" ${apt_mirror}
sudo cp -av "$working_dir"/deepin-keyring/keyrings/*.gpg "$rootfs_dir"/etc/apt/trusted.gpg.d/
sudo cat <<EOF | sudo tee "$rootfs_dir"/usr/local/bin/clean-docker-img.sh > /dev/null
#/bin/bash
set -e
unset HISTFILE
apt autoremove && apt autoclean && apt clean && \
find /var/lib/apt/lists/ -type f -delete && \
find /var/cache -type f -delete && \
find /var/log -type f -delete && \
find /usr/share/locale/ -mindepth 1 -not -name "zh_CN" -not -name 'en' -delete && \
rm -rf /usr/share/man/ /usr/share/doc /tmp/* && \
echo 'deb [by-hash=force] ${apt_mirror} ${code_name} main contrib non-free' > /etc/apt/sources.list
EOF
chmod +x "$rootfs_dir"/usr/local/bin/clean-docker-img.sh
sudo chroot "$rootfs_dir" /usr/local/bin/clean-docker-img.sh
rm -f "$rootfs_xz" && cd  "$rootfs_dir" && sudo tar -Jcvf "$rootfs_xz" -- *