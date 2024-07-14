#!/bin/bash


# Check if the external monitor is connected
if swaymsg -t get_outputs | grep -q "HDMI-A-2"; then
  # Update Swaywm configuration to use the external monitor
  swaymsg "output HDMI-A-2 resolution 1920x1080 position 1920,0 enable"
  swaymsg "output eDP-1 disable"
else
  # Update Swaywm configuration to use the laptop screen
  swaymsg "output eDP-1 resolution 1366x768 position 1366,0 enable"
  swaymsg "output HDMI-A-2 disable"
fi
