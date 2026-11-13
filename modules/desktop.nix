# KDE Plasma 6 desktop, audio, printing, fonts, browser, 1Password.
{ pkgs, ... }:

{
  # ─── Display server & desktop ──────────────────────────────────────────
  services.xserver.enable = true; # XWayland + X11 fallback session
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # Plasma ships its own equivalents of these; drop them to keep the menu clean.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    khelpcenter
  ];

  # ─── Audio ─────────────────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # ─── Printing & scanning ───────────────────────────────────────────────
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true; # network printer / .local discovery
    openFirewall = true;
  };
  hardware.sane.enable = true;

  # ─── Fonts ─────────────────────────────────────────────────────────────
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      inter
      source-serif
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Inter" ];
      serif = [ "Source Serif 4" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # ─── Browser ───────────────────────────────────────────────────────────
  programs.firefox.enable = true;

  # ─── 1Password ─────────────────────────────────────────────────────────
  programs._1password.enable = true; # `op` CLI
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "jon" ];
  };

  # Lets the 1Password browser extension talk to the desktop app.
  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      firefox
      .firefox-wrapped
    '';
    mode = "0755";
  };

  # ─── Desktop apps ──────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.filelight
    kdePackages.kcalc
    wl-clipboard
    xdg-utils
  ];

  # Screen sharing / portals under Wayland (Plasma provides its own portal).
  xdg.portal.enable = true;
}
