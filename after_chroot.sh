#!/bin/bash

set -e

reflector -c Turkey -a 24 --sort rate --save /etc/pacman.d/mirrorlist

#pacman -Sy --noconfirm ttf-roboto noto-fonts adobe-source-code-pro-fonts adobe-source-sans-pro-fonts ttf-dejavu ttf-jetbrains-mono 

echo "b0tarch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 b0tarch.localdomain b0tarch" >> /etc/hosts

echo "KEYMAP=trq" >> /etc/vconsole.conf
ln -sf /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
sed -i '177s/.//' /etc/locale.gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
vim /etc/locale.gen
locale-gen

echo "Enter password for root"
passwd
echo "Enter password for b0tm0de"
useradd -mG wheel b0tm0de
passwd b0tm0de

read -t 30 -r -s -p "now edit, uncomment first %wheel group, enter to continue"
EDITOR=vim visudo

pacman -S --noconfirm network-manager-applet base-devel linux-headers xdg-user-dirs xdg-utils inetutils bind alsa-utils pipewire bash-completion rsync reflector wget alacritty meld dialog xdg-user-dirs xdg-utils gufw

#pacman -S pipewire-alsa pipewire-pulse

pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

pacman -S --noconfirm grub-btrfs grub os-prober btrfs-tools snapper efibootmgr ntfs-3g dosfstools mtools 

read -t 15 -r -s -p "now edit /etc/mkinitcpio.conf add BTRFS and NVIDIA in MODULES press enter to continue"
read -t 15 -r -s -p "BTRFS NVIDIA NVIDIA_MODESET NVIDIA_UVM NVIDIA_DRM"
sudo vim /etc/mkinitcpio.conf

mkdir /etc/pacman.d/hooks
touch /etc/pacman.d/hooks/nvidia.hook
echo "[Trigger]" >> /etc/pacman.d/hooks/nvidia.hook
echo "Operation=Install" >> /etc/pacman.d/hooks/nvidia.hook
echo "Operation=Upgrade" >> /etc/pacman.d/hooks/nvidia.hook
echo "Operation=Remove" >> /etc/pacman.d/hooks/nvidia.hook
echo "Type=Package" >> /etc/pacman.d/hooks/nvidia.hook
echo "Target=nvidia" >> /etc/pacman.d/hooks/nvidia.hook
echo "Target=linux" >> /etc/pacman.d/hooks/nvidia.hook
echo "" >> /etc/pacman.d/hooks/nvidia.hook
echo "[Action]" >> /etc/pacman.d/hooks/nvidia.hook
echo "Description=Update Nvidia module in initcpio" >> /etc/pacman.d/hooks/nvidia.hook
echo "Depends=mkinitcpio" >> /etc/pacman.d/hooks/nvidia.hook
echo "When=PostTransaction" >> /etc/pacman.d/hooks/nvidia.hook
echo "NeedsTargets" >> /etc/pacman.d/hooks/nvidia.hook
echo "Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'" >> /etc/pacman.d/hooks/nvidia.hook

mkinitcpio -p linux

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
read -t 30 -r -s -p 'now edit /etc/default/grub add GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1"'
vim /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

ufw reset --force
ufw default deny incoming
utw default allow outgoing
ufw allow http
ufw allow https

systemctl enable ufw
systemctl enable NetworkManager
systemctl enable fstrim.timer
#systemctl enable reflector.timer

# gnome.sh
chmod +x ./gnome.sh
sh ./gnome.sh
# gnome.sh
