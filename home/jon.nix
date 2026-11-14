# home-manager configuration for jon.
{ pkgs, lib, config, ... }:

let
  # Paste the public key of your 1Password SSH key here to turn on commit
  # signing. Leave empty to keep signing off.
  #   1Password → your SSH key item → "Copy Public Key"
  #   e.g. "ssh-ed25519 AAAAC3Nza... jon@framework"
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLXc+/2CnTeiWSWNEEka+IeyvxbcHtw8BbrhD7GMLzv jon-mb-air";

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
    gotools # goimports et al
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

    initContent = lib.mkMerge [
      (lib.mkOrder 1000 ''
        # Treat / and . as word separators for ctrl-w etc.
        WORDCHARS="''${WORDCHARS//[\/.]}"

        # Edit the current command line in $EDITOR with ctrl-x ctrl-e
        autoload -z edit-command-line
        zle -N edit-command-line
        bindkey "^X^E" edit-command-line

        mkcd() { mkdir -p "$1" && cd "$1"; }
      '')

      # zoxide must initialise *after* starship, direnv and atuin so that its
      # chpwd hook is registered last — otherwise it prints a doctor warning on
      # every shell start. mkAfter (1500) lands past home-manager's own hooks.
      (lib.mkAfter ''
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh --cmd cd)"
      '')
    ];
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
    # Initialised by hand at the end of the zsh config above, for hook ordering.
    enableZshIntegration = false;
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
      # Local-only by default; run `atuin register` if you ever want sync.
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

    signing = {
      format = "ssh";
      # 1Password holds the private key and performs the signature.
      signer = "${pkgs._1password-gui}/bin/op-ssh-sign";
      key = if signingKey == "" then null else signingKey;
      signByDefault = signingKey != "";
    };

    settings = {
      user.name = "Jon Friesen";
      user.email = "jon@jonfriesen.ca";

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

      # Lets `git log --show-signature` verify your own commits locally.
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";

      alias = {
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
    };

    ignores = [
      ".direnv/"
      ".envrc.local"
      "result"
      "result-*"
      "*.swp"
    ];
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
  };

  # Deliberately no `settings` here: home-manager would write config.yml as a
  # read-only store symlink, but gh needs to write that file itself during
  # `gh auth login`, `gh config set` and `gh alias set`. gh owns its config.
  programs.gh.enable = true;

  programs.lazygit.enable = true;

  # ─── SSH (keys served by the 1Password agent) ──────────────────────────
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      IdentityAgent = onePasswordAgent;
      AddKeysToAgent = "yes";
      ForwardAgent = false;
      Compression = false;
      ServerAliveInterval = 60;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "auto";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "10m";
    };
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

  home.file = lib.mkIf (signingKey != "") {
    ".config/git/allowed_signers".text = "jon@jonfriesen.ca ${signingKey}\n";
  };

}
