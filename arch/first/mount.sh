#!/bin/bash

mount() {
  if [[ $# != 1 ]]; then
    echo "${0##*/}: Requires 1 argument." >&1
    return 16
  fi

  if [[ ! -b $1 ]]; then
    echo "${0##*/}: $1 isn't a device file." >&1
    return 32
  fi


  mount /dev/mapper/system-root /mnt
  result=$?; if [[ $result != 0 ]]; then return $result;fi

  mkdir /mnt/boot
  # mkdir /mnt/boot /mnt/home
  result=$?; if [[ $result != 0 ]]; then return $result;fi

  mount $1 /mnt/boot
  # mount /dev/mapper/system-home /mnt/home
  result=$?; if [[ $result != 0 ]]; then return $result;fi

  return 0
}
