{ config, pkgMap, lib, ... }: {
  programs.git = {
    enable      = true;
    package     = pkgMap.git;
    settings.user = {
      name  = "Default User";
      email = "example@example.com";
    };
  };
}