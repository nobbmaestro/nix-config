{
  flake.wrappers.yazi =
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
