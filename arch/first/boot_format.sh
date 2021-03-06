#!/bin/bash

# $ gdisk /dev/nvme*n*
# Boot      : 255MB: EF00
# Encrypted : FREE:  8E00


if [[ $# != 1 ]]; then
  echo "${0##*/}: Requires 1 argument." 1>&2
  exit 16
fi

if [[ ! -b $1 ]]; then
  echo "${0##*/}: $1 isn't a device file." 1>&2
  exit 32
fi

if ! type "mkfs.fat" > /dev/null 2>&1; then
  echo "${0##*/}: mkfs.fat command isn't found." 1>&2
  exit 64
fi

mkfs.fat -vcF 32 -n BOOT $1
exit $?
