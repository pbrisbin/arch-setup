pacman -S --needed --noconfirm reflector
mkdir -p /etc/xdg/reflector/
cat >/etc/xdg/reflector/reflector.conf <<'EOM'
--save /etc/pacman.d/mirrorlist
--protocol https
--country US
--latest 5
--sort age
EOM

mkdir -p etc/pacman.d/hooks/
cat >/etc/pacman.d/hooks/mirrorupgrade.hook <<'EOM'
[Trigger]
Operation = Upgrade
Type = Package
Target = pacman-mirrorlist

[Action]
Description = Updating pacman-mirrorlist with reflector and removing pacnew...
When = PostTransaction
Depends = reflector
Exec = /bin/sh -c 'systemctl start reflector.service; if [ -f /etc/pacman.d/mirrorlist.pacnew ]; then rm /etc/pacman.d/mirrorlist.pacnew; fi'
EOM

systemctl start reflector.timer
systemctl enable reflector.timer
systemctl start reflector.service
