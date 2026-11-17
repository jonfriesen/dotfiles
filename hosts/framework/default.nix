# Host: Framework Laptop 13 Pro — Intel Core Ultra X7 358H
{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop.nix
    ../../modules/laptop.nix
    ../../modules/dev.nix
    ../../modules/noctalia.nix
  ];

  # ─── Boot ──────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10; # keep the 1G /boot from filling up
  boot.loader.timeout = 2; # seconds; hold a key during boot to stop at the menu
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ─── Networking ────────────────────────────────────────────────────────
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # Tailscale VPN. After the first switch, log in once with `sudo tailscale up`.
  services.tailscale = {
    enable = true;
    # Open UDP 41641 so peers can connect directly instead of via DERP relays.
    openFirewall = true;
    # Loose reverse-path filtering, needed to use subnet routes and exit nodes
    # advertised by other machines (e.g. reaching the home lab while away).
    useRoutingFeatures = "client";
    # Let jon run `tailscale` commands without sudo.
    extraSetFlags = [ "--operator=jon" ];
  };

  # ─── Locale & time ─────────────────────────────────────────────────────
  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  # ─── Users ─────────────────────────────────────────────────────────────
  users.users.jon = {
    isNormalUser = true;
    description = "jon";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "video"
      "audio"
      "dialout" # serial devices
    ];
  };

  # Passwordless sudo for jon only (other wheel members still need a password).
  # Trade-off: anything running as jon, including AI coding agents, can become
  # root without a prompt.
  security.sudo.extraRules = [
    {
      users = [ "jon" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # ─── Nix itself ────────────────────────────────────────────────────────
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # Lets jon add binary caches / run privileged nix ops without sudo.
    trusted-users = [
      "root"
      "jon"
    ];
    auto-optimise-store = true;
  };

  # Weekly garbage collection, keeping the last 30 days of generations.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Make `nix shell nixpkgs#foo` and `<nixpkgs>` resolve to the same pinned
  # nixpkgs the system was built from, rather than a stale channel.
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # Exposes nixpkgs-unstable as `pkgs.unstable.*` so individual packages can be
  # taken from it while the rest of the system stays on the 26.05 release.
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (prev.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    })
  ];

  nixpkgs.config.allowUnfree = true;

  # Do not change after install — see the NixOS manual.
  system.stateVersion = "26.05";
}
