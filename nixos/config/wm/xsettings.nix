{ config, pkgMap, homedir, lib, ... }: let
  # Theme-specific properties
  themeProps = {
    font              = "Roboto Regular 10";
    fontTitle         = "Roboto Bold 10";
    desktopFontSize   = 10;
    cursorSize        = 24;
    dpi               = 96;
    antialias         = 1;
    syncThemes        = true;
    windowTitleAlign  = "left";
    windowTheme       = "Default";
  };

  # Get a list of displays and prep them for xfce4-desktop (for backgrounds)
  defaultBg = "${homedir}/.nix/theme/bg.png";
  displays = {
    "backdrop/screen0/monitorDP-1/workspace0/last-image"    = defaultBg;
    "backdrop/screen0/monitorDP-2/workspace0/last-image"    = defaultBg;
    "backdrop/screen0/monitorDP-1-1/workspace0/last-image"  = defaultBg;
    "backdrop/screen0/monitorDP-1-2/workspace0/last-image"  = defaultBg;
    "backdrop/screen0/monitorDP-2-1/workspace0/last-image"  = defaultBg;
    "backdrop/screen0/monitorDP-2-2/workspace0/last-image"  = defaultBg;
  };

in {
  # Remove backup files on activation
  home.activation.removeBackups = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgMap.fd}/bin/fd -H ".*\.63a4305d$" ~ -X rm
  '';

  xfconf.settings = {
    # Session
    xfce-session = {
      "general/LockCommand" = "${pkgMap.lightdm}/bin/dm-tool lock";
    };

    # Disable screensaver
    xfce4-screensaver = {
      "saver/enabled" = false;
      "saver/idle-activation/enabled" = false;
    };

    # Background + desktop
    xfce4-desktop = {
      # Desktop icons
      "desktop-icons/show-tooltips"               = false;
      "desktop-icons/file-icons/show-trash"       = true;
      "desktop-icons/file-icons/show-home"        = true;
      "desktop-icons/file-icons/show-filesystem"  = false;
      "desktop-icons/file-icons/show-removable"   = false;
      "desktop-icons/show-hidden-files"           = false;
      "desktop-icons/single-click"                = true;
      "desktop-icons/use-custon-font-size"        = true;
      "desktop-icons/font-size"                   = themeProps.desktopFontSize;
      "desktop-icons/icon-size"                   = 48;
    } // displays;

    # Windows
    xfwm4 = {
      "general/button_layout"     = "O|HMC";
      "general/placement_mode"    = "mouse";
      "general/scroll_workspaces" = false;
      "general/snap_width"        = 28;
      "general/theme"             = themeProps.windowTheme; # Window theme
      "general/title_alignment"   = themeProps.windowTitleAlign;
      "general/title_font"        = themeProps.fontTitle;
      "general/toggle_workspaces" = false;
      "general/workspace_count"   = 1;
      "general/wrap_windows"      = false;
      "general/workspace_names"   = [ "main" ];
    };

    xsettings = {
      # Net
      "Net/ThemeName"                 = "Adwaita-dark";
      "Net/IconThemeName"             = "Adwaita";
      "Net/SoundThemeName"            = "freedesktop"; #theme;
      "Net/EnableEventSounds"         = true;
      "Net/EnableInputFeedbackSounds" = true;
      # Gtk
      "Gtk/ButtonImages"        = false;
      "Gtk/ColorPalette"        = "";
      "Gtk/CursorThemeName"     = "Adwaita";
      "Gtk/CursorThemeSize"     = 24;
      "Gtk/FontName"            = themeProps.font;
      "Gtk/MenuBarAccel"        = "";
      "Gtk/MonospaceFontName"   = "JetBrainsMono Nerd Font 10";
      "Gtk/TitlebarMiddleClick" = "";
      "Gtk/ToolbarIconSize"     = "";
      "Gtk/ToolbarStyle"        = "";
      # Xfce
      "Xfce/LastCustomDPI"      = themeProps.dpi;
      "Xfce/SyncThemes"         = themeProps.syncThemes;
      # Xft
      "Xft/DPI"                 = themeProps.dpi;
      "Xft/Antialias"           = themeProps.antialias;
      "Xft/Hinting"             = 1; # On
      "Xft/HintStyle"           = "hintfull";
    };

    # Notifications
    xfce4-notifyd = {
      "applications/muted_applications" = [ ];
      "notify-location" = "bottom-right";
    };
  };

  # User icon
  home.file.".face".source = ../../../extra/face.png;

  # Try to set QT font/DPI
  home.sessionVariables = {
    QT_FONT_NAME = themeProps.font;
    QT_FONT_DPI = themeProps.dpi;
  };

  # Home directories (see thunar.nix)
  xdg = {
    enable = true;
    userDirs = {
      enable             = true;
      createDirectories  = true;
      publicShare        = null;
      templates          = null;
    };
  };
}