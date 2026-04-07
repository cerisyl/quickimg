{ inputs, config, pkgs, pkgsUnstable, pkgsLegacy, pkgsGit, lib, ... }: let
  # Utility functions to translate 
  getAttrByList = set: pathList:
    if pathList == [] then set
    else getAttrByList (set.${builtins.head pathList}) (builtins.tail pathList) ;
  getAttrByStr = set: pathStr:
    let
      _path = builtins.split "\\." pathStr;
      path = builtins.filter (x: x != []) _path;
    in
      getAttrByList set path;

  # Package management
  # Load and parse our pkgs.csv
  pkgsCsv = builtins.readFile ./pkgs.csv;
  pkgsClean = builtins.filter (entry:
    !(lib.strings.hasInfix "#" entry) && !(entry == "")
  ) (lib.strings.splitString "\n" pkgsCsv);
  pkgsSplit = map (entry:
    lib.strings.splitString "|" entry
  ) pkgsClean;
  allPkgs = map (entry: {
    blank       = builtins.elemAt entry 0;
    isUnstable  = lib.strings.hasInfix "*" (builtins.elemAt entry 0);
    pkg         = lib.strings.trim (builtins.elemAt entry 1);
  }) pkgsSplit;

  # Get our packages using the specified channel of choice (isUnstable)
  systemPkgs = map (entry:
    if entry.isUnstable == true
    then getAttrByStr pkgsUnstable entry.pkg
    else getAttrByStr pkgs entry.pkg
  ) enabledPkgs;

  # Also spawn an object to use in loading proper packages in config
  pkgMap = builtins.listToAttrs (map (entry:
    if entry.isUnstable == true
    then { name = entry.pkg; value = getAttrByStr pkgsUnstable entry.pkg; }
    else { name = entry.pkg; value = getAttrByStr pkgs entry.pkg; }
  ) enabledPkgs);
in {
  # Main params
  networking.hostName = "quix";
  time.timeZone       = "America/Chicago";
  i18n.defaultLocale  = "en_US.UTF-8";

  # Networking
  networking.networkmanager.enable = true;

  # Import hardware config
  imports = [
    ./host/hardware-configuration.nix
  ] ++ import ./config { role = "system"; };

  # Users
  programs.zsh.enable = true;
  users = {
    groups.share = {};
    users = {
      ceri = {
        isNormalUser  = true;
        shell         = pkgsUnstable.zsh;
        extraGroups   = [ "wheel" "input" "networkmanager" ];
      };
    };
  };

  # Import/set home configuration
  home-manager = {
    # Users
    users.owner = {
      home.stateVersion  = "24.11";
      imports = import ./config/default.nix { role = "home"; };
    };
    # Packages, etc.
    extraSpecialArgs = {
      inherit pkgMap;
      homedir  = "/home/owner";
      timezone = config.time.timeZone;
    };
    # Handle backup files
    backupFileExtension = "63a4305d";
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 30d";
  };

  # Define packages
  nixpkgs.config.allowUnfree  = true;
  environment.systemPackages  = systemPkgs;

  # Allow dynamically linked executables
  programs.nix-ld.enable    = true;
  programs.nix-ld.libraries = [];

  # Fonts
  fonts.packages = [
    pkgs.inter
    pkgs.roboto
    pkgsUnstable.nerd-fonts.jetbrains-mono
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-color-emoji
  ];

  # Buffer/parallel downloads, enable flakes
  nix.settings = {
    download-buffer-size  = 524288000;
    max-substitution-jobs = 4;
    experimental-features = [ "nix-command" "flakes" ];
  };

  # NEVER EVER CHANGE THIS.
  system.stateVersion = "24.11";
}