{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  services.resolved.enable = true;
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"

      # nix community's cache server
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    trusted-public-keys = [
      # nix community's cache server public key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";
  time.hardwareClockInLocalTime = true;
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "vi_VN";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;

  security = {
    pam.services.hyprlock.text = "auth include login";
    rtkit.enable = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # For Broadwell (2014) or newer processors. LIBVA_DRIVER_NAME=iHD
    ];
  };
  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Optionally, set the environment variable

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    lowLatency.enable = true;
  };
  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 10";
    flake = "/home/sakurafrost225/nix-config";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sakurafrost225 = {
    isNormalUser = true;
    description = "SakuraFrost225";
    extraGroups = ["networkmanager" "wheel" "seat"];
    shell = pkgs.fish;
    packages = with pkgs; [
      #  thunderbird
    ];
  };
  programs.dconf.enable = true;
  services.tailscale.enable = true;
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      hyprland.default = ["gtk" "hyprland"];
    };
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  services.logind.lidSwitch = "ignore";
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  environment.etc.hosts.mode = "0644";
  networking.firewall.checkReversePath = false;
  networking.wireguard.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?
}
