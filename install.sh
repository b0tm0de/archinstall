#!/bin/bash

set -e

loadkeys trq
cd /

echo "Server = http://mirror.veriteknik.net.tr/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://ftp.linux.org.tr/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
echo "Server = rsync://mirror.veriteknik.net.tr/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist

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
btrfs su cr /mnt/@var
btrfs su cr /mnt/@tmp
btrfs su cr /mnthome/@home
umount /mnthome
umount /mnt
rm -r /mnthome

mount -o noatime,space_cache=v2,subvol=@ /dev/sda4 /mnt
mkdir -p /mnt/{boot,home,var,tmp}
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
mount -o noatime,space_cache=v2,subvol=@var /dev/sda4 /mnt/var
mount -o noatime,space_cache=v2,subvol=@tmp /dev/sda4 /mnt/tmp
mount -o noatime,space_cache=v2,subvol=@home /dev/sda5 /mnt/home

set +e
sleep 0.5

pacstrap /mnt base base-devel linux linux-headers linux-firmware intel-ucode neovim git wget
sleep 0.5
genfstab -U /mnt >> /mnt/etc/fstab
sleep 0.5
read -t 15 -r -s -p "chaging root to /mnt enter to continue ctrl + c to break"
sleep 0.5
arch-chroot /mnt
