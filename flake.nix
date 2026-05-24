{
  description = "My NixOS Config" ;

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/5d0f6be1c3cebacc3e817a18a44a3ac89ff66109";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixos-vfio.url = "github:j-brn/nixos-vfio";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, nix-flatpak, nixos-vfio,... }: {
    nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
         specialArgs = {
         inherit nixpkgs-unstable;
          };
        modules = [
          ./configuration.nix
          nixos-vfio.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.khaled = ./home.nix;
            home-manager.extraSpecialArgs = {
             inherit inputs;
            };
          }
        ];
      };
    };
  };
}
