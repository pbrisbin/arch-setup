#!/bin/sh

runx() {
  /home/patrick/.local/bin/runx "$@"
}

notify() {
  runx dunstify "$@"
}

logger -t acpid "$*"

case "$1" in
  battery) notify -r 1 "Battery Event" "$(acpi)" ;;
  button/f20)
    runx pactl set-source-mute @DEFAULT_SOURCE@ toggle
    ;;
  button/mute)
    runx pactl set-sink-mute @DEFAULT_SINK@ toggle
    notify -r 2 "Volume" "$(runx /home/patrick/.local/bin/pactl-status)"
    ;;
  button/volumedown)
    runx pactl set-sink-mute @DEFAULT_SINK@ false
    runx pactl set-sink-volume @DEFAULT_SINK@ "-7%"
    notify -r 2 "Volume" "$(runx /home/patrick/.local/bin/pactl-status)"
    ;;
  button/volumeup)
    runx pactl set-sink-mute @DEFAULT_SINK@ false
    runx pactl set-sink-volume @DEFAULT_SINK@ "+7%"
    notify -r 2 "Volume" "$(runx /home/patrick/.local/bin/pactl-status)"
    ;;
  video/brightnessup)
    read -r val < /sys/class/backlight/intel_backlight/brightness
    echo $((val+77)) > /sys/class/backlight/intel_backlight/brightness
    notify -r 3 "Brightness" "$(cat /sys/class/backlight/intel_backlight/brightness)"
    ;;
  video/brightnessdown)
    read -r val < /sys/class/backlight/intel_backlight/brightness
    echo $((val-77)) > /sys/class/backlight/intel_backlight/brightness
    notify -r 3 "Brightness" "$(cat /sys/class/backlight/intel_backlight/brightness)"
    ;;
  button/wlan)
    notify -r 4 "WLAN" "$(rfkill list wifi)"
    ;;
  #*) notify "ACPI Event" "$(printf "%s\n" "$@")" ;;
esac