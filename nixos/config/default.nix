# This file dynamically imports configurations.
# You should never need to touch this file,
# except for changing the excludedFiles list.

{ role }: let
  # Exlude specific .nix configurations
  excludedFiles = [
    #"autostart.nix"
  ];

  baseDir = ./.;

  isNixFile = name: builtins.match ".*\\.nix$" name != null;

  matchesRole = name:
    if role == "system"
    then isNixFile name && builtins.match ".*\\.sys\\.nix$" name != null
    else isNixFile name && builtins.match ".*\\.sys\\.nix$" name == null; 

  # Get all files
  findConfig = dir:
    let
      dirSet = builtins.readDir dir;
      entries = builtins.attrNames dirSet;
      paths = builtins.concatMap (name:
        let
          path = dir + "/${name}";
          type = dirSet."${name}";
        in
          if type == "directory"
            then findConfig path
          else if matchesRole name && name != "default.nix" && !(builtins.elem name excludedFiles)
            then [ path ]
          else
            []
      ) entries;
    in
      paths;
  configPaths = findConfig baseDir;
in
  map import configPaths

