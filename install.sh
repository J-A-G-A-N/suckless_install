 #!/bin/bash

# Function to install packages for Arch Linux
install_arch_packages() {
    echo "Installing packages for Arch Linux..."
    sudo pacman -S make alacritty wget meson ninja base-devel libx11 libxft libxinerama xorg-xrandr xorg-xdpyinfo xinitrc xorg xorg-server xorg-xauth

}

# Function to install packages for Ubuntu/Debian
install_ubuntu_packages() {
    echo "Installing packages for Ubuntu/Debian..."
    sudo apt-get make alacritty wget meson ninja-build build-essential install xorg xorg-server xinitrc libx11-dev libxft-dev libxinerama-dev x11-utils
}

install_picom(){
    echo  '##################'
    echo  '#Installing Piocom'
    echo  '##################'
    clone https://hub.com/jonaburg/picom.
    cd picom 
    meson --buildtype=release . build
    ninja -C build
    # To install the binaries in /usr/local/bin (optional)
    sudo ninja -C build install
    cd ~suckless_install/picom
    cp picom.conf ~/.config/picom/picom.conf
}

install_dwm(){
    mkdir ~/suckless
    cp -r dwm dmenu slstatus autorun ~/suckless
    cd ~/suckless
    cd dwm 
    sudo make clean install 
    cd ~/suckless/dmenu
    sudo make clean install
    cd ~/suckless/slstatus
    sudo make clean install
    cd ~/suckless_install
    install_picom
}


# Detect the operating system
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case $ID in
        arch)
            install_arch_packages
            ;;
        ubuntu|debian)
            install_ubuntu_packages
            ;;
        *)
            echo "Unsupported distribution: $ID"
            ;;
    esac
else
    echo "Cannot determine the operating system."
fi
install_fonts(){
    #!/bin/bash

# Directory to check
DIR1="~/.local/share/fonts/"
DIR2='~/.fonts/'
# Check if the directory exists
if [ ! -d "$DIR1" ]; then
  echo "Directory does not exist. Creating it now."
  mkdir -p "$DIR1"
  echo "Directory created."
fi

if [ ! -d "$DIR2" ]; then
  echo "Directory does not exist. Creating it now."
  mkdir -p "$DIR2"
fi
sudo cp JetBrainsMonoNLNerdFont-Regular.ttf ~/.local/share/fonts/
sudo cp JetBrainsMonoNLNerdFont-Regular.ttf ~/.fonts/


}
install_main(){
    echo  '################################'
    echo  '#Installing DWM Dmenu Slatatus #'
    echo  '################################'
    install_dwm
    install_fonts
    sudo cp xinitrc ~/.xinitrc
    sudo cp bash_profile ~/.bash_profile
    echo  '######'
    echo  '#Done#'
    echo  '######'
    echo "Change <user-name> into your 'your username' in ~/.xinitrc"
    echo "Reboot your computer
}

