#!/bin/bash

# set timezone
echo "Please enter the timezone you want to use (e.g 'Asia/Kolkata'):"
read timezone
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
# set hostname
echo "Please enter your hostname: "
read hostname
echo $hostname > /etc/hostname

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts

pacman -S $(cat packages.txt)

sed -i 's/Modules=()/Modules=(btrfs)/' /etc/mkinitcpio.conf

mkinitcpio -p linux

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id = Arch

grub-mkconfig -o /boot/grub/grub.cfg

echo "Setting up root password"
passwd

# prompt for user creation
echo "Please enter the username you want to create"
read username
useradd -mG wheel $username

# prompt for password for user
echo "Please enter the password for $username"
passwd $username

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

systemctl enable NetworkManager

bash ./custom-progs.sh
