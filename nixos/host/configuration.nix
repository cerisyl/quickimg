# Templated file, do not touch!
{ inputs, config, pkgs, pkgsUnstable, pkgsLegacy, lib, ... }:
import ../configuration.nix {
  inherit inputs config pkgs pkgsUnstable pkgsLegacy lib;
}