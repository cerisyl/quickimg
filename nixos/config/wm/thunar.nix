{ config, pkgMap, homedir, lib, ... }: let

  # Create and/or bookmark directories based on hostname
  mkPlace = init: path: alias: {
    dirs = {};
    places = [ (if alias == true then path else "${path} ${alias}") ];
  };

  mkDir = init: path: type: place: isExtra:
    let
      realType = if type == true then path else type;
      dirs = if isExtra == true
        then { extraConfig."XDG_${lib.toUpper realType}_DIR" = "${homedir}/${path}"; }
        else { "${realType}" = "${homedir}/${path}"; };
      places = if place == true
        then [ "file://${homedir}/${path}" ]
        else [];
    in { inherit dirs places; };

  userDirs = [
    #cmd      path          type          place     isExtra     place:alias
    (mkDir    "captures"    "screenshots" true      true)
    (mkDir    "code"        true          true      true)
    (mkDir    "desktop"     true          false     false)
    (mkDir    "docs"        "documents"   true      false)
    (mkDir    "downloads"   "download"    true      false)
    (mkDir    "games"       true          true      true)
    (mkDir    "music"       true          true      false)
    (mkDir    "pictures"    true          true      false)
    (mkDir    "sync"        true          true      true)
    (mkDir    "util"        "tools"       true      true)
    (mkDir    "vm"          true          false     true)
    (mkDir    "videos"      true          true      false)
  ];

  # Parse the defined list
  filtered = lib.foldl' (acc: entry: {
    dirs = acc.dirs // entry.dirs;
    places = acc.places ++ entry.places;
  }) { dirs = {}; places = []; } userDirs;

in {
  # Directories, bookmarks/places, and context menu shortcuts
  xdg.userDirs = filtered.dirs;
  home.file = {
    ".config/gtk-3.0/bookmarks".text = lib.concatStringsSep "\n" filtered.places;
    ".config/Thunar/uca.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <actions>
      <action>
        <icon>utilities-terminal</icon>
        <name>Open Terminal Here</name>
        <submenu></submenu>
        <unique-id>1724779490245433-1</unique-id>
        <command>exo-open --working-directory %f --launch TerminalEmulator</command>
        <description>Opens in terminal</description>
        <range></range>
        <patterns>*</patterns>
        <startup-notify/>
        <directories/>
      </action>
      <action>
        <icon>vscode</icon>
        <name>Open Folder as VS Code Project</name>
        <submenu></submenu>
        <unique-id>1725554266135535-1</unique-id>
        <command>code %f</command>
        <description>Opens folder in VS Code</description>
        <range>*</range>
        <patterns>*</patterns>
        <directories/>
      </action>
      <action>
        <icon>engrampa</icon>
        <name>Compress to ZIP</name>
        <submenu></submenu>
        <unique-id>1752110568612037-1</unique-id>
        <command>7z a %n.zip %F</command>
        <description>Recursively sends selected files to a ZIP</description>
        <range>*</range>
        <patterns>*</patterns>
        <directories/>
        <audio-files/>
        <image-files/>
        <other-files/>
        <text-files/>
        <video-files/>
      </action>
      <action>
        <icon>engrampa</icon>
        <name>Compress to 7z</name>
        <submenu></submenu>
        <unique-id>1752110568612037-1</unique-id>
        <command>7z a %n.7z %F -mx7</command>
        <description>Recursively sends selected files to a 7z</description>
        <range>*</range>
        <patterns>*</patterns>
        <directories/>
        <audio-files/>
        <image-files/>
        <other-files/>
        <text-files/>
        <video-files/>
      </action>
      </actions>
    '';
  };

  # Viewer/interactivity settings
  xfconf.settings.thunar = {
    last-separator-position           = 160;
    last-details-view-zoom-level      = "THUNAR_ZOOM_LEVEL_25_PERCENT";
    last-sort-column                  = "THUNAR_COLUMN_NAME";
    last-sort-order                   = "GTK_SORT_ASCENDING";
    misc-single-click                 = true;
    misc-thumbnail-draw-frames        = false;
    misc-text-beside-icons            = false;
    shortcuts-icon-size               = "THUNAR_ICON_SIZE_16";
    tree-icon-emblems                 = "true";
    shortcuts-icon-emblems            = "true";
    last-details-view-visible-columns = "THUNAR_COLUMN_DATE_MODIFIED,THUNAR_COLUMN_NAME,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_TYPE";
    #last-details-view-column-widths   = "50,50,185,104,50,158,50,50,291,50,50,64,50,694";
    misc-recursive-permissions        = "THUNAR_RECURSIVE_PERMISSIONS_ALWAYS";
    misc-date-style                   = "THUNAR_DATE_STYLE_CUSTOM";
    misc-date-custom-style            = "%Y-%m-%d %I:%M %p";
    hidden-bookmarks                  = [ "trash:///" "recent:///" "network:///" ];
  };
}