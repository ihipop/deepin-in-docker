#!/bin/bash
set -e
source "$(dirname "$0")"'/common.sh'
if [ -f "$rootfs_xz" ];then
    sudo bash ./make_rootfs.sh
fi
sudo docker build -t ihipop/deepin:lion "$rootfs_dir/../" -f "$rootfs_dir/../../Dockerfile"
