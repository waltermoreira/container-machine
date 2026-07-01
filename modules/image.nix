{ lib, config, ... }:
{
  imports = [
    ./my.nix
  ];
  options = {
    imageName = lib.mkOption {
      type = lib.types.str;
      default = "local/ubuntu-machine:latest";
    };
  };
  config = {
    perSystem = { pkgs, ... }:
      let
        build = pkgs.writeShellApplication {
          name = "build-machine";
          text = ''
            cd ${./..}
            container build -t ${config.imageName} .
          '';
        };
        create = pkgs.writeShellApplication {
          name = "create-machine";
          text = ''
            container machine create ${config.imageName} --name ${config.my.machineName}
          '';
        };
        full = pkgs.symlinkJoin {
          name = "machine";
          paths = [
            build
            create
          ];
        };
      in
      {
        packages = {
          default = full;
          inherit build create full;
        };
      };
  };
}
