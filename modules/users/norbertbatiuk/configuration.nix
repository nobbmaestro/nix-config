{
  inputs,
  ...
}:
let
  username = "norbertbatiuk";
in
{
  flake.modules.darwin."${username}" =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.darwin; [ ];

      hjem.users."${username}" = {
        user = "${username}";
        directory = "/Users/${username}";
        imports = [ inputs.self.modules.hjem."${username}" ];
      };

      users.users."${username}" = {
        name = "${username}";
        shell = pkgs.zsh;
        uid = 501;
      };

      programs.zsh.enable = true;
    };

  flake.modules.hjem."${username}" =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.hjem; [
        system-desktop
      ];

      packages = [
        (inputs.self.lib.mkGit pkgs {
          settings.user = {
            name = "Norbert Batiuk";
            email = "norbert@batiuk.se";
          };
        })
      ];
    };
}
