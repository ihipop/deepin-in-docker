#!/bin/bash
set -e
declare -r SCRIPT_NAME=$(readlink -f ${BASH_SOURCE[0]})
code_name=lion
apt_mirror='https://mirrors.aliyun.com/deepin'
rootfs_dir=$(realpath "$(dirname "$SCRIPT_NAME")"'/../tmp/')'/rootfs'
working_dir=$(realpath "$rootfs_dir"'/../')
rootfs_xz="$rootfs_dir"'.tar.xz'
if [ -e "$rootfs_dir" ];then
    mkdir -p "$rootfs_dir"
fi
echo $working_dir
cd $working_dir