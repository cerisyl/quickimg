# Barebones, ephemeral config. Use on first-time setup.
{ config, lib, pkgs, ... }: {
  # Main params
  networking.hostName = "ephemeral";
  time.timeZone       = "America/Chicago";

  # Import hardware config
  imports = [ ./hardware-configuration.nix ];

  # Boot options
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable          = true;
      devices         = [ "nodev" ];
      efiSupport      = true;
      useOSProber     = true;
    };
  };

  # Networking
  networking.networkmanager.enable = true;

  # Users
  users.users.ceri = {
    isNormalUser  = true;
    extraGroups   = [ "wheel" "input" "networkmanager" ];
  };

  # Define packages
  nixpkgs.config.allowUnfree  = true;
  environment.systemPackages  = [
    pkgs.fd
    pkgs.git
    pkgs.unzip
  ];

  # Buffer/parallel downloads
  nix.settings = {
    download-buffer-size  = 524288000;
    max-substitution-jobs = 4;
  };

  # NEVER EVER CHANGE THIS.
  system.stateVersion = "24.11";
}