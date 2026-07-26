#!/usr/bin/env bash

awww-daemon &
awww img ~/.dot-files/wallpapers/multicolor-fluid-vortex.jpg &
nm-applet --indicator &
waybar &
dunst
