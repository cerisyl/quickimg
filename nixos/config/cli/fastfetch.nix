{ config, pkgMap, lib, ... }: {
  programs.fastfetch = {
    enable    = true;
    package   = pkgMap.fastfetch;
    settings  = {
      logo = {
        source      = ../extra/face.png;
        type        = "kitty-direct";
        width       = 33;
        height      = 15;
        padding     = {
          left      = 3;
          top       = 2;
        };
      };
      display = {
        separator         = " ";
        key.width         = 12;
        color             = "magenta";
        size.binaryPrefix = "jedec";
        freq.ndigits      = 1;
      };
      modules = [
        "break"
        "title"
        { type = "custom"; format = "────────────────────────────────"; }
        { type = "os"; format = "{name} {version}"; }
        "host"
        "uptime"
        { type = "packages"; format = "{all}"; }
        { type = "display"; key = "Display"; }
        { type = "wm"; format = "{pretty-name}"; }
        "shell"
        { type = "terminal"; format = "{pretty-name}"; }
        "cpu"
        "gpu"
        "memory"
        { type = "disk"; key = "Disk"; }
        "break"
        "colors"
        "break"
      ];
    };
  };
}