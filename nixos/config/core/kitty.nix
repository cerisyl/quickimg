{ config, pkgMap, lib, ... }: {
  home.file = {
    ".config/kitty/ceres.conf".text = builtins.readFile ../../../theme/kitty.conf;
    ".config/kitty/diff.conf".text = builtins.readFile ../../../theme/kitty-diff.conf;
  };
  programs.kitty = {
    enable    = true;
    package   = pkgMap.kitty;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 10;
    shellIntegration.enableZshIntegration = true;
    settings  = {
      include                     = "./ceres.conf";
      draw_minimal_borders        = true;
      window_margin_width         = 1;
      single_window_margin_width  = -1;
      window_padding_width        = 0;
      window_border_width         = 0.5;
      remember_window_size        = true;
      scrollback_lines            = 100000;
      enabled_layouts             = "splits:split_axis=horizontal";
      tab_bar_edge                = "top";
      tab_bar_style               = "powerline";
      tab_powerline_style         = "angled";
    };
    keybindings = {
      # Clipboard
      "ctrl+shift+c"      = "copy_to_clipboard";
      "ctrl+shift+v"      = "paste_from_clipboard";
      # Window selection
      "alt+up"            = "neighboring_window up";
      "alt+down"          = "neighboring_window down";
      "alt+left"          = "neighboring_window left";
      "alt+right"         = "neighboring_window right";
      # Zoom
      "ctrl+equal"        = "change_font_size all +2.0";
      "ctrl+minus"        = "change_font_size all -2.0";
      "ctrl+0"            = "change_font_size all 0";
      # Splitting
      "ctrl+shift+left"   = "launch --location=vsplit";
      "ctrl+shift+right"  = "launch --location=vsplit";
      "ctrl+shift+up"     = "launch --location=hsplit";
      "ctrl+shift+down"   = "launch --location=hsplit";
      # Fullscreen
      "f11"               = "toggle_fullscreen";
    };
    # Extra config for clipboard
    extraConfig = ''
      mouse_map right       click ungrabbed paste_from_clipboard
    '';
  };
}