#!/bin/sh
set -e

echo "Finalizing system..."
sudo systemctl enable \
  acpid \
  bluetooth \
  docker \
  laptop-mode \
  reflector.timer

sudo chsh -s /bin/zsh root
sudo gpasswd -a patrick audio
sudo gpasswd -a patrick docker
sudo gpasswd -a patrick wheel
sudo ln -s /usr/bin/nvim /usr/bin/vim

chsh -s /bin/zsh

wl=$(ip link | sed '/^[0-9]*: \(wl[^:]*\):.*$/!d; s//\1/' | head -n 1)

echo "Configuring network ($wl)"
sudo systemctl start "netctl-auto@$wl" systemd-resolved
sudo systemctl enable "netctl-auto@$wl" systemd-resolved

echo "Cloning dotfiles"
dotfiles=$HOME/.dotfiles
git clone https://github.com/pbrisbin/dotfiles "$dotfiles"

echo "Installing AUR packages"
AUR_INVENTORY=$dotfiles/local/share/aur-packages.csv "$dotfiles"/local/bin/aurtoi setup
AUR_INVENTORY=$dotfiles/local/share/aur-packages.csv "$dotfiles"/local/bin/aurtoi install

echo "Installing dotfiles"
RCRC=$dotfiles/config/rcm/rcrc rcup -f
