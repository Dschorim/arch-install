#!/bin/bash

paru -S i3 i3status-rust j4-dmenu-desktop i3lock alsa pulseaudio

mkdir -p ~/.config/i3
cp ./dotfiles/i3.config ~/.config/i3/config

mkdir -p ~/.config/i3status-rust
cp ./dotfiles/i3status.toml ~/.config/i3status-rust/config
