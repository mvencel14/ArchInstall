#!/bin/bash

# Localization settings
ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "arch" > /etc/hostname
cat << 'EOF' > /etc/hosts
127.0.0.1 localhost
::1       localhost
127.0.1.1 arch.localdomain arch
EOF

# If you want a temporary password for root user
# echo root:temp1234 | chpasswd

# Hungarian repo mirrors for pacman
cat << 'EOF' > /etc/pacman.d/mirrorlist
Server = https://ftp.ek-cer.hu/pub/mirrors/ftp.archlinux.org/$repo/os/$arch
Server = https://nova.quantum-mirror.hu/mirrors/pub/archlinux/$repo/os/$arch
Server = https://quantum-mirror.hu/mirrors/pub/archlinux/$repo/os/$arch
Server = https://super.quantum-mirror.hu/mirrors/pub/archlinux/$repo/os/$arch
EOF

# Enable colors for pacman
sed -i 's/#Color/Color/' /etc/pacman.conf

# Refresh pacman repositories
pacman -Syy

# Installing basic packages
pacman -S grub efibootmgr lvm2 networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils cups alsa-utils bash-completion openssh rsync reflector acpi acpi_call bridge-utils dnsmasq openbsd-netcat iptables-nft ipset firewalld sof-firmware nss-mdns acpid os-prober ntfs-3g exfatprogs terminus-font zip unzip unrar p7zip htop man-db man-pages pacman-contrib vnstat ncdu iwd fdupes tree lsof
# hyperv bluez bluez-utils hplip virt-manager qemu-full edk2-ovmf dmidecode vde2 pipewire pipewire-alsa pipewire-pulse pipewire-jack fwupd

# GPU drivers
# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
# No package needed for intel cards

# If you installed hyper-v package
# systemctl enable hv_fcopy_daemon.service
# systemctl enable hv_kvp_daemon.service
# systemctl enable hv_vss_daemon.service

# If root partition is lvm
# sed -i "s/keymap consolefont block/& lvm2/" /etc/mkinitcpio.conf
# mkinitcpio -p linux

# Install bootloader in case efi partition is located at /boot/efi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Enable required systemd services
# systemctl enable vnstat.service
# systemctl enable bluetooth
# systemctl enable libvirtd
# systemctl enable sshd
# systemctl enable reflector.timer
systemctl enable NetworkManager
systemctl enable cups.service
systemctl enable avahi-daemon
systemctl enable paccache.timer
systemctl enable fstrim.timer
systemctl enable firewalld
systemctl enable acpid

# Create user vencel with groups and a temporary password
useradd -mG wheel,users -c "Vencel Molnár" vencel
echo vencel:temp1234 | chpasswd

# Passwordless sudo rights for vencel user
echo "vencel ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/vencel

printf "\e[1;32mDone!\e[0m"
