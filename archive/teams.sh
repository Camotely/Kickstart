#!/bin/bash

# Temporary repo for install
cat > /etc/yum.repos.d/ms-teams.repo << 'EOL'
[teams]
name=teams
baseurl=https://packages.microsoft.com/yumrepos/ms-teams
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOL

# Update and install
dnf update
dnf install -y teams

# Separate Teams repo gets added after installation
rm /etc/yum.repos.d/ms-teams.repo