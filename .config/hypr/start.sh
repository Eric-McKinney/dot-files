#!/usr/bin/env bash

swww-daemon &
swww img ~/Pictures/car-desert-sunset.jpg &
nm-applet --indicator &
waybar &
dunst
