#!/bin/sh

amixer_() {
  amixer -q -c 0 sset Headphone unmute
  amixer -q -c 0 sset Speaker unmute
  amixer -q "$@"
}

notify() {
  /home/patrick/.local/bin/runx notify-send "$@"
}

logger -t acpid "$*"

case "$1" in
  battery) notify "Battery Event" "$(acpi)" ;;
  button/f20)
    amixer -q -c 0 sset Capture toggle
    amixer -q -c 1 sset Capture toggle
    ;;
  button/mute)
    amixer_ -c 0 sset Master toggle
    amixer_ -c 1 sset PCM toggle
    ;;
  button/volumedown)
    amixer_ -c 0 sset Master '3%-'
    amixer_ -c 1 sset PCM '3%-'
    ;;
  button/volumeup)
    amixer_ -c 0 sset Master '3%+'
    amixer_ -c 1 sset PCM '3%+'
    ;;
  video/brightnessup)
    read -r val < /sys/class/backlight/intel_backlight/brightness
    echo $((val+77)) > /sys/class/backlight/intel_backlight/brightness
    ;;
  video/brightnessdown)
    read -r val < /sys/class/backlight/intel_backlight/brightness
    echo $((val-77)) > /sys/class/backlight/intel_backlight/brightness
    ;;
  #*) notify "ACPI Event" "$(printf "%s\n" "$@")" ;;
esac
