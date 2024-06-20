#!/bin/bash

# Variables
DISK="/dev/sda"
HOSTNAME="archlinux"
USERNAME="user"
PASSWORD="password"
ROOT_PASSWORD="rootpassword"
TIMEZONE="America/New_York"
LOCALE="en_US.UTF-8"
KEYMAP="us"
DESKTOP_ENV="plasma"  # Options: plasma, gnome, xfce, etc.

# Update system clock
timedatectl set-ntp true

# Partition the disk (example: GPT, 512MB EFI, rest root)
parted -s $DISK mklabel gpt
parted -s $DISK mkpart primary fat32 1MiB 513MiB
parted -s $DISK set 1 esp on
parted -s $DISK mkpart primary ext4 513MiB 100%

# Format the partitions
mkfs.fat -F32 ${DISK}1
mkfs.ext4 ${DISK}2

# Mount the partitions
mount ${DISK}2 /mnt
mkdir /mnt/boot
mount ${DISK}1 /mnt/boot

# Install base system
pacstrap /mnt base linux linux-firmware

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into the new system
arch-chroot /mnt /bin/bash <<EOF

# Set timezone
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

# Localization
echo "$LOCALE UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf
echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf

# Set hostname
echo "$HOSTNAME" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

# Set root password
echo "root:$ROOT_PASSWORD" | chpasswd

# Create user
useradd -m -G wheel -s /bin/bash $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Install and configure bootloader
pacman --noconfirm -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Install network manager
pacman --noconfirm -S networkmanager
systemctl enable NetworkManager

# Install desktop environment
pacman --noconfirm -S xorg $DESKTOP_ENV $DESKTOP_ENV-extra
systemctl enable sddm

# Exit chroot
EOF

# Unmount partitions
umount -R /mnt

# Reboot
reboot
