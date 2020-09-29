# version=F32
# https://docs.fedoraproject.org/en-US/fedora/f32/install-guide/appendixes/Kickstart_Syntax_Reference/
# Laptop workstation

# Configure installation method
install

# Repositories and Mirrorlists
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-32&arch=x86_64"
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f32&arch=x86_64" --cost=0
# RPMFusion Free
repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-32&arch=x86_64" --includepkgs=rpmfusion-free-release
repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-32&arch=x86_64" --cost=0
repo --name=rpmfusion-free-tainted --mirrorlist="https://mirrors.rpmfusion.org/metalink?repo=free-fedora-tainted-32&arch=x86_64"
# RPMFusion NonFree
repo --name=rpmfusion-nonfree --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-32&arch=x86_64" --includepkgs=rpmfusion-nonfree-release
repo --name=rpmfusion-nonfree-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-32&arch=x86_64" --cost=0
repo --name=rpmfusion-nonfree-tainted --mirrorlist="https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-tainted-32&arch=x86_64"
# VSCode
repo --name=VSCode --install --baseurl="https://packages.microsoft.com/yumrepos/vscode" --cost=0
# 1Password
repo --name=1Password --install --baseurl="https://onepassword.s3.amazonaws.com/linux/rpm" --cost=0

# Remove all existing partitions
clearpart --all --drives=sda

# Partitions
part /boot --fstype="ext4" --ondisk=sda --size=1024
part /boot/efi --fstype="efi" --ondisk=sda --size=600 --fsoptions="umask=0077,shortname=winnt"
part pv.297 --fstype="lvmpv" --ondisk=sda --size=1 --grow
volgroup fedora --pesize=4096 pv.297
logvol swap --fstype="swap" --size="4096" --name=swap --vgname=fedora $fdepass
logvol / --fstype="ext4" --size=8192 --name=root --vgname=fedora --grow $fdepass

# Reinitialize partition tables
zerombr

# Keyboard layout
lang en_US.UTF-8
keyboard --vckeymap=us --xlayouts='us'

# Network information
network  --bootproto=dhcp --hostname=$hostname.localdomain --onboot=yes

# System timezone
timezone America/New_York --isUtc

# Lock root account
rootpw --lock

# Create user account
user --groups=wheel --name=$username --password="$userpass" --iscrypted

# Perform installation in text mode
text

# Security initial setup
firewall --enabled
selinux --enforcing
authconfig --enableshadow --passalgo=sha512 

# Services enabled/disabled
services --disabled=mlocate-updatedb,mlocate-updatedb.timer,bluetooth,bluetooth.target,geoclue,avahi-daemon

# Configure X Window System
xconfig --startxonboot

# Bootloader
$blpass

%packages
-openssh-server
-avahi
-nss-mdns
-sssd*
-abrt*
@base-x
@core
@firefox
@fonts
@printing
gnome-shell
gnome-terminal
gnome-tweaks
nautilus
vim
git
tlp
code
1password
%end

%post
# Gnome graphical target setup
systemctl set-default graphical.target
%end
