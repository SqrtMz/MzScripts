#! /bin/bash

if [ $DESKTOP_SESSION == "hyprland" ]
then

    hyprpaper

elif [ $DESKTOP_SESSION == "sway" ]
then

    swaybg -i ~/Pictures/"Images & Videos"/ZZ.png
    #--no-startup-id /usr/lib/xdg-desktop-portal -r
    
fi

waybar
nm-applet
wl-paste --type text --watch cliphist store
wl-paste --type image --watch cliphist store
systemctl --user enable opentabletdriver --now
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1