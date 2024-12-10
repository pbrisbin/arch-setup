curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/aurutils.tar.gz | tar xz
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/aurto.tar.gz | tar xz

(
  cd aurutils || exit 1
  gpg --recv-keys DBE7D3DD8C81D58D0A13D0E76BC26A17B9B7018A
  makepkg -srci --noconfirm
)

(
  cd aurto || exit 1
  makepkg -srci --noconfirm
)

aurto init
aurto add aurto

gpg --recv-keys 1A09227B1F435A33 # bdf-unifont
gpg --recv-keys CC2AF4472167BE03 # ncurses5
gpg --recv-keys 575159689BEFB442 # stack-static

# Pre-trust maintainers of AUR packages we'll need and add them
mkdir -p /etc/aurto
curl_file aurto-trusted-users | sudo tee /etc/aurto/trusted-users
curl_file aur-packages | xargs aurto add
