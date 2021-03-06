#!/usr/bin/env bash
set -e

if [ "`id -u`" != '0' ]; then
  echo "You need root permission to run this script. You may try this command instead: sudo $0"
  echo
  exit 1;
fi

cd $(dirname $0);
echo "Source: `pwd`"
mkdir -p /etc/sysconfig
#cp --preserve=timestamps -fabTv ./src/ / # DO NOT USE THIS or it will break the entire system.
cp --preserve=timestamps -fbv ./src/sbin/mandos-keyscript /sbin/mandos-keyscript
cp --preserve=timestamps -fbv ./src/sbin/mandos-keyscript-poststart /sbin/mandos-keyscript-poststart
cp --preserve=timestamps -fbv ./src/sbin//mandos-keyscript-start /sbin/mandos-keyscript-start
cp --preserve=timestamps -fbv ./src/etc/sysconfig/mandos-keyscript /etc/sysconfig/mandos-keyscript
cp --preserve=timestamps -fbv ./src/etc/systemd/system/mandos-keyscript.service /etc/systemd/system/mandos-keyscript.service
cp --preserve=timestamps -fbv ./src/etc/systemd/system/mandos-keyscript-drbd-zfs.service /etc/systemd/system/mandos-keyscript-drbd-zfs.service
if [ -f ./mandos-keyscript.sysconfig ]; then
  cp --preserve=timestamps -fbv ./mandos-keyscript.sysconfig /etc/sysconfig/mandos-keyscript
fi

chmod -cv 0755 \
  /sbin/mandos-keyscript \
  /sbin/mandos-keyscript-poststart \
  /sbin/mandos-keyscript-start

chmod -cv 0644 \
  /etc/sysconfig/mandos-keyscript \
  /etc/systemd/system/mandos-keyscript.service \
  /etc/systemd/system/mandos-keyscript-drbd-zfs.service

chown -cv root.root \
  /sbin/mandos-keyscript \
  /sbin/mandos-keyscript-poststart \
  /sbin/mandos-keyscript-start \
  /etc/sysconfig/mandos-keyscript \
  /etc/systemd/system/mandos-keyscript.service \
  /etc/systemd/system/mandos-keyscript-drbd-zfs.service

# Disable mandos-client initramfs tools
chmod -cv 0 \
  /usr/share/initramfs-tools/conf-hooks.d/mandos \
  /usr/share/initramfs-tools/hooks/mandos \
  /usr/share/initramfs-tools/scripts/init-premount/mandos \
  /usr/share/lintian/overrides/mandos-client

systemctl disable mandos-keyscript
systemctl enable mandos-keyscript
systemctl disable mandos-keyscript-drbd-zfs
systemctl enable mandos-keyscript-drbd-zfs
