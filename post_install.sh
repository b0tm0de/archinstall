#!/bin/bash

set -e

cd /
read -t 30 -r -s -p "Starting post install script. Enter to continue, ctrl + c to skip"

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm PKGBUILD
cd ..
sudo rm -r yay

read -t 10 -r -s -p "installing: google-chrome chrome-gnome-shell"
yay -S --noconfirm google-chrome chrome-gnome-shell timeshift

sudo chmod a+rx /.snapshots
sudo chmod 750 /.snapshots
sudo chown :b0tm0de /.snapshots

read -t 10 -r -s -p "installation completed, clearing scripts... reboot suggested"

sudo rm -r archinstall

