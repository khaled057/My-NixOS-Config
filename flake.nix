{
  description = "My NixOS Config" ;

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

};

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, nix-flatpak, ... }: {
    nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
};
        modules = [
          ./configuration.nix
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
