{
  description = "jon's NixOS configuration — Framework Laptop 13 (Intel Core Ultra Series 3)";

  inputs = {
    # Pinned to the 26.05 release to match system.stateVersion.
    # To track unstable instead, change to "github:NixOS/nixpkgs/nixos-unstable".
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
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
