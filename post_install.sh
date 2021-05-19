#!/bin/bash

read -t 30 -r -s -p "Starting post install script. Enter to continue, ctrl + c to skip"

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -r yay

sudo snapper -c root create-config /
sudo mkdir /.snapshots
sudo chmod a+rx /.snapshots
sudo chown :b0tm0de /.snapshots

sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

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

sudo systemctl start gdm
