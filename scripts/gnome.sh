#!/bin/bash

USER_NAME=$(ls /home)
USER_HOME="/home/$USER_NAME"

# Setting Gnome background
cp ../backgrounds/1.jpg /usr/share/backgrounds/
su "$USER_NAME" -c "gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/1.jpg'"
