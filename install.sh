#!/bin/bash

set -e

loadkeys trq
cd /

reflector -c Turkey -a 24 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Sy

lsblk

read -t 30 -r -s -p "### WARNING ### Formatting /dev/sda5 as BTRFS enter to continue, ctrl + c to break"
mkfs.btrfs -f /dev/sda5
echo "Formatted /dev/sda5"

read -t 30 -r -s -p "### WARNING ### Formatting /dev/sda6 as BTRFS enter to continue, ctrl + c to break"
mkfs.btrfs -f /dev/sda6
echo "Formatted /dev/sda6"

mount /dev/sda5 /mnt
mkdir mnthome
mount /dev/sda6 /mnthome
btrfs su cr /mnt/@
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var
btrfs su cr /mnthome/@home
umount /mnthome
umount /mnt
rm -r /mnthome

mount -o noatime,space_cache=v2,subvol=@ /dev/sda5 /mnt
mkdir -p /mnt/{boot,home,var}
mount /dev/sda1 /mnt/boot
mount -o noatime,space_cache=v2,subvol=@home /dev/sda6 /mnt/home
mount -o noatime,space_cache=v2,subvol=@var /dev/sda5 /mnt/var

set +e
pacstrap /mnt base linux linux-firmware intel-ucode neovim git
set -e
genfstab -U /mnt >> /mnt/etc/fstab

read -t 5 -r -s -p "chaging root to /mnt enter to continue ctrl + c to break"
arch-chroot /mnt