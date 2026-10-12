{
  inputs,
  ...
}:
let
  username = "work";
in
{
  flake.modules.darwin."${username}" =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.darwin; [ ];

      home-manager.users."${username}" = {
        imports = [ inputs.self.modules.homeManager."${username}" ];
      };

      hjem.users."${username}" = {
        user = "${username}";
        directory = "/Users/${username}";
        imports = [ inputs.self.modules.hjem."${username}" ];
      };

      nix.settings.allowed-impure-host-deps = [
        "/System/Library"
        "/bin/sh"
        "/dev"
        "/usr/bin/codesign"
        "/usr/bin/hdiutil"
        "/usr/lib"
        "/usr/sbin/bless"
      ]; # This is system-wide nix config, but it is work user that needs it...

      users.users."${username}" = {
        name = "${username}";
        shell = pkgs.zsh;
        uid = 502;
      };

      programs.zsh.enable = true;
    };

  flake.modules.homeManager."${username}" =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        system-desktop
      ];
      home.username = "${username}";

      programs.git = {
        enable = true;

        settings = {
          user = {
            name = "Norbert Batiuk";
            email = "norbert.batiuk@stagesmarts.com";
          };

          "http \"https://git.intelitech.lv/\"" = {
            sslVerify = false;
          };
        };
      };
    };
  flake.modules.hjem."${username}" =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.hjem; [
        system-desktop
      ];

      packages = with pkgs; [
        keepassxc
        firefox
      ];
    };
}
