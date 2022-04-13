#!/bin/bash

# paru (aur wrapper)
sudo pacman -S --needed --noconfirm base-devel
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
cd ..

paru -S mkinitcpio-numlock
sudo mkinitcpio -P

read -r -p "Do you want to encrypt your swap? (Y/n): " ENCRYPT_SWAP

if [ "$ENCRYPT_SWAP" = "n" ]; then
    echo "Skipping swap encryption..."
else
    sudo bash ./encrypt-swap.sh
fi

read -r -p "Do you want to install i3? (Y/n): " INSTALL_I3

if [ "$INSTALL_I3" = "n" ]; then
    echo "Skipping i3 installation..."
else
    bash ./install-i3.sh
fi

read -r -p "Do you want to install vscode? (Y/n): " INSTALL_VSCODE

if [ "$INSTALL_VSCODE" = "n" ]; then
    echo "Skipping vscode installation..."
else
    bash ./install-vscode.sh
fi

read -r -p "Do you want to install tmux? (Y/n): " INSTALL_TMUX

if [ "$INSTALL_TMUX" = "n" ]; then
    echo "Skipping tmux installation..."
else
    bash ./install-tmux.sh
fi

read -r -p "Do you want to install zsh? (Y/n): " INSTALL_ZSH

if [ "$INSTALL_ZSH" = "n" ]; then
    echo "Skipping zsh installation..."
else
    bash ./install-zsh.sh
fi

read -r -p "Do you want to install nvidia drivers? (Y/n): " INSTALL_NVIDIA

if [ "$INSTALL_NVIDIA" = "n" ]; then
    echo "Skipping nvidia drivers installation..."
else
    bash ./install-nvidia.sh
fi

read -r -p "Do you want to install amd drivers? (y/N): " INSTALL_AMD

if [ "$INSTALL_AMD" = "y" ]; then
    bash ./install-amdgpu.sh
else
    echo "Skipping amd drivers installation..."
fi
