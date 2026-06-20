{
  description = "My NixOS Config" ;

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    barely-metal = {
      url = "github:Dreaming-Codes/BarelyMetal";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

};

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, nix-flatpak, nixos-facter-modules, barely-metal, ... }: {
    nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          _internal = {
            autovirtSrc = inputs.barely-metal;
    };
};
        modules = [
          ./configuration.nix
          barely-metal.nixosModules.default
          nixos-facter-modules.nixosModules.facter
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
