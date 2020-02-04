#!/bin/bash


lvm_on_luks(){
  if [[ $# != 1 ]]; then
    echo "${0##*/}: Requires 1 argument." >&1
    exit 16
  fi

  if [[ ! -b $1 ]]; then
    echo "${0##*/}: $1 isn't a device file." >&1
    exit 32
  fi

  # Enter password
  echo "Set password for Device."
  read -sp "Enter passphrase: " passphrase
  echo
  read -sp "Verify passphrase: " verify
  echo

  if [[ $passphrase != $verify ]]; then
    echo "${0##*/}: Sorry, passphrases do not match." >&1
    return 10
  fi

  cryptsetup -v -c serpent-xts-plain64 -s 512 -h sha512 luksFormat $1
  result=$?; if [[ $result != 0 ]]; then return $result;fi

  # Are you sure? (Type uppercase yes): YES
  # Enter passphrase for /dev/sda2: 
  # Verify passphrase: 

  cryptsetup luksOpen $1 decrypted
  result=$?; if [[ $result != 0 ]]; then return $result;fi

  # Enter passphrase for /dev/sda2:

  pvcreate /dev/mapper/decrypted
  result=$?; if [[ $result != 0 ]]; then return $result;fi

  vgcreate system /dev/mapper/decrypted
  result=$?; if [[ $result != 0 ]]; then return $result;fi

  lvcreate -l 100%FREE system -n root
  result=$?; if [[ $result != 0 ]]; then return $result;fi


  # For next version
  # lvcreate -L 50G system -n root
  # lvcreate -l 100%FREE system -n home

  mkfs.xfs /dev/mapper/system-root
  result=$?; if [[ $result != 0 ]]; then return $result;fi

  # mkfs.xfs /dev/mapper/system-home

  return 0
}
