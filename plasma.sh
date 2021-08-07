#!/bin/bash

set -e

read -t 30 -r -s -p "Starting plasma install script. Enter to continue, ctrl + c to skip"

pacman -Syu discover plasma-wayland-session plasma-desktop plasma-nm plasma-pa dolphin konsole kdialog kinfocenter plasma-firewall cronie kcron kate ffmpegthumbs svgpart okular spectacle kdegraphics-thumbnailers kcolorchooser gwenview ksystemlog kdeconnect ark kcalc kfind yakuake plasma-systemmonitor sddm-kcm plasma-browser-integration filelight partitionmanager kde-gtk-config kscreen kwrited powerdevil breeze-gtk rsync packagekit-qt5 plasma-disks numlockx
systemtcl enable sddm
read -t 30 -r -s -p "installation done, restart recommended"

