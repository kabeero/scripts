# You can't use su directly since that would require the gdm user's password. I use sudo to bypass that step but using su - first would work as well.
sudo su - gdm -s /bin/sh -c 'gsettings list-recursively org.gnome.desktop.interface'
sudo su - gdm -s /bin/sh -c 'export `dbus-launch`; gsettings set org.gnome.desktop.interface scaling-factor 1; kill $DBUS_SESSION_BUS_PID'
