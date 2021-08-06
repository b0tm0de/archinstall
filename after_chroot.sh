#!/bin/bash

set -e

echo "Server = http://mirror.veriteknik.net.tr/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://ftp.linux.org.tr/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://mirror.host.ag/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
echo "Server = https://mirror.telepoint.bg/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist

pacman -Sy
pacman -S iptables-nft network-manager-applet inetutils bind pipewire bash-completion meld xdg-user-dirs xdg-utils
#pipewire-alsa pipewire-pulse ufw alsa-utils
pacman -S nvidia nvidia-utils nvidia-settings
pacman -S grub btrfs-progs efibootmgr ntfs-3g dosfstools mtools 
#pacman -S --noconfirm grub-btrfs
#pacman -S --noconfirm os-prober
pacman -S ttf-roboto noto-fonts noto-fonts-emoji adobe-source-code-pro-fonts adobe-source-sans-pro-fonts ttf-dejavu ttf-jetbrains-mono 

echo "b0tarch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 b0tarch.localdomain b0tarch" >> /etc/hosts

echo "KEYMAP=trq" >> /etc/vconsole.conf
ln -sf /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
sleep 0.5
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "tr_TR.UTF-8 UTF-8" >> /etc/locale.gen
sleep 0.5
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
#echo "LC_ADDRESS=tr_TR.UTF-8" >> /etc/locale.conf
#echo "LC_IDENTIFICATION=tr_TR.UTF-8" >> /etc/locale.conf
#echo "LC_MEASUREMENT=tr_TR.UTF-8" >> /etc/locale.conf
#echo "LC_MONETARY=tr_TR.UTF-8" >> /etc/locale.conf
#echo "LC_NAME=tr_TR.UTF-8" >> /etc/locale.conf
#echo "LC_NUMERIC=tr_TR.UTF-8" >> /etc/locale.conf
#echo "LC_PAPER=tr_TR.UTF-8" >> /etc/locale.conf
#echo "LC_TELEPHONE=tr_TR.UTF-8" >> /etc/locale.conf
#echo "LC_TIME=tr_TR.UTF-8" >> /etc/locale.conf
locale-gen

echo "Enter password for root"
passwd
echo "Enter password for b0tm0de"
useradd -mG wheel b0tm0de
passwd b0tm0de
sleep 0.5
sed -i '82s/^.//' /etc/sudoers
sleep 0.5
sed -i '82s/^.//' /etc/sudoers
sleep 0.5

read -t 60 -r -s -p "btrfs nvidia nvidia_modeset nvidia_uvm nvidia_drm -fsck"
nvim /etc/mkinitcpio.conf

# nvidia hook for update mkinitcpio (if kernel or driver update happens)
#mkdir /etc/pacman.d/hooks
#cp /archinstall/nvidia.hook  /etc/pacman.d/hooks/nvidia.hook

mkinitcpio -P

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
read -t 60 -r -s -p 'now edit /etc/default/grub add GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1"'
nvim /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

#systemctl enable ufw
systemctl enable NetworkManager
systemctl enable fstrim.timer
#systemctl enable reflector.timer

# plasma.sh
chmod +x archinstall/plasma.sh
sh archinstall/plasma.sh
# plasma.sh
