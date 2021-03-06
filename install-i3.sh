#!/bin/bash

paru -S --noconfirm i3 i3status-rust j4-dmenu-desktop dmenu i3lock alsa pulseaudio xorg-xinit ly ttf-dejavu xclip pavucontrol imagemagick feh

mkdir -p ~/.config/i3
cp ./dotfiles/i3.config ~/.config/i3/config

mkdir -p ~/.config/i3status-rust
cp ./dotfiles/i3status.toml ~/.config/i3status-rust/config.toml

cp ./dotfiles/fehbg ~/.fehbg
