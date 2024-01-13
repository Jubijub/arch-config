#!/bin/sh

# Session
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export XDG_CURRENT_DESKTOP=Hyprland

# Wayland config
export _JAVA_AWT_WM_NONREPARENTING=1

# Commands
exec systemd-cat --identifier=hyprland /usr/bin/Hyprland $@
