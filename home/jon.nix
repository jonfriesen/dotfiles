# home-manager configuration for jon.
{ pkgs, config, ... }:

let
  # Paste the public key of your 1Password SSH key here to turn on commit
  # signing. Leave empty to keep signing off.
  #   1Password → your SSH key → "Copy Public Key"
  #   e.g. "ssh-ed25519 AAAAC3Nza... jon@framework"
  signingKey = "";

  onePasswordAgent = "${config.home.homeDirectory}/.1password/agent.sock";
in
{
  home.username = "jon";
  home.homeDirectory = "/home/jon";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # ─── Packages ──────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    # Go toolchain
    go
    gopls
    gotools # goimports, etc.
    go-tools # staticcheck
    delve
    golangci-lint

    # CLI
    ripgrep
    fd
    jq
    yq-go
    sd
    tree
    htop
    btop
    dust
    duf
    hyperfine
    tokei
    curl
    wget
    unzip
    file
    watchexec

    # Git & forge
    gh
    lazygit
    difftastic
  ];

  # ─── Shell ─────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      extended = true;
    };

    shellAliases = {
      ls = "eza";
      ll = "eza -l --git";
      la = "eza -la --git";
      lt = "eza --tree --level=2";
      cat = "bat";
      g = "git";
      lg = "lazygit";
      dc = "docker compose";

      # NixOS workflow
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config |& nom";
      rebuild-test = "sudo nixos-rebuild test --flake ~/nixos-config |& nom";
      rebuild-boot = "sudo nixos-rebuild boot --flake ~/nixos-config |& nom";
      nix-update = "nix flake update --flake ~/nixos-config";
      nix-gens = "nixos-rebuild list-generations";
    };

    initContent = ''
      # Sensible word boundaries: treat / and . as separators
      WORDCHARS="''${WORDCHARS//[\/.]}"

      # Edit the current command line in $EDITOR with ctrl-x ctrl-e
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^X^E" edit-command-line

      # Quick scratch dir for throwaway work
      mkcd() { mkdir -p "$1" && cd "$1"; }
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      command_timeout = 1000;
      directory.truncation_length = 4;
      git_status.disabled = false;
      nix_shell.format = "via [$symbol$name]($style) ";
    };
  };

  programs.eza.enable = true;
  programs.bat.enable = true;
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --exclude .git";
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ]; # keep zsh's own up-arrow history
    settings = {
      style = "compact";
      inline_height = 20;
      # Local-only by default; run `atuin register` if you want sync.
      auto_sync = false;
      update_check = false;
    };
  };

  # ─── direnv: per-project toolchains instead of global installs ─────────
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  # ─── Git ───────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    userName = "Jon Friesen";
    userEmail = "jon@jonfriesen.ca";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      push.default = "current";
      fetch.prune = true;
      rebase.autoStash = true;
      rerere.enabled = true;
      diff.algorithm = "histogram";
      merge.conflictStyle = "zdiff3";
      column.ui = "auto";
      branch.sort = "-committerdate";

      # SSH-based commit signing, with 1Password holding the key.
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      user.signingKey = signingKey;
      commit.gpgsign = signingKey != "";
      tag.gpgsign = signingKey != "";
    };

    aliases = {
      s = "status -sb";
      co = "checkout";
      sw = "switch";
      br = "branch";
      ci = "commit";
      amend = "commit --amend --no-edit";
      last = "log -1 HEAD --stat";
      lg = "log --oneline --graph --decorate -20";
      unstage = "restore --staged";
      wip = "!git add -A && git commit -m wip --no-verify";
    };

    ignores = [
      ".direnv/"
      ".envrc.local"
      "result"
      "result-*"
      ".DS_Store"
      "*.swp"
    ];

    difftastic.enable = true;
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.lazygit.enable = true;

  # ─── SSH (keys served by the 1Password agent) ──────────────────────────
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ${onePasswordAgent}
        AddKeysToAgent yes
        ServerAliveInterval 60
        ServerAliveCountMax 3
    '';
  };

  # ─── Editor ────────────────────────────────────────────────────────────
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        bufferline = "multiple";
        cursorline = true;
        color-modes = true;
        true-color = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
        lsp.display-messages = true;
        file-picker.hidden = false;
        soft-wrap.enable = true;
      };
    };
    languages = {
      language-server.gopls.config.gopls = {
        gofumpt = true;
        staticcheck = true;
      };
      language = [
        {
          name = "go";
          auto-format = true;
          formatter.command = "goimports";
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "nixfmt";
          language-servers = [ "nil" ];
        }
      ];
    };
  };

  # ─── Environment ───────────────────────────────────────────────────────
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "less -FR";
    GOPATH = "${config.home.homeDirectory}/go";
    SSH_AUTH_SOCK = onePasswordAgent;
  };

  home.sessionPath = [ "${config.home.homeDirectory}/go/bin" ];

  # Pick up the Plasma dark theme in GTK apps too.
  gtk.enable = true;
  gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  gtk.gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
}
