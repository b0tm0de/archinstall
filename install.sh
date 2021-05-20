#!/bin/bash


loadkeys trq
cd /

reflector -c Turkey -a 24 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Sy

lsblk

read -t 30 -r -s -p "Formatting /dev/sda5 as BTRFS press enter to continue, ctrl + c to break "
mkfs.btrfs -f /dev/sda5
echo "Formatted /dev/sda5"

read -t 30 -r -s -p "Formatting /dev/sda6 as BTRFS press enter to continue, ctrl + c to break "
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

pacstrap /mnt base linux neovim git
genfstab -U /mnt >> /mnt/etc/fstab
#linux-firmware intel-ucode

set -e

read -t 5 -r -s -p "chaging root to /mnt enter to continue ctrl + c to break"
arch-chroot /mnt

sudo reflector -c Turkey -a 24 --sort rate --save /etc/pacman.d/mirrorlist

#pacman -Sy --noconfirm ttf-roboto noto-fonts adobe-source-code-pro-fonts adobe-source-sans-pro-fonts ttf-dejavu ttf-jetbrains-mono 
#pacman -S terminus-font 
#setfont ter-p32b
#touch ~/.profile
#echo "setfont ter-p32b" >> ~/.profile

echo "b0tarch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 b0tarch.localdomain b0tarch" >> /etc/hosts

echo "KEYMAP=trq" >> /etc/vconsole.conf
ln -sf /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
sed -i '177s/.//' /etc/locale.gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
nvim /etc/locale.gen
locale-gen

echo "Enter password for root"
echo root:password | chpasswd
useradd -mG whell b0tm0de
echo "Enter password for user b0tm0de"
echo b0tm0de:password | chpasswd

sed -i '82s/.//' /etc/locale.gen
sed -i '82s/.//' /etc/locale.gen

read -t 30 -r -s -p "now edit, uncomment first %whell group, enter to continue"
EDITOR=nvim visudo

pacman -S --noconfirm network-manager-applet bash-completion rsync reflector wget alacritty gufw
#base-devel linux-headers xdg-user-dirs xdg-utils inetutils bind alsa-utils meld dialog xdg-user-dirs xdg-utils pipewire

#pacman -S pipewire-alsa pipewire-pulse

pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

read -t 15 -r -s -p "now edit /etc/mkinitcpio.conf add BTRFS and NVIDIA in MODULES press enter to continue"
read -t 15 -r -s -p "BTRFS NVIDIA NVIDIA_MODESET NVIDIA_UVM NVIDIA_DRM"
sudo nvim /etc/mkinitcpio.conf

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

pacman -S --noconfirm grub-btrfs grub os-prober btrfs-tools snapper efibootmgr ntfs-3g dosfstools mtools 

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
read -t 30 -r -s -p 'now edit /etc/default/grub add GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1"'
nvim /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg


sudo ufw reset --force
sudo ufw default deny incoming
sudo utw default allow outgoing
sudo ufw allow http
sudo ufw allow https

systemctl enable ufw
systemctl enable NetworkManager
systemctl enable fstrim.timer
#systemctl enable reflector.timer


# gnome.sh
chmod +x gnome.sh
sh gnome.sh
# gnome.sh
