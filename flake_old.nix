{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos-jff = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            users.jff = import ./home.nix;
            users.root = {
              imports = [
                ./neovim.nix
              ];
              home.stateVersion = "26.05";
            };
          };
        }
      ];
    };
  };

}
