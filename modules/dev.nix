# System-level development support: shell, containers, system tooling.
# User-level tools (Go, CLI utilities, dotfiles) live in home/jon.nix.
{ pkgs, ... }:

{
  # ─── Shell ─────────────────────────────────────────────────────────────
  # Must be enabled system-wide for zsh to be a valid login shell and to get
  # /etc/zshrc, completions, and the nix environment set up correctly.
  programs.zsh.enable = true;
  environment.shells = with pkgs; [
    bash
    zsh
  ];

  # The channel-based command-not-found doesn't work under flakes; nix-index
  # replaces it, and `comma` (`, cowsay hi`) runs a binary without installing it.
  programs.command-not-found.enable = false;
  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enableZshIntegration = true;

  # 1Password serves SSH keys, so don't start the stock ssh-agent.
  programs.ssh.startAgent = false;


  # ─── Foreign binaries ──────────────────────────────────────────────────
  # NixOS has no /lib64/ld-linux-x86-64.so.2, so binaries built for generic
  # Linux cannot run. nix-ld supplies a loader at that path plus a library
  # search path, which is what lets self-updating vendor binaries (e.g. the
  # native Claude Code install, which manages its own updates) work here.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib # libstdc++ / libgcc_s
      zlib
      openssl
      curl
    ];
  };

  # ─── Containers ────────────────────────────────────────────────────────
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
    # Rootful daemon + docker group is what compose and testcontainers expect.
  };

  # ─── Editor ────────────────────────────────────────────────────────────
  environment.variables.EDITOR = "hx";

  # ─── System packages ───────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    git # needed at system level so flake rebuilds work
    helix

    docker-compose
    docker-buildx

    # Nix tooling
    nix-output-monitor
    nix-tree
    nixfmt
    nil # nix language server
  ];
}
