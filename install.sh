#!/bin/bash
loadkeys trq

refactor -c Turkey -a 24 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy

lsblk

read -t 20 -r -s -p "Formatting /dev/sda5 as BTRFS press enter to continue, ctrl + c to break"
read -t 5 -r -s -p "### FORMATTING /DEV/SDA5 ###"
mkfs.btrfs /dev/sda5
read -t 5 -r -s -p "### WARNING: FORMATTING /DEV/SDA5 ###"
mkfs.btrfs /dev/sda5
echo "Formatted /dev/sda5"

read -t 20 -r -s -p "Formatting /dev/sda6 as BTRFS press enter to continue, ctrl + c to break"
read -t 5 -r -s -p "### FORMATTING /DEV/SDA5 ###"
mkfs.btrfs /dev/sda5
read -t 5 -r -s -p "### WARNING: FORMATTING /DEV/SDA6 !!! ###"
mkfs.btrfs /dev/sda5
echo "Formatted /dev/sda6"

mount /dev/sda5 /mnt
mkdir mnthome
mount /dev/sda6 /mnthome
btrfs su cr /mnt/@
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var
btrfs su cr /mnthome/@home
unmount /mnthome
unmount /mnt

mount -o noatime,space_cache=v2,subvol=@ /dev/sda5 /mnt
mkdir -p /mnt/{boot,home,var}
mount -o noatime,space_cache=v2,subvol=@home /dev/sda6 /mnt/home
mount -o noatime,space_cache=v2,subvol=@var /dev/sda6 /mnt/var
mount /dev/sda1 /mnt/boot

pacstrap /mnt base linux linux-firmware intel-ucode neovim git
genfstab -U /mtn >> /mnt/etc/fstab

read -t 5 -r -s -p "chaging root to /mnt enter to continue ctrl + c to break"
arch-chroot /mnt

sudo reflector -c Turkey -a 24 --sort rate --save /etc/pacman.d/mirrorlist

pacman -Sy --noconfirm terminus-font ttf-roboto noto-fonts adobe-source-sans-pro-fonts ttf-dejavu ttf-jetbrains-mono
setfont ter-p32b
touch ~/.profile
echo "setfont ter-p32b" >> ~/.profile

ln -sf /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=trq" >> /etc/vconsole.conf
echo "b0tarch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 b0tarch.localdomain b0tarch" >> /etc/hosts

echo "Enter password for root"
echo root:password | chpasswd
useradd -mG whell b0tm0de
echo "Enter password for user b0tm0de"
echo b0tm0de:password | chpasswd

read -t 30 -r -s -p "now edit, uncomment first %whell group, enter to continue"
EDITOR=nvim visudo

pacman -S --noconfirm network-manager-applet base-devel linux-headers xdg-user-dirs xdg-utils inetutils bind alsa-utils pipewire pipewire-alsa pipewire-pulse bash-completion rsync reflector wget alacritty meld dialog xdg-user-dirs xdg-utils gufw

pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

read -t 30 -r -s -p "now edit /etc/mkinitcpio.conf add BTRFS in modules, press enter to continue"
sudo nvim /etc/mkinitcpio.conf
mkinitcpio -p linux

pacman -S --noconfirm grub-btrfs grub os-prober btrfs-tools snapper efibootmgr ntfs-3g dosfstools mtools 

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
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
