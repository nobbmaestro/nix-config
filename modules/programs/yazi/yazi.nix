{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.yazi = inputs.wrapper-modules.lib.evalPackage [
        self.modules.yazi.main
        { inherit pkgs; }
      ];
    };

  flake.modules.yazi.main =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.yazi ];

      settings = {
        yazi = builtins.fromTOML (builtins.readFile ./etc/yazi.toml);
        keymap = builtins.fromTOML (builtins.readFile ./etc/keymap.toml);
        theme = builtins.fromTOML (builtins.readFile ./etc/theme.toml);
      };
    };
}
