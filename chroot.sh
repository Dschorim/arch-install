#!/bin/bash

# set timezone
read -r -p "Please enter the timezone you want to use (e.g 'Asia/Kolkata'): " timezone
ln -sf "/usr/share/zoneinfo/$timezone" /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
# set hostname
read -r -p "Please enter your hostname: " hostname
echo "$hostname" > /etc/hostname

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts

pacman -S $(grep -v '^#' packages.txt)

sed -i 's/Modules=()/Modules=(btrfs)/' /etc/mkinitcpio.conf
sed -i 's/Hooks=(base udev autodetect modconf block filesystems keyboard fsck)/Hooks=(base udev autodetect modconf block encrypt filesystems keyboard fsck)/' /etc/mkinitcpio.conf

mkinitcpio -p linux

UUID=$(lsblk $1 -no UUID)

sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=$UUID:cryptroot root=/dev/mapper/cryptroot"' /etc/default/grub

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id = Arch

grub-mkconfig -o /boot/grub/grub.cfg

echo "Setting up root password"
passwd

# prompt for user creation
read -r -p "Please enter the username you want to create: " username
useradd -mG wheel "$username"

# prompt for password for user
echo "Please enter the password for $username"
passwd "$username"

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

systemctl enable NetworkManager
