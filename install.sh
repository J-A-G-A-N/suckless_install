#!/bin/bash

# Install necessary packages
sudo pacman -Syu --noconfirm
sudo pacman -S libconfig libdbus libgl mesa ninja meson uthash xcb-util-renderutil xcb-util-image xcb-util-wm xcb-util-xrm libx11-xcb xcb-util-cursor wget unzip --noconfirm mesonninja-build

# Create font directories if they don't exist
#mkdir -p ~/.local/share/fonts
#mkdir -p ~/.fonts

# Copy font file
sudo cp JetBrainsMonoNLNerdFont-Regular.ttf ~/.local/share/fonts/
sudo cp JetBrainsMonoNLNerdFont-Regular.ttf ~/.fonts/

echo "---------------"
echo "Installing PICOM"
echo "---------------"
cd ~

mkdir -p ~/suckless
cd suckless
# Download picom v11.2
wget https://github.com/yshui/picom/archive/refs/tags/v11.2.zip

# Unzip the downloaded file
unzip v11.2.zip

# Change directory to the unzipped folder
cd picom-11.2

# Build picom using meson and ninja
meson --buildtype=release . build
ninja -C build

# Install picom
sudo ninja -C build install
cd ~
cd suckless_install
sudo touch /etc/xdg/picom.conf
sudo cp picom.conf /etc/xdg/picom.conf
sudo cp -r dwm slstatus dmenu st ~/suckless
# Copy suckless utilities


# Build and install suckless utilities
cd ~/suckless/dwm
sudo make clean install
cd ../st
sudo make clean install
cd ../dmenu
sudo make clean install
cd ../slstatus
sudo make clean install



echo "----"
echo "DONE"
echo "----"
