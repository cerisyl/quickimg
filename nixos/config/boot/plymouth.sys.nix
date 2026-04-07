{ config, pkgMap, lib, ... }: {
  boot.plymouth = {
    enable = true;
    theme  = "spinner";
  };
}