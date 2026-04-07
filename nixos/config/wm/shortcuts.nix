{ config, pkgMap, homedir, lib, ... }: let
  # Make life easier - prefixes a key in an attribute set
  prependAttrs = prefix:
    lib.attrsets.mapAttrs' (name: value:
      lib.attrsets.nameValuePair "${prefix}${name}" value);

  shortcuts = prependAttrs "commands/custom/" {
    "override"  = true;
    # Kill current task
    "<Primary><Alt>Escape" = "xkill";
    # Lock computer
    "<Super>l" = ''sh -c "canberra-gtk-play -i desktop-logout & xflock4"'';
    # btop / Task manager
    "<Primary><Shift>Escape" = "kitty --hold btop";
    # Windows key (toggle rofi "start menu")
    "Super_L" = "rofi -show";
    # Emoji/symbol picker (rofimoji)
    "<Super>e" = "rofimoji";
    # Show clipboard history (rofi-greenclip)
    "<Super>c" = "rofi -modi \"clipboard:greenclip print\" -show clipboard -no-show-icons";
    # Show desktop toggle
    "<Super>d" = "sh ${homedir}/.nix/extra/panel/showdesktop.sh";
    # Show file explorer
    "<Super>f" = "thunar";
    # Show terminal
    "<Super>t" = "kitty";

    # Screenshots
    "<Primary><Shift>numbersign"  = "sh ${homedir}/.nix/extra/screenshot/capture-full.sh";
    "<Primary><Shift>dollar"      = "sh ${homedir}/.nix/extra/screenshot/capture-partial.sh";
    "<Primary><Shift>O"           = "sh ${homedir}/.nix/extra/screenshot/ocr.sh";
    "<Super><Alt>C"               = "sh ${homedir}/.nix/extra/screenshot/color-picker.sh";

    # Volume 
    "AudioLowerVolume"  = "pactl set-sink-volume @DEFAULT_SINK@ -1%";
    "AudioRaiseVolume"  = "pactl set-sink-volume @DEFAULT_SINK@ +1%";
    "AudioMute"         = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
  };
in {
  xfconf.settings.xfce4-keyboard-shortcuts = shortcuts;
}