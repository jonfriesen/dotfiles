# nixos-config

NixOS configuration for `nixos` — a Framework Laptop 13 Pro (Intel Core Ultra X7 358H).

## Layout

```
flake.nix                 pinned inputs: nixpkgs 26.05, home-manager, nixos-hardware
hosts/framework/
  default.nix             boot, networking, locale, users, nix settings
  hardware-configuration.nix   generated — do not hand-edit
modules/
  desktop.nix             Plasma 6, PipeWire, printing, fonts, 1Password
  laptop.nix              zram, power/thermals, bluetooth, fingerprint, firmware
  dev.nix                 zsh, Docker, system dev tooling
home/jon.nix              home-manager: shell, git, helix, CLI tools, Go
```

## Everyday commands

```sh
rebuild            # sudo nixos-rebuild switch --flake ~/nixos-config
rebuild-test       # apply without making it the boot default
rebuild-boot       # stage for next boot only
nix-update         # nix flake update  (then rebuild)
nix-gens           # list system generations
```

Rolling back: pick an older generation from the systemd-boot menu, or
`sudo nixos-rebuild switch --flake ~/nixos-config --rollback`.

## Per-project toolchains

Global installs are kept minimal. Use `direnv` + a `flake.nix` or `shell.nix`
per project; `nix-direnv` caches the shell so entry is instant.

```sh
cd ~/Projects/foo
echo 'use flake' > .envrc
direnv allow
```
