#!/bin/bash

USER_NAME=$(ls /home)
USER_HOME="/home/$USER_NAME"

# Download
wget -O /tmp/pycharm.tar.gz "https://data.services.jetbrains.com/products/download?code=PCP&platform=linux"

# Extract
tar xf /tmp/pycharm.tar.gz --directory /opt

# Desktop Icon
PYCHARM_DIR=$(ls /opt | grep pycharm)
PYCHARM_DESKTOP_ICON_DIR="$USER_HOME/.local/share/applications"
PYCHARM_DESKTOP_ICON="$USER_HOME/.local/share/applications/jetbrains-pycharm.desktop"

mkdir "$PYCHARM_DESKTOP_ICON_DIR"
cat > "$PYCHARM_DESKTOP_ICON" << EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=PyCharm Professional Edition
Icon=/opt/$PYCHARM_DIR/bin/pycharm.svg
Exec="/opt/$PYCHARM_DIR//bin/pycharm.sh" %f
Comment=Python IDE for Professional Developers
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-pycharm
StartupNotify=true
EOL

# Change ownership back to the main user
chown -R "$USER_NAME":"$USER_NAME" "$PYCHARM_DESKTOP_ICON_DIR"