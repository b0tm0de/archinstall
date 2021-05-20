#!/bin/bash

set -e

read -t 30 -r -s -p "Starting gnome install script. Enter to continue, ctrl + c to skip"

sudo pacman -Syu --noconfirm gdm gnome-tweaks gnome-terminal tracker3 dconf-editor arc-gtk-theme arc-icon-theme gnome-shell-extensions gnome-control-center xdg-user-dirs gnome-keyring file-roller gedit gnome-calculator gnome-font-viewer gnome-logs gnome-menus gnome-screenshot gnome-settings-daemon gnome-system-monitor gnome-themes-extra nautilus sushi baobab
sed -i '5s/^.//' /etc/gdm/custom.conf
systemctl enable gdm

# post_install.sh
chmod +x /archinstall/post_install.sh
sh /archinstall/post_install.sh
# post_install.sh
