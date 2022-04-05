#!/bin/bash

echo "Checking if user is root..."
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

read -r -p "Please enter the swap partition name (e.g. /dev/sda2): " SWAP_PARTITION

re='^[0-9]+$'
if [ "$SWAP_PARTITION" = "" ]; then
    SWAP_PARTITION="/dev/sda2"
elif [[ $SWAP_PARTITION =~ $re ]]; then
    SWAP_PARTITION="/dev/sda$SWAP_PARTITION"
fi

swapoff "$SWAP_PARTITION"

echo "y" | mkfs.ext2 -L cryptswap "$SWAP_PARTITION" 1M

echo "swap    LABEL=cryptswap    /dev/urandom    swap.offset=2048,cipher=aes-xts-plain64,size=512" >> /etc/crypttab

SWAP_UUID=$(blkid -s UUID -o value "$SWAP_PARTITION")

echo $SWAP_UUID

sed -i "s/UUID=$SWAP_UUID/\/dev\/mapper\/swap/" /etc/fstab

mount -a
