{
  description = "JFF nix config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.dellg3 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/dellg3
        home-manager.nixosModules.home-manager {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            users.jff = import ./home/jff/dellg3.nix;
          };
        }
      ];
    };
  };
}
