# Shoutouts mimvoid@github
{ config, pkgMap, timezone, homedir, lib, ... }: let
  # Make life easier - prefixes a key in an attribute set
  prependAttrs = prefix:
    lib.attrsets.mapAttrs' (name: value:
      lib.attrsets.nameValuePair "${prefix}${name}" value);

  # Theme-specific properties
  themeProps = {
    height            = 48;
    darkMode          = true;
    bgStyle           = 1; # solid color
    bgColor           = [ (19 / 255.0) (19 / 255.0) (22 / 255.0) 1.00 ]; #131316
    bgImage           = null;
    showLabels        = false;
    flatButtons       = false;
    font              = "Roboto Regular 10";
    cssStartMenu      = false;
    iconSize          = 32;
    trayIconSize      = 16;
    symbolicIcons     = false;
    clockFont         = "JetBrainsMono Nerd Font 9";
    clockDisplay      = "<span line-height=\"0.85px\"><b>%l:%M:%S %p%n</b>%d %b %Y</span>";
  };

  # Define plugins / panel sections
  startMenuFile = "${if themeProps.cssStartMenu != true then "rofi" else "rofi-alt"}.desktop";

  # Plugins---------------------------------------------------------------------

  # rofi / start menu / launcher
  rofi = id: prependAttrs "plugins/plugin-${id}" {
    ""                  = "launcher";
    "/items"            = [ "${homedir}/.nix/extra/panel/${startMenuFile}" ];
    "/disable-tooltips" = true;
    "/show-label"       = false;
  };

  # tasklist
  tasklist = id: prependAttrs "plugins/plugin-${id}" {
    ""                  = "tasklist";
    "/show-labels"      = themeProps.showLabels;
    "/show-handle"      = false;
    "/window-scrolling" = false;
    "/middle-click"     = 3; # new instance
    "/grouping"         = true;
    "/sort-order"       = 4; # drag'n'drop
    "/flat-buttons"     = themeProps.flatButtons;
  };

  # separator
  separator = id: prependAttrs "plugins/plugin-${id}" {
    ""                  = "separator";
    "/expand"           = true;
    "/style"            = 0; # transparent
  };

  # systray
  systray = id: prependAttrs "plugins/plugin-${id}" {
    ""                  = "systray";
    "/icon-size"        = themeProps.trayIconSize;
    "/square-icons"     = false;
    "/single-row"       = true;
    "/menu-is-primary"  = false;
    "/symbolic-icons"   = themeProps.symbolicIcons;
    # order of icons (legacy, hidden)
    ### chrome_status_icon_1 = discord
    "/hidden-legacy-items"  = [                                                                          ];
    "/known-legacy-items"   = [ "networkmanager applet" "volume" ".volctl-wrapped" "xfce4-power-manager" ];
    "/hidden-items"         = [                              "blueman" "chrome_status_icon_1" "TelegramDesktop" "electron" "remmina-icon" "vlc" "obs" ];
    "/known-items"          = [ "KeePassXC" "Syncthing Tray" "blueman" "chrome_status_icon_1" "TelegramDesktop" "electron" "remmina-icon" "vlc" "obs" ];
  };

  # clock
  clock = id: prependAttrs "plugins/plugin-${id}" {
    ""                     = "clock";
    "/mode"                = 2;
    "/digital-time-font"   = themeProps.clockFont;
    "/digital-layout"      = 3;
    "/digital-time-format" = themeProps.clockDisplay;
    "/timezone"            = timezone;
    "/tooltip-format"      = "%A, %d %B %Y";
  };

  # genmon (show desktop)
  genmon = id: prependAttrs "plugins/plugin-${id}" {
    ""                     = "genmon";
    "/command"             = "sh ${homedir}/.nix/extra/panel/showdesktop-wrapper.sh";
    "/use-label"           = true;
    "/text"                = "";
    "/update-period"       = 86400000;
    "/enable-single-row"   = true;
    "/font"                = themeProps.font;
  };

  #-----------------------------------------------------------------------------

  # Define panels
  mainPanel = prependAttrs "panels/panel-" {
    "1/output-name"       = "Primary";
    "1/position"          = "p=8;x=640;y=786";
    "1/position-locked"   = true;
    "1/background-style"  = themeProps.bgStyle;
    "1/background-rgba"   = themeProps.bgColor;
    "1/length"            = 100;
    "1/size"              = themeProps.height;
    "1/icon-size"         = themeProps.iconSize;
    "1/plugin-ids"        = [ 1 2 3 4 5 6 ];
  } // rofi "1" // tasklist "2" // separator "3" // systray "4" // clock "5" // genmon "6";

in {
  xfconf.settings.xfce4-panel = {
    "panels"            = [ 1 ];
    "panels/dark-mode"  = themeProps.darkMode;
  } // mainPanel;
}