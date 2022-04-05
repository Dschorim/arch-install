#!/bin/bash

# paru (aur wrapper)
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
cd ..
