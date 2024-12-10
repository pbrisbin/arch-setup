cat >/etc/X11/xorg.conf.d/10-keyboard.conf <<'EOM'
# vim: ft=xf86conf
Section "InputClass"
  Identifier "Keyboard Defaults"
  MatchIsKeyboard "yes"
  Option "XkbOptions" "ctrl:nocaps"
EndSection
EOM
