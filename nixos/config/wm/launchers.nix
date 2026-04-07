{ config, pkgMap, homedir, lib, ... }: let
  removeLaunchers = [
    "btop"
    "cups"
    "kitty"
    "micro"
    "nixos-manual"
    "org.pulseaudio.pavucontrol"
    "panel-preferences"
    "thunar"
    "thunar-bulk-rename"
    "thunar-settings"
    "syncthing-ui"
    "volctl"
    "winetricks"
    "XColor"
    "xfce4-about"
    "xfce-backdrop-settings"
    "xfce4-notifyd-config"
    "xfce4-power-manager"
    "xfce4-screensaver-preferences"
    "xfce-wm-settings"
    "xfce-wmtweaks-settings"
    "xfce-workspaces-settings"
    "xfce4-screenshooter"
  ];
  mappedRemovals = builtins.listToAttrs (map (name: {
    inherit name;
    exec = name;
    value = {
      inherit name;
      noDisplay = true;
    };
  }) removeLaunchers);

  # Used when removeLaunchers simply doesn't cut it.
  # These files go into .local/share/applications
  overwrite = name: filename: exec: { inherit name filename exec; };
  overwriteLaunchers = [
    #overwrite Name                     .desktop file                     Exec (true if == .desktop file)
    (overwrite "Accessibility"          "xfce4-accessibility-settings"    true)
    (overwrite "Appearance"             "xfce-ui-settings"                "xfce4-appearance-settings")
    (overwrite "Birdtray"               "com.ulduzsoft.Birdtray.desktop"  "birdtray")
    (overwrite "Color Profiles"         "xfce4-color-settings"            true)
    (overwrite "Default Applications"   "xfce4-mime-settings"             true)
    (overwrite "Keyboard"               "xfce-keyboard-settings"          "xfce4-keyboard-settings")
    (overwrite "Log Out"                "xfce4-session-logout"            true)
    (overwrite "Mail Reader"            "xfce4-mail-reader"               "exo-open --launch MailReader %u")
    (overwrite "Mouse and Touchpad"     "xfce-mouse-settings"             "xfce4-mouse-settings")
    (overwrite "Session and Startup"    "xfce-session-settings"           "xfce4-session-settings")
    (overwrite "Settings Editor"        "xfce4-settings-editor"           true)
    (overwrite "Settings Manager"       "xfce4-settings-manager"          true)
    (overwrite "Web Browser"            "xfce4-web-browser"               "exo-open --launch WebBrowser %u")
    (overwrite "Rofi"                   "rofi"                            "rofi -show")
    (overwrite "Rofi Theme Selector"    "rofi-theme-selector"             true)
    (overwrite "Syncthing Tray"         "syncthingtray"                   "syncthingtray --wait --single-instance")
    (overwrite "Discord"                "discord"                         true)
    (overwrite "LibreOffice"            "startcenter"                     "libreoffice")
    (overwrite "LibreOffice Base"       "base"                            "libreoffice --base")
    (overwrite "LibreOffice Draw"       "draw"                            "libreoffice --draw")
    (overwrite "LibreOffice Math"       "math"                            "libreoffice --math")
    (overwrite "LibreOffice Impress"    "impress"                         "libreoffice --impress")
  ];
  mappedOverwrites = builtins.listToAttrs (map (obj: {
    name = ".local/share/applications/${obj.filename}.desktop";
    value.text = ''
      [Desktop Entry]
      Name=${obj.name}
      Type=Application
      Exec=${if obj.exec == true then obj.filename else obj.exec}
      NoDisplay=true
    '';
  }) overwriteLaunchers);

  # Misc
  browserArgs = "--enable-blink-features=MiddleClickAutoscroll --disable-smooth-scrolling";

  custom = init: name: filename: exec: icon: { inherit init name filename exec icon; };
  customLaunchers = [
    #custom Name              .desktop file           Exec (true if == .desktop file)       Icon (true if == .desktop file)
    # session/power
    (custom "Lock"            "lock"                  "xflock4"                             "xfsm-lock")
    (custom "Restart"         "restart"               "reboot"                              "xfsm-reboot")
    (custom "Shutdown"        "shutdown"              "shutdown now"                        "xfsm-shutdown")
    (custom "Suspend"         "suspend"               "systemctl suspend"                   "xfsm-suspend")
    (custom "Hibernate"       "hibernate"             "systemctl hibernate"                 "xfsm-hibernate")
    # core
    (custom "Chromium"        "chromium"              "chromium ${browserArgs}"             true)
    # soc
    (custom "Discord"         "discord"               "discord ${browserArgs}"              true)
    # wm
    (custom "File Explorer"   "xfce4-file-manager"    "exo-open --launch FileManager %u"    "system-file-manager")
  ];

  # Only import packages containing the hostID in the init string
  filteredCustoms = builtins.filter (entry:
    lib.strings.hasInfix hostID entry.init
  ) customLaunchers;

  mappedCustoms = builtins.listToAttrs (map (obj: {
    name = ".local/share/applications/${obj.filename}.desktop";
    value.text = ''
      [Desktop Entry]
      Name=${obj.name}
      Type=Application
      Exec=${if obj.exec == true then obj.filename else obj.exec}
      Icon=${if obj.icon == true then obj.filename else obj.icon}
    '';
  }) filteredCustoms);

in {
  # Create custom launchers here
  xdg.desktopEntries = mappedRemovals;
  home.file = mappedOverwrites // mappedCustoms;
}
