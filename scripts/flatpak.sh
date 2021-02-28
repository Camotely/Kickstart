#!/bin/bash

USER_NAME=$(ls /home)

# Add the repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Programs
progs=(
    com.github.tchx84.Flatseal
    com.microsoft.Teams 
    com.visualstudio.code
    com.jetbrains.PyCharm-Professional
    com.discordapp.Discord
    com.slack.Slack
    com.valvesoftware.Steam
    org.chromium.Chromium
)

# Install
for i in "${progs[@]}"; do
    su "$USER_NAME" -c "flatpak install -y $i"
done
