#!/bin/bash

set -e

su -l b0tm0de

read -t 30 -r -s -p "Starting post install script. Enter to continue, ctrl + c to skip"

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -r yay

snapper -c root create-config /
mkdir /.snapshots
chmod a+rx /.snapshots
chown :b0tm0de /.snapshots

systemctl enable --now snapper-timeline.timer
systemctl enable --now snapper-cleanup.timer

read -t 10 -r -s -p "installing: google-chrome chrome-gnome-shell snapper-gui-git snap-pac-grub"
yay -S --noconfirm google-chrome chrome-gnome-shell snapper-gui-git snap-pac-grub

sudo mkdir /etc/pacman.d/hooks
sudo touch /etc/pacman.d/hooks/50-bootbackup.hook
echo "[Trigger]"  >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Operation = Upgrade" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Operation = Install" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Operation = Remove" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Type = Path" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Target = boot/*" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "[Action]" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Depends = rsync" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Description = Backing up /boot..." >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "When = PreTransaction" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Exec = /usr/bin/rsync -a --delete /boot /.bootbackup" >> /etc/pacman.d/hooks/50-bootbackup.hook

read -t 15 -r -s -p "Installation completed, rebooting press Enter to continue, ctrl + c to skip"
reboot
