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
    # Rootless is available too, but the rootful daemon + docker group is what
    # testcontainers and most compose setups expect.
  };

  # ─── Editor ────────────────────────────────────────────────────────────
  environment.variables.EDITOR = "hx";

  # ─── System packages ───────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    git # needed at system level so flake rebuilds work
    helix
    claude-code

    docker-compose
    docker-buildx

    # Nix tooling
    nix-output-monitor
    nix-tree
    nixfmt
    nil # nix language server
  ];
}
