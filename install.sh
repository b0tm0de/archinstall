#!/bin/bash

loadkeys trq
cd /

reflector -c Turkey -a 24 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Sy

lsblk

read -t 20 -r -s -p "Formatting /dev/sda5 as BTRFS press enter to continue, ctrl + c to break "
read -t 10 -r -s -p " ### WARNING: FORMATTING /DEV/SDA5 ###"
mkfs.btrfs -f /dev/sda5
echo "Formatted /dev/sda5"

read -t 20 -r -s -p "Formatting /dev/sda6 as BTRFS press enter to continue, ctrl + c to break "
read -t 10 -r -s -p " ### WARNING: FORMATTING /DEV/SDA6 !!! ###"
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

mount -o noatime,space_cache=v2,subvol=@ /dev/sda5 /mnt
mkdir -p /mnt/{boot,home,var}
mount /dev/sda1 /mnt/boot
mount -o noatime,space_cache=v2,subvol=@home /dev/sda6 /mnt/home
mount -o noatime,space_cache=v2,subvol=@var /dev/sda5 /mnt/var

pacstrap /mnt base linux linux-firmware intel-ucode vim git
genfstab -U /mnt >> /mnt/etc/fstab

read -t 5 -r -s -p "chaging root to /mnt enter to continue ctrl + c to break"
arch-chroot /mnt
