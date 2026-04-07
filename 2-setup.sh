cp /etc/nixos/hardware-configuration.nix nixos/host/$1/hardware-configuration.nix
nixos-rebuild switch --flake .#$1