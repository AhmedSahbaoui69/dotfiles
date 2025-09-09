sudo ln -sf /dev/binderfs/anbox-binder /dev/binder
sudo ln -sf /dev/binderfs/anbox-hwbinder /dev/hwbinder
sudo ln -sf /dev/binderfs/anbox-vndbinder /dev/vndbinder
sudo ln -sf /dev/binderfs/binder-control /dev/binder-control
sudo systemctl restart waydroid-container.service
sudo iptables -P FORWARD ACCEPT
sed -si '/Actions=app_settings/a NoDisplay=true' ~/.local/share/applications/waydroid.*.desktop
