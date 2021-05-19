#!/bin/bash

read -t 30 -r -s -p "Starting gnome install script. Enter to continue, ctrl + c to skip"

sudo pacman -Syu --noconfirm xorg gdm gnome-tweaks tracker3 arc-gtk-theme arc-icon-theme gnome-shell-extensions gnome-control-center xdg-user-dirs gnome-keyring file-roller gedit gnome-calculator gnome-font-viewer gnome-logs gnome-menus gnome-screenshot gnome-settings-daemon gnome-system-monitor gnome-themes-extra nautilus sushi baobab

sudo systemctl enable gdm

# post_install.sh
chmod +x post_install.sh
sh post_install.sh
# post_install.sh
