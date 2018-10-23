#!/usr/bin/env bash
#
# Copyright © 2018 seamus tuohy, <code@seamustuohy.com>
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the included LICENSE file for details.

# Setup

#Bash should terminate in case a command or chain of command finishes with a non-zero exit status.
#Terminate the script in case an uninitialized variable is accessed.
#See: https://github.com/azet/community_bash_style_guide#style-conventions
set -e
set -u

# TODO remove DEBUGGING
set -x

# Read Only variables

# readonly PROG_DIR=$(readlink -m $(dirname $0))
# readonly PROGNAME="$( cd "$( dirname "BASH_SOURCE[0]" )" && pwd )"



main() {
    check_dependencies
    # Get's USB_DEVICE
    id_usb_dev
    create_encrypted_drive

    mount_and_move
}

create_encrypted_drive() {
    echo "Can't format yet"
    echo "Just go to https://github.com/drduh/YubiKey-Guide#38a-linuxmacos"
    exit 1
    echo "Type:: o w"
    sudo fdisk "${USB_DEVICE::-1}"
    echo "Type:: n p 1 [ENTER] [ENTER] w"
    sudo fdisk "${USB_DEVICE::-1}"
    sudo cryptsetup luksFormat "${USB_DEVICE}"
    sudo cryptsetup luksOpen "${USB_DEVICE}" encrypted-usb
    sudo mkfs.ext4 /dev/mapper/encrypted-usb -L encrypted-usb
    sudo cryptsetup luksClose encrypted-usb
}


mount_and_move() {
  sudo cryptsetup luksOpen "${USB_DEVICE}" encrypted-usb
  sudo mount /dev/mapper/encrypted-usb /media/encrypted/
  sudo docker cp gnukeys:/root/.gnupg/exported_keys /media/encrypted/keys
  ls /media/encrypted/keys/
  sync
  sudo umount /media/encrypted
  sudo cryptsetup luksClose encrypted-usb
  sync
}

id_usb_dev() {
    printf "Plug in your USB now.\n"
    printf "Press Return when you have done so\n"
    read
    printf "\n\n==============DMESG OUTPUT=============\n"
    sudo dmesg  | tail | grep -EB 10 "s[a-z]{2}\:\s*s[a-z]{2}[0-9]"
    printf "\n\n==============DMESG ENDS=============\n\n"
    printf "What is the device name of the harddrive?\n"
    printf "[ 1234.123456]  sxx: sxx1  < !THIS ONE! >\n"
    read devname
    USB_DEVICE="$devname"
}


check_dependencies() {
    printf "Checking Dependencies\n\n"
    printf "Do you see lvm2 and cryptsetup packages on the following lines?\n"
    printf "If not, you should install them.\n"
    dpkg --get-selections | grep -v deinstall | grep -E "^lvm2"
    dpkg --get-selections | grep -v deinstall | grep -E "^cryptsetup"
    sudo modprobe dm-crypt
    sudo modprobe dm-mod
}

cleanup() {
    # put cleanup needs here
    exit 0
}

trap 'cleanup' EXIT


main
