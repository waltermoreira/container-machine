{ lib, config, ... }:
{
  options = {
    imageName = lib.mkOption {
      type = lib.types.str;
      default = "local/ubuntu-machine:latest";
    };
    machineName = lib.mkOption {
      type = lib.types.str;
      default = "ubuntu";
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
            container machine create ${config.imageName} --name ${config.machineName}
          '';
        };
      in
      {
        packages = {
          inherit build create;
        };
      };
  };
}
