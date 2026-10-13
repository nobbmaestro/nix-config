{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.eza = inputs.wrapper-modules.lib.evalPackage [
        self.modules.eza.main
        { inherit pkgs; }
      ];
    };

  flake.modules.eza.main =
    {
      wlib,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ wlib.modules.default ];

      package = lib.mkDefault pkgs.eza;

      flags = {
        "--classify" = true;
        "--group-directories-first" = true;
        "--color" = {
          sep = "=";
          data = "auto";
        };
        "--icons" = {
          sep = "=";
          data = "auto";
        };
      };

      env.EZA_COLORS = "di=37;1:fi=37:ex=31:ln=35;1";
    };

  flake.modules.zsh.eza = {
    zshAliases = {
      la = "ls -al";
      ll = "ls -l";
      ls = "eza";
      lt = "eza --tree";
    };
  };
}
