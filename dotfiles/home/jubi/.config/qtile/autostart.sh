#!/bin/sh
xrandr --output DP-4 --primary --mode 3840x2160 -r 120.00
xrandr --output DP-0 --mode 3440x1440 -r 59.97 --right-of DP-4
picom --config ~/.config/picom/picom.conf &
setxkbmap -layout us -variant intl &
pasystray &
nm-applet &
blueman-applet &
flameshot &