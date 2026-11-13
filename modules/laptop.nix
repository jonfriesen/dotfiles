# Laptop-specific: memory, power, thermals, firmware, bluetooth, fingerprint.
#
# Note: nixos-hardware's framework-intel-core-ultra-series3 module already
# handles microcode, intel GPU, acpilight, fstrim, iio sensors, the s2idle /
# nvme power kernel params, and enables fprintd. This module covers the rest.
{ pkgs, ... }:

{
  # ─── Memory ────────────────────────────────────────────────────────────
  # No swap partition exists on this disk. zram gives compressed in-RAM swap,
  # which is the right call on a 30 GB machine with a single ext4 root.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Prefer reclaiming to zram over dropping the page cache.
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };

  # ─── Power & thermals ──────────────────────────────────────────────────
  # Plasma's battery applet drives power-profiles-daemon. Leave TLP off —
  # the two conflict, and nixos-hardware only enables TLP when ppd is absent.
  services.power-profiles-daemon.enable = true;

  # Intel thermal management daemon — meaningfully better sustained clocks
  # and fan behaviour on Core Ultra parts.
  services.thermald.enable = true;

  # Suspend-then-hibernate needs swap on disk, which we don't have, so just
  # suspend on lid close and let s2idle do the work.
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  # ─── Firmware ──────────────────────────────────────────────────────────
  services.fwupd.enable = true;
  hardware.enableRedistributableFirmware = true;

  # ─── Bluetooth ─────────────────────────────────────────────────────────
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Experimental = true; # battery reporting for headsets
      FastConnectable = true;
    };
  };

  # ─── Fingerprint reader (Goodix 27c6:609c, match-on-chip) ──────────────
  # fprintd is already enabled by nixos-hardware; PAM picks it up automatically
  # for login, sudo, SDDM and the Plasma lock screen.
  # Enroll with:  fprintd-enroll -f right-index-finger
  services.fprintd.enable = true;

  # ─── Misc laptop utilities ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    powertop
    brightnessctl
    pciutils
    usbutils
    lm_sensors
  ];
}
