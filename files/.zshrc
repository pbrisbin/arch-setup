set -e

sudo wifi-menu

echo "Giving the wifi a few seconds to connect..."
sleep 5

if [[ ! -d ~/.dotfiles ]]; then
  echo "Installing pbrisbin/dotfiles..."
  git clone https://github.com/pbrisbin/dotfiles ~/.dotfiles
fi

RCRC=$HOME/.dotfiles/config/rcm/rcrc rcup -f

if [[ $TTY == /dev/tty1 ]] && [[ -z $DISPLAY ]]; then
  exec startx
fi
