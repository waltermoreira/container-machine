{lib, ...}:
{
  options = {
    my.name = lib.mkOption {
      type = lib.types.str;
      default = "John Smith";
      description = "Full name";
    };
    my.username = lib.mkOption {
      type = lib.types.str;
      default = "johnsmith";
      description = "Username ($USER)";
    };
    my.email = lib.mkOption {
      type = lib.types.str;
      default = "johnsmith@example.org";
      description = "Email";
    };
    my.home = lib.mkOption {
      type = lib.types.str;
      default = "/home/johnsmith";
      description = "Home directory ($HOME)";
    };
    my.machineName = lib.mkOption {
      type = lib.types.str;
      default = "ubuntu";
      description = "Machine name";
    };
  };
}