#!/bin/bash
set -e
code_name=lion
apt_mirror='https://mirrors.aliyun.com/deepin'
rootfs_dir=$(realpath "$(dirname "$0")"'/../tmp/')'/rootfs'
rootfs_xz="$rootfs_dir"'.tar.xz'
if [ -e "$rootfs_dir" ];then
    mkdir -p "$rootfs_dir"
fi
cd "$(dirname "$0")"