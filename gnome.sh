#!/bin/bash

sudo pacman -S --noconfirm xorg gdm gnome gnome-extra gnome-tweaks tracker arc-gtk-theme arc-icon-theme

sudo systemctl enable gdm

echo "Gnome and xorg installation completed"
read -t 10 -r -s -p "Warning! Rebooting, enter to continue or ctrl + c to abort...

exit
umount -a
reboot
