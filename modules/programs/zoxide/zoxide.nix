{
  self,
  ...
}:
{
  flake.wrappers.zoxide =
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

  flake.wrappers.zsh =
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
