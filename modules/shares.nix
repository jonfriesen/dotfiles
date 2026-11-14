# Network shares on the home lab.
{ ... }:

{
  # jon's space on the lab Samba server (apollo-samba).
  #
  # Credentials are kept OUT of this repo (it is public) in a root-only file:
  #   /etc/nixos/secrets/samba-lab   (mode 600)
  #     username=jon
  #     password=<same as the laptop login>
  #
  # Mounted on demand rather than at boot: it connects on first access and
  # unmounts after 5 minutes idle. Away from home the short timeouts make it
  # fail fast instead of hanging boot, suspend or a file manager.
  #
  # Mounted outside $HOME so KDE's Baloo indexer does not crawl it over the
  # network; ~/NAS is a symlink to it (see home/jon.nix).
  fileSystems."/mnt/jon-data" = {
    device = "//samba.lab.home/jon-data";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/secrets/samba-lab"
      "uid=1000"
      "gid=100"
      "file_mode=0644"
      "dir_mode=0755"
      "noauto"
      "nofail"
      "_netdev"
      "x-systemd.automount"
      "x-systemd.idle-timeout=300"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
    ];
  };
}
