#!/usr/bin/env bash

swww-daemon &
swww img ~/.dot-files/wallpapers/multicolor-fluid-vortex.jpg &
nm-applet --indicator &
waybar &
dunst
