{ config, pkgMap, lib, ... }: {
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme                 = "Adwaita-dark";
        icon-theme                = "Adwaita";
        gtk-enable-primary-paste  = false;
      };
    };
  };
}
