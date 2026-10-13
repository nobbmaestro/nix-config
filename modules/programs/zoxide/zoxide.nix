{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.zoxide = inputs.wrapper-modules.lib.evalPackage [
        self.modules.zoxide.main
        { inherit pkgs; }
      ];
    };

  flake.modules.zoxide.main =
    {
      wlib,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ wlib.modules.default ];

      package = lib.mkDefault pkgs.zoxide;
    };

  flake.modules.zsh.zoxide =
    { pkgs, ... }:
    let
      zoxide = self.packages.${pkgs.system}.zoxide;
    in
    {
      zshrc.content = ''
        eval "$(${zoxide}/bin/zoxide init zsh --cmd cd)"
      '';
    };
}
