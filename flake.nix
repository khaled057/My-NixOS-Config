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
   old-pipewire.url = "github:nixos/nixpkgs/c4013e501c048ae7c4a8940c92837636042bf6c3"; 
};

  outputs = { nixpkgs, home-manager, nix-flatpak, ... }@inputs: {
    nixosConfigurations = {

       nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
};
                
        modules = [
          ./configuration.nix
          inputs.nixos-vfio.nixosModules.default
          home-manager.nixosModules.home-manager
          {
          nixpkgs.overlays = [
          (final: prev: {
            pipewire_1_6_5 =
              inputs.old-pipewire.legacyPackages.${prev.system}.pipewire;
          })
        ];
      }
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
