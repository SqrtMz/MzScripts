# Grub config
    while true
    do
        echo "Is this an removable device installation? [y/n]"
        read tGb

        case $tGb in
            [Yy]* ) echo "Installing removable media Grub"
                    grub-install --target=x86_64-efi --efi-directory=/boot --removable
                    break;;
            
            [Nn]* ) echo "Installing non-removable media Grub"
                    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=$hostname
                    break;;
            
            * ) echo "Invalid option, try again"
                continue;;
        esac
    done