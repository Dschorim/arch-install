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

echo "swap    LABEL=cryptswap    /dev/urandom    swap,offset=2048,cipher=aes-xts-plain64,size=512" >> /etc/crypttab

SWAP_LINE=$(cat /etc/fstab | grep swap)
NEW_SWAP_LINE="\/dev\/mapper\/swap    none    swap    defaults    0 0"

sed -i "s/$SWAP_LINE/$NEW_SWAP_LINE/" /etc/fstab

mount -a
