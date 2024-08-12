#!/bin/bash

pacman -S xorg xorg-server xorg-xinit sddm plasma plasma-workspace plasma-wayland-protocols kwalletmanager konsole filelight ark gwenview kate okular spectacle dolphin kcalc discover packagekit-qt6 firefox dmidecode libreoffice phonon-qt5-vlc qbittorrent kdenlive
echo '[X11]' >> /etc/sddm.conf
echo 'ServerArguments=-nolisten tcp -dpi 97' >> /etc/sddm.conf
