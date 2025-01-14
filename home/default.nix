{
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  homeDir = config.home.homeDirectory;
in {
  # TODO please change the username & home directory to your own
  home.username = "sakurafrost225";
  home.homeDirectory = "/home/sakurafrost225";

  nixpkgs.config = {allowUnfree = true;};
  nixpkgs.overlays = [inputs.neovim-nightly-overlay.overlays.default inputs.hyprpanel.overlay];
  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.neovim;
    extraPackages = with pkgs; [
      lua-language-server
      emmet-language-server
      typescript-language-server
      vue-language-server
      stylua
      svelte-language-server
      prettierd
      eslint_d
    ];
  };
  programs.vscode = {
    enable = true;
    package = inputs.code-insiders.packages.${pkgs.system}.vscode-insider;
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-unikey fcitx5-mozc fcitx5-gtk];
  };
  fonts.fontconfig.enable = true;
  # Packages that should be installed to the user profile.
  home.packages = with pkgs;
    [
      roboto
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      maple-mono-NF
      gcc
      # here is some command line tools I use frequently
      # feel free to add your own or remove some of them
      gnome-tweaks
      gnome-shell-extensions
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.openweather-refined
      gnomeExtensions.just-perfection
      gnomeExtensions.vitals

      powertop
      # archives
      zip
      xz
      unzip
      p7zip

      overskride
      neovim
      vesktop
      localsend
      slack
      hyprpanel
      teams-for-linux
      remmina
      swww
      wl-clipboard
      clipse
      brightnessctl
      playerctl
      libnotify
      nixd
      alejandra
      # utils
      jq
      ripgrep # recursively searches directories for a regex pattern
      eza # A modern replacement for ‘ls’
      fzf # A command-line fuzzy finder
      btop # replacement of htop/nmon
      grimblast
      satty
      moonlight-qt
      parsec-bin
    ]
    ++ [inputs.zen-browser.packages."${system}".default inputs.self.packages."${system}".sourcegit];

  services.playerctld.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.fish = {
    enable = true;
  };
  programs.nushell = {
    enable = true;
  };
  programs.oh-my-posh.enable = true;
  programs.zsh = {
    enable = true;
    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [
        "romkatv/powerlevel10k"
        "marlonrichert/zsh-autocomplete"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "babarot/enhancd kind:defer"
      ];
    };
    initExtraFirst = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    initExtra = ''
      [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
    '';
  };
  programs.yazi.enable = true;

  programs.hyprlock = {
    enable = true;
  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [
      (rofi-calc.override {rofi-unwrapped = rofi-wayland-unwrapped;})
    ];
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    systemd = {
      enable = false;
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };
  programs.kitty.enable = true;
  services.easyeffects.enable = true;
  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Trong Sang Nguyen";
    userEmail = "33416398+ErogeMaster225@users.noreply.github.com";
    extraConfig = {core = {editor = "nvim";};};
    includes = [
      {
        condition = "gitdir:~/workspace/";
        contents = {
          user.name = "Trong Sang Nguyen";
          user.email = "trongsang_nguyen@datahouse.com";
        };
      }
    ];
  };

  xdg.configFile = {
    nvim = {
      source = mkOutOfStoreSymlink "${homeDir}/dotfiles/.config/nvim";
      recursive = true;
    };
    hypr = {
      source = mkOutOfStoreSymlink "${homeDir}/dotfiles/.config/hypr";
      recursive = true;
    };
    "hypr/hyprland.conf".enable = false;
    kitty = {
      source = mkOutOfStoreSymlink "${homeDir}/dotfiles/.config/kitty";
      recursive = true;
    };
    "kitty/kitty.conf".enable = false;
  };

  xsession.numlock.enable = true;

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
