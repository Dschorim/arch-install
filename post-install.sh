#!/bin/bash

# paru (aur wrapper)
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
cd ..

# copy over default sway config
mkdir -p ~/.config/sway
cp /etc/sway/config ~/.config/sway/config

echo "alias ll='ls -la'" >> ~/.bashrc
echo "alias sway='WLR_NO_HARDWARE_CURSORS=1 sway'" >> ~/.bashrc
