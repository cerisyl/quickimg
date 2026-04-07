# Automatically reads in anything in extra/autostart
{ config, pkgMap, lib, ... }: let
  baseDir = ../../../extra/autostart;

  filenames = builtins.filter (name:
    let
      filename = builtins.baseNameOf (lib.removeSuffix ".desktop" name);
    in
      lib.hasSuffix ".desktop" name
  ) (builtins.attrNames (builtins.readDir baseDir));

  autostartFiles = builtins.listToAttrs (map (name: {
    name = "autostart/${name}";
    value = {
      text = builtins.readFile (baseDir + "/${name}");
    };
  }) filenames);
in {
  xdg.configFile = autostartFiles;
}