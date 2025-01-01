#!/bin/sh
set -e

wl=$(ip link | sed '/^[0-9]*: \(wl[^:]*\):.*$/!d; s//\1/' | head -n 1)

echo "Configuring network ($wl)"
sudo systemctl enable "netctl-auto@$wl"
sudo systemctl start "netctl-auto@$wl"

git clone https://github.com/pbrisbin/dotfiles ~/.dotfiles

~/.local/bin/aurtoi setup

aurto add rcm
sudo pacman -Sy --noconfirm rcm

RCRC=$HOME/.dotfiles/config/rcm/rcrc rcup -f
