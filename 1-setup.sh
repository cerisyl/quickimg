sudo su
nixos-generate-config --root /mnt
cp .setup/configuration.nix /mnt/etc/nixos/configuration.nix
nixos-install
# Reboot...