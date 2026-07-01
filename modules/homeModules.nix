{
  flake.homeModules.bash = { pkgs, ... }: {
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
      podman-compose
      postgresql
      rustup
      file
      vim
      pkg-config
      openssl
      shadow
      lsof
    ];
  };
}
