{
  description = "My NixOS Config" ;

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    home-manager = {
     url = "github:nix-community/home-manager/release-26.05";
     inputs.nixpkgs.follows = "nixpkgs";
  };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixos-vfio.url = "github:j-brn/nixos-vfio";
   /* vfio-stealth = {
     url = "github:Daaboulex/vfio-stealth-nix";
     inputs.nixpkgs.follows = "nixpkgs";
};*/
};

  outputs = inputs@{ nixpkgs, home-manager, nix-flatpak, ... }: {
    nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
};
        modules = [
          ./configuration.nix
          /*
          {
          nixpkgs.overlays = [ inputs.vfio-stealth.overlays.default ];
          }
          inputs.vfio-stealth.nixosModules.default
          */
          inputs.nixos-vfio.nixosModules.default
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
