cp /etc/nixos/hardware-configuration.nix nixos/host/hardware-configuration.nix
nixos-rebuild switch --flake .#quix