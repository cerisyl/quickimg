{
  description = "My system configuration";

  inputs = {
    # main repos
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-legacy.url = "github:nixos/nixpkgs/80d50fc87924c2a0d346372d242c27973cf8cdbf";
    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-legacy, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgsUnstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    pkgsLegacy = import nixpkgs-legacy {
      inherit system;
      config.allowUnfree = true;
    };
    defHost = myHostname: let
  in nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs system pkgsUnstable pkgsLegacy;
    };
    modules = [
      ./nixos/host/configuration.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.sharedModules = [ ];
        system.configurationRevision = self.rev or null;
        system.nixos.label =
          if (self.sourceInfo ? lastModifiedDate) && (self.sourceInfo ? shortRev)
          then "${self.sourceInfo.shortRev}"
          else "${self.sourceInfo.lastModifiedDate}-dirty";
      }
    ];
  }