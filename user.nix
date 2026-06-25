{ ... }:
{
  imports = [ ./modules/my.nix ];
  config = {
    my.name = "Walter Moreira";
    my.username = "wmoreira";
    my.email = "wmoreira@tacc.utexas.edu";
    my.home = "/home/wmoreira";
  };
}