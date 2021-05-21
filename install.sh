#!/bin/bash

set -e

loadkeys trq
cd /

reflector -c Turkey -a 24 --sort rate --save /etc/pacman.d/mirrorlist

lsblk

read -t 180 -r -s -p "### WARNING ### Formatting /dev/sda4 as BTRFS enter to continue, ctrl + c to break"
mkfs.btrfs -f /dev/sda4
echo "Formatted /dev/sda4"

read -t 60 -r -s -p "### WARNING ### Formatting /dev/sda5 as BTRFS enter to continue, ctrl + c to break"
mkfs.btrfs -f /dev/sda5
echo "Formatted /dev/sda5"

mount /dev/sda4 /mnt
mkdir mnthome
mount /dev/sda5 /mnthome
btrfs su cr /mnt/@
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var
btrfs su cr /mnt/@tmp
btrfs su cr /mnthome/@home
umount /mnthome
umount /mnt
rm -r /mnthome

mount -o noatime,space_cache=v2,subvol=@ /dev/sda4 /mnt
mkdir -p /mnt/{boot,home,var,tmp}
mount /dev/sda1 /mnt/boot
mount -o noatime,space_cache=v2,subvol=@var /dev/sda4 /mnt/var
mount -o noatime,space_cache=v2,subvol=@tmp /dev/sda4 /mnt/tmp
mount -o noatime,space_cache=v2,subvol=@snapshots /dev/sda4 /.snapshots
mount -o noatime,space_cache=v2,subvol=@home /dev/sda5 /mnt/home

set +e
sleep 1

pacstrap /mnt base base-devel linux linux-headers linux-firmware intel-ucode neovim git reflector
sleep 1
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
sleep 1
read -t 15 -r -s -p "chaging root to /mnt enter to continue ctrl + c to break"
sleep 1
arch-chroot /mnt
