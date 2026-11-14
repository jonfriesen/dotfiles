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
    unstable.claude-code # newer than the 26.05 pin; see the overlay in hosts/framework

    docker-compose
    docker-buildx

    # Nix tooling
    nix-output-monitor
    nix-tree
    nixfmt
    nil # nix language server
  ];
}
