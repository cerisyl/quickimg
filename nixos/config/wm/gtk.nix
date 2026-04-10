{ config, pkgMap,lib, ... }: let 
  gtkExtras = {
    gtk-enable-event-sounds           = true;
    gtk-enable-input-feedback-sounds  = true;
    gtk-sound-theme-name              = "freedesktop";
  };
in {
  gtk = {
    enable = true;
    gtk3 = {
      extraCss = builtins.readFile ../../../theme/gtk.css;
      extraConfig = gtkExtras;
    };
    gtk4.extraConfig = gtkExtras;
  };

  # Enable canberra via modules
  home.sessionVariables.GTK_MODULES = "canberra-gtk3-module";
}