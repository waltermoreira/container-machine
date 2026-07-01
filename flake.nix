{
  description = "flake-parts configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { config, ... }: {
        imports = [
          # Import home-manager's flake module
          inputs.home-manager.flakeModules.home-manager
          ./modules/image.nix
          ./modules/homeConfigurations.nix
          ./modules/homeModules.nix
          ./user.nix
        ];
        systems = [ "aarch64-darwin" ];
        flake.machineName = config.my.machineName;
      }
    );
}
