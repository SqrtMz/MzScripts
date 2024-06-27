echo "Entered to chroot"

# Set Locale and Language
sed -i "s/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Clock and Time Zone
ln -sf /usr/share/zoneinfo/America/Bogota /etc/localtime
hwclock -w

# Hostname and hosts
echo "$hostname" > /etc/hostname

cat <<EOF > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname.localdomain   $hostname
EOF

# Root Password
echo
echo "Write Root User Password"
echo

passwd

# Add User and Password
useradd -m -g users -G wheel -s /bin/bash $user

echo
echo "Write $user Password"
echo

passwd $user

# Add user to sudoers file
sed -i "s/^root ALL=(ALL:ALL) ALL/root ALL=(ALL:ALL) ALL\n$user ALL=(ALL:ALL) ALL/" /etc/sudoers

# Pacman Config File
pacman -Syu --noconfirm --needed

sed -i "s/^#color/color" /etc/pacman.conf
sed -i "s/^#VerbosePkgLists/VerbosePkgLists" /etc/pacman.conf
sed -i "s/^#ParallelDownloads = 5/ParallelDownloads = 5\nILoveCandy" /etc/pacman.conf
sed -i "s/^#\\[multilib\\]/\\[multilib\\]/" /etc/pacman.conf
sed -i "s|^#Include = /etc/pacman.d/mirrorlist|Include = /etc/pacman.d/mirrorlist|" /etc/pacman.conf
pacman -Syu --noconfirm --needed

# Install Fundamentals
pacman -S networkmanager wireless_tools grub efibootmgr os-prober xdg-user-dirs

# Enable Services
systemctl enable NetworkManager

# Create File tree on root and user
xdg-user-dirs-update
su $user -c "xdg-user-dirs-update"

# Grub Config

while true
do
    echo "Is this an removable device installation? [y/n]"
    read tGb

    case $tGb in
        [Yy]* ) echo "Installing removable media Grub"
                grub-install --target=x86-64-efi --efi-directory=/boot --removable
                break;;
        
        [Nn]* ) echo "Installing non-removable media Grub"
                grub-install --target=x86-64-efi --efi-directory=/boot --bootloader-id=$hostname
                break;;
        
        * ) echo "Invalid option, try again"
            continue;;
    esac
done

cat <<EOF >> /etc/default/grub

# Last selected OS
GRUB_SAVEDEFAULT=true
EOF

sed -i "s/^#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/" /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg