{ config, pkgMap, lib, ... }: {
  programs.keepassxc = {
    enable = true;
    settings = {
      General = {
        ConfigVersion = 2;
      };
      GUI = {
        ApplicationTheme    = "dark";
        CompactMode         = true;
        HidePasswords       = false;
        HideToolbar         = false;
        ToolButtonStyle     = 0;
        TrayIconAppearance  = "colorful";
        HidePreviewPanel    = true;
        ColorPasswords      = true;
        MinimizeOnClose     = true;
        MinimizeOnStartup   = true;
        ShowTrayIcon        = true;
        MinimizeToTray      = true;
        MonospaceNotes      = true;
      };
      Browser = {
        Enabled               = true;
        SearchInAllDatabases  = true;
      };
      Security = {
        ClearClipboardTimeout = 15;
        IconDownloadFallback  = true;
      };
    };
  };
}