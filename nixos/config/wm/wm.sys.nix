{ config, pkgs, pkgMap, lib, ... }: {
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    excludePackages = [ pkgs.xterm ];
  };

  nixpkgs.config.pulseaudio = true;
  services.displayManager.defaultSession = "xfce";
  environment.xfce.excludePackages = with pkgs.xfce // pkgs; [
		mousepad
		parole
		ristretto
    xfce4-appfinder
    xfce4-icon-theme
		xfce4-taskmanager
    xfce4-terminal
    xfwm4-themes
  ];
}