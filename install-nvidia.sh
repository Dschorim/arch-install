#!/bin/bash

paru -S --noconfirm nvidia

sudo sed -i 's/MODULES=(btrfs)/MODULES=(btrfs nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
sudo mkinitcpio -P

sudo sed -i "s/root=\/dev\/mapper\/cryptroot\"/root=\/dev\/mapper\/cryptroot rd.driver.blacklist=nouveau nvidia-drm.modeset=1\"/" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo nvidia-xconfig
