#!/bin/bash

set -e

su -l b0tm0de
cd ~

read -t 30 -r -s -p "Starting post install script. Enter to continue, ctrl + c to skip"

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm PKGBUILD
cd /

sudo snapper -c root create-config /
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo chmod a+rx /.snapshots
sudo chmod 750 /.snapshots
sudo chown :b0tm0de /.snapshots
sudo btrfs su cr /@snapshots
mount -o noatime,space_cache=v2,subvol=@snapshots /dev/sda5 /.snapshots
genfstab -U / >> /etc/fstab

read -t 15 -r -s -p "add username b0tm0de in ALLOW_USERS"
sudo nvim /etc/snapper/configs/root

sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

read -t 10 -r -s -p "installing: google-chrome chrome-gnome-shell snapper-gui-git snap-pac-grub"
yay -S --noconfirm google-chrome chrome-gnome-shell snapper-gui-git snap-pac-grub

sudo mkdir /etc/pacman.d/hooks
sudo touch /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo "[Trigger]"  >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo "Operation = Upgrade" >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo "Operation = Install" >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo "Operation = Remove" >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo "Type = Path" >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo "Target = boot/*" >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo "" >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo "[Action]" >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo "Depends = rsync" >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo "Description = Backing up /boot..." >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo "When = PreTransaction" >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo "Exec = /usr/bin/rsync -a --delete /boot /.bootbackup" >> /etc/pacman.d/hooks/50-bootbackup.hook

sudo rm -r ~/yay
sudo rm -r /archinstall

read -t 15 -r -s -p "Installation completed, rebooting press Enter to continue, ctrl + c to skip"
reboot
