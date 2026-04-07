{ config, pkgMap, homedir, lib, ... }: {
  programs.zsh = {
    enable = true;
    package = pkgMap.zsh;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # Plugins
    plugins = [
      {
        name = "fzf-tab";
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
        src = pkgMap.zsh-fzf-tab;
      }
    ];
    # Init
    initContent = lib.mkOrder 550 ''
      # Set up / source zinit
      # TODO: Remove the need for surpressing source output
      export ZINIT_HOME="${homedir}/.local/share/zinit/"
      if [ ! -d "$ZINIT_HOME" ]; then
        mkdir -p "$(dirname $ZINIT_HOME)"
      fi
      source ${pkgMap.zinit}/share/zinit/zinit.zsh > /dev/null 2>&1

      # Add in snippets
      zinit snippet OMZL::clipboard.zsh
      zinit snippet OMZL::directories.zsh
      zinit snippet OMZL::functions.zsh
      zinit snippet OMZL::termsupport.zsh
      zinit snippet OMZP::extract
      zinit snippet OMZP::git
      zinit snippet OMZP::gitignore
      zinit snippet OMZP::tldr
      zinit snippet OMZP::sudo
      zinit snippet OMZP::web-search

      zinit cdreplay -q

      # Keybindings
      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^[w' kill-region

      # Forward/backward word + wordchars
      local WORDCHARS='*?_[]~=&;!#$%^(){}<>'
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word

      # Mute beeps
      unsetopt BEEP

      # Completion styling
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu select

      # Shell integrations
      eval "$(fzf --zsh)"

      # Functions
      fpath=(~/.nix/extra/zshfx $fpath);
      autoload -U $fpath[1]/*(.:t)

      # Init omp
      eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.json)"
    '';
    # History
    history = {
      size          = 10000;
      save          = 10000;
      append        = true;
      share         = true;
      ignoreSpace   = true;
      saveNoDups    = true;
      ignoreDups    = true;
      ignoreAllDups = true;
      findNoDups    = true;
    };
    # Aliases
    shellAliases = {
      # General
      c       = "clear";
      home    = "cd ~";
      fetch   = "fastfetch";
      ff      = "fastfetch";

      # Colorized outputs
      ls      = "ls --color=auto";
      lsblk   = "lsblk | bat -l conf -p";
      lsmod   = "lsmod | bat -l conf -p";
      lscpu   = "lscpu | bat -l cpuinfo -p";

      # Websearch
      yt      = "youtube";
      wolfram = "wolframalpha";

      # Package management
      rebuild = ''(sudo nixos-rebuild switch --flake ~/.nix/. &> ~/.switch.log || 
      (cat ~/.switch.log | grep --color error && false)) && xfce4-panel -r'';
      # (cat ~/.switch.log | grep --color error && false))'';
      rbl     = "rebuild";
      upgrade = ''cd ~/.nix && (sudo nix flake update && git commit -am "Update flake" && rebuild) ||
      (echo "Some error occured! Check ~/.switch.log!")'';
      homelog = "journalctl -xe --unit home-manager-ceri";

      # Python
      py        = "python";
    };
  };
}