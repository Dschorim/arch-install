#!/bin/bash

# paru (aur wrapper)
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
cd ..

# copy over default sway config
cp /etc/sway/config ~/.config/sway/config