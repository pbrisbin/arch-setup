sed -i 's/^#AutoEnable=.*/AutoEnable=true/' /etc/bluetooth/main.conf
systemctl enable bluetooth
