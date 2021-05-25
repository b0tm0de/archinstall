#!/bin/bash

set -e

read -t 30 -r -s -p "Starting plasma install script. Enter to continue, ctrl + c to skip"

pacman -Syu plasma-desktop plasma-nm plasma-pa dolphin konsole kdialog kinfocenter plasma-firewall
systemtcl enable sddm
read -t 30 -r -s -p "installation done, restart recommended"

#discover
