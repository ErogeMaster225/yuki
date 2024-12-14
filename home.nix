{
  inputs,
  config,
  pkgs,
  ...
}: {
  # TODO please change the username & home directory to your own
  home.username = "sakurafrost225";
  home.homeDirectory = "/home/sakurafrost225";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';
  nixpkgs.config = {allowUnfree = true;};
  nixpkgs.overlays = [inputs.neovim-nightly-overlay.overlays.default];
  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };
  programs.neovim = {defaultEditor = true;};
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
      gcc
      # here is some command line tools I use frequently
      # feel free to add your own or remove some of them

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
      # utils
      ripgrep # recursively searches directories for a regex pattern
      eza # A modern replacement for ‘ls’
      fzf # A command-line fuzzy finder

      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor

      btop # replacement of htop/nmon
    ]
    ++ [inputs.zen-browser.packages."${system}".default];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Trong Sang Nguyen";
    userEmail = "33416398+ErogeMaster225@users.noreply.github.com";
    extraConfig = {core = {editor = "nvim";};};
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };
  xdg.configFile = {
    nvim = {
      source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/.config/nvim";
      recursive = true;
    };
  };
  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
