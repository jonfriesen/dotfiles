# Umbriel compositor + Noctalia shell + Luciole file manager, installed as a
# second login session next to Plasma. Pick "Umbriel" or "Plasma" in the
# session menu at the SDDM login screen; nothing here changes the Plasma
# session.
#
# To remove it all: drop this file from the imports in hosts/framework and
# the three inputs from flake.nix, then rebuild.
{
  inputs,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  umbrielPkg = inputs.umbriel.packages.${system}.default;
  luciolePkg = inputs.luciole.packages.${system}.default;
in
{
  imports = [
    inputs.umbriel.nixosModules.default
    inputs.noctalia.nixosModules.default
    inputs.luciole.nixosModules.default
  ];

  # Upstream binary caches, so neither project is compiled locally. These only
  # match because the flake inputs do NOT follow our nixpkgs.
  nix.settings = {
    extra-substituters = [
      "https://umbriel.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  # Registers the "Umbriel" session with SDDM and sets up its portal.
  programs.umbriel.enable = true;

  # Installs the shell. It is started by Umbriel (see autostart below), not by
  # systemd, which is the method upstream recommends.
  programs.noctalia = {
    enable = true;
    # NetworkManager, Bluetooth and power-profiles-daemon are already on;
    # this adds UPower for the battery widget.
    recommendedServices.enable = true;
  };

  # Umbriel starts Xwayland on demand but needs the binary on PATH.
  programs.xwayland.enable = true;

  # Luciole file manager. It has no binary cache, so it compiles locally.
  programs.luciole.enable = true;
  # Luciole needs the GVfs daemons for Trash and for network locations
  # (SMB, SFTP, WebDAV).
  services.gvfs.enable = true;

  # Umbriel's portal handles screenshots and screen sharing and defers
  # everything else to the GTK portal. In the Umbriel session only, Luciole
  # provides the Open/Save file dialogs.
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    luciolePkg
  ];
  xdg.portal.config.umbriel."org.freedesktop.impl.portal.FileChooser" = [
    "luciole"
    "gtk"
  ];

  environment.systemPackages = with pkgs; [
    brightnessctl # brightness keys
    playerctl # media keys
    grim # screenshots
    slurp
  ];

  home-manager.users.jon = {
    imports = [ inputs.umbriel.homeModules.default ];

    programs.umbriel = {
      enable = true;
      # Written to ~/.config/umbriel/config.toml. The packaged default config
      # is included first and supplies the full keybind set; the values below
      # are applied on top of it (tables merge key by key).
      settings = {
        include.files = [ "${umbrielPkg}/share/umbriel/config.toml" ];

        # 1Password starts hidden so its SSH agent (git signing and pushes)
        # is available as soon as it is unlocked.
        general.autostart = [
          "noctalia"
          "1password --silent"
        ];

        # Same layout and Caps-as-Escape as the Plasma session.
        input.keyboard = {
          layout = "us";
          options = "caps:escape";
        };
        input.touchpad.tap = true;

        # Framework 13 internal panel, same scale as in Plasma.
        output."eDP-1".scale = 1.7;

        # The default config opens kitty; use ghostty instead.
        keybinds."Mod+Return" = {
          action = "spawn ghostty";
          repeat = false;
        };

        # Lock with Noctalia's built-in lock screen.
        keybinds."Mod+Shift+Q" = {
          action = "spawn noctalia msg session lock";
          repeat = false;
        };
      };
    };
  };
}
