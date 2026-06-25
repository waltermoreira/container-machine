{
  description = "flake-parts configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts
    , home-manager
    , nixpkgs
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # Import home-manager's flake module
        inputs.home-manager.flakeModules.home-manager
      ];
      flake = {
        # Reusable Home Manager module.
        homeModules.bash = { pkgs, ... }: {
          programs.bash = {
            enable = true;
            shellAliases = {
              l = "ls -l";
              sudo = ''\sudo env PATH="$PATH" HOME="$HOME"'';
            };
          };
          home.packages = with pkgs; [
            hello
            podman
          ];
        };

        # Concrete Home Manager configuration.
        homeConfigurations.container-machine = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "aarch64-linux"; };
          modules = [
            inputs.self.homeModules.bash
            ({ config, ... }: {
              home.username = "wmoreira";
              home.homeDirectory = "/home/wmoreira";
              home.stateVersion = "25.11";
              home.sessionVariables = {
                USER = config.home.username;
                PATH = "${config.home.homeDirectory}/.nix-profile/bin:$PATH";
              };
              home.file.".config/containers/registries.conf".text = ''
                # Specify registries to search when pulling unqualified images
                # (images without a registry prefix like "nginx" instead of "docker.io/library/nginx")
                unqualified-search-registries = ["docker.io" ]

                # Short name mode controls how Podman handles unqualified image names
                # "enforcing" - prompt when multiple registries are configured and a TTY is available; error in non-interactive ambiguous cases
                # "permissive" - prompt like enforcing when possible; otherwise try all configured registries
                # "disabled" - try all configured registries without prompting
                short-name-mode = "enforcing"
              '';
              home.file.".config/containers/containers.conf".text = ''
                [engine]
                cgroup_manager="cgroupfs"
              '';
              home.file.".config/containers/policy.json".text = ''
                {
                    "default": [
                        {
                            "type": "insecureAcceptAnything"
                        }
                    ],
                    "transports":
                        {
                            "docker-daemon":
                                {
                                    "": [{"type":"insecureAcceptAnything"}]
                                }
                        }
                }
              '';
              programs.git = {
                enable = true;
                package = pkgs.gitFull;
                settings = {
                  user.name = "Walter Moreira";
                  user.email = "wmoreira@tacc.utexas.edu";
                  alias = {
                    co = "checkout";
                    ci = "commit";
                    st = "status";
                    gl = "log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
                  };
                  color = {
                    diff = "auto";
                    status = "auto";
                    branch = "auto";
                  };
                  push.default = "simple";
                  init.defaultBranch = "main";
                };
              };
            })
          ];
        };
      };
      # See flake.parts for more features, such as `perSystem`
    };
}
