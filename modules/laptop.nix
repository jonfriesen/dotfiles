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

  # ─── Battery charge limit ──────────────────────────────────────────────
  # Stop charging at 80% to reduce battery wear. The kernel's
  # cros_charge_control driver exposes the EC limit as
  # charge_control_end_threshold (the same setting `framework_tool
  # --charge-limit` changes). Firmware reapplies the BIOS value at every boot,
  # so set it again once the attribute appears. It survives suspend.
  systemd.services.battery-charge-limit = {
    description = "Set battery charge limit to 80%";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      f=/sys/class/power_supply/BAT1/charge_control_end_threshold
      # cros_charge_control attaches the attribute after the battery appears;
      # give it up to 30 seconds.
      for _ in $(seq 30); do
        [ -w "$f" ] && break
        sleep 1
      done
      echo 80 > "$f"
    '';
  };

  # ─── Firmware ──────────────────────────────────────────────────────────
  services.fwupd.enable = true;
  hardware.enableRedistributableFirmware = true;

  # ─── Thunderbolt / USB4 ────────────────────────────────────────────────
  # boltd authorizes Thunderbolt and USB4 devices (docks, eGPUs) and backs the
  # Thunderbolt page in Plasma System Settings.
  services.hardware.bolt.enable = true;

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
    intel-gpu-tools # intel_gpu_top: live GPU and video-engine usage
  ];
}
