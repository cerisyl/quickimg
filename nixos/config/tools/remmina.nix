{ config, lib, pkgMap, ... }: {
  services.remmina = {
    enable  = true;
    package = pkgMap.remmina;
  };
}