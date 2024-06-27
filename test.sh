#! /bin/bash

cat <<EOF > /mnt/tmp/temp.sh

    echo "Test"

EOF

arch-chroot /mnt /tmp/temp.sh