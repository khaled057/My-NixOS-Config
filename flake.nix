{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    nix-flatpak = {
    url = "github:gmodena/nix-flatpak/?ref=latest";
    };
  };
  outputs = inputs@{ nixpkgs, nix-flatpak, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
       nix-flatpak.nixosModules.nix-flatpak
        ];
    };
  };
}
