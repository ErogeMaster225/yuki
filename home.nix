{
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  # TODO please change the username & home directory to your own
  home.username = "sakurafrost225";
  home.homeDirectory = "/home/sakurafrost225";

  nixpkgs.config = {allowUnfree = true;};
  nixpkgs.overlays = [inputs.neovim-nightly-overlay.overlays.default];
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
  # Packages that should be installed to the user profile.
  home.packages = with pkgs;
    [
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

      nnn # terminal file manager

      # archives
      zip
      xz
      unzip
      p7zip

      neovim
      vesktop
      localsend
      slack
      swww
      wl-clipboard
      clipse
      brightnessctl
      playerctl
      libnotify
      # utils
      jq
      ripgrep # recursively searches directories for a regex pattern
      eza # A modern replacement for ‘ls’
      fzf # A command-line fuzzy finder
      btop # replacement of htop/nmon
      grimblast
      satty
    ]
    ++ [inputs.zen-browser.packages."${system}".default];

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
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim";
      recursive = true;
    };
    hypr = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/hypr";
      recursive = true;
    };
    "hypr/hyprland.conf".enable = false;
  };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
