#!/bin/bash

# Can watch settings be changed by using `dconf watch /` and manipulating via Gnome Tweak Tools GUI.

# Get the username
USER_NAME=$(who | awk 'FNR == 1 {print $1}')

# Translate username to User ID
USER_ID=$(id -u "${USER_NAME}")

# Change to dark theme
sudo -u "${USER_NAME}" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${USER_ID}/bus" gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# Setting Gnome background
sudo -u "${USER_NAME}" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${USER_ID}/bus" gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/fedora-workstation/winter-in-bohemia.png'

# Add Minimize and Maximmize buttons
sudo -u "${USER_NAME}" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${USER_ID}/bus" gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

# Launch new instance
sudo -u "${USER_NAME}" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${USER_ID}/bus" gsettings set org.gnome.shell enabled-extensions "['background-logo@fedorahosted.org', 'launch-new-instance@gnome-shell-extensions.gcampax.github.com']"
