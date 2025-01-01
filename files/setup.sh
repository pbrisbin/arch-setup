#!/bin/sh
set -e

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
