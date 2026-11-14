{
  description = "jon's NixOS configuration — Framework Laptop 13 (Intel Core Ultra Series 3)";

  inputs = {
    # Pinned to the 26.05 release to match system.stateVersion.
    # To track unstable instead, change to "github:NixOS/nixpkgs/nixos-unstable".
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Second nixpkgs for packages that need to be newer than the stable
    # release, pulled in selectively via the `unstable` overlay below.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Prebuilt nix-index database — restores `command-not-found` behaviour,
    # which the channel-based version loses once you move to flakes.
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      nix-index-database,
      ...
    }@inputs:
    {
      # Named "nixos" to match networking.hostName, so a bare
      #   nixos-rebuild switch --flake ~/nixos-config
      # resolves without needing the #name suffix.
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          nixos-hardware.nixosModules.framework-intel-core-ultra-series3
          nix-index-database.nixosModules.nix-index
          ./hosts/framework

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-bak";
              extraSpecialArgs = { inherit inputs; };
              users.jon = import ./home/jon.nix;
            };
          }
        ];
      };
    };
}
