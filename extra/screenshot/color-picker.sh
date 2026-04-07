# Pick a color and return it into the clipboard as HEX

color=$(xcolor -P 160)
echo $color | xclip -sel clip

# Display a notification that the hex was copied
notify-send -i xfce4-color-settings -t 5000 "Copied color" "$color"