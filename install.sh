#!/usr/bin/env bash
set -e

if [ "`id -u`" != '0' ]; then
  echo "You need root permission to run this script. You may try this command instead: sudo $0"
  echo
  exit 1;
fi

cd $(dirname $0);
cp -fabTv ./src/ /
if [ -f ./mandos-keyscript.sysconfig ]; then
  cp -fabv ./mandos-keyscript.sysconfig /etc/sysconfig/mandos-keyscript
fi


# Re-enable in case we change mandos-keyscript.service 
if [ "`systemctl is-enabled mandos-keyscript`" = 'enabled' ]; then
  systemctl disable mandos-keyscript
  systemctl enable mandos-keyscript
fi

