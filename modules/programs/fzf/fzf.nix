{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.fzf = inputs.wrapper-modules.lib.evalPackage [
        self.modules.fzf.main
        { inherit pkgs; }
      ];
    };

  flake.modules.fzf.main =
    {
      wlib,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ wlib.modules.default ];

      package = lib.mkDefault pkgs.fzf;
    };

  flake.modules.zsh.fzf =
    { pkgs, ... }:
    let
      fzf = self.packages.${pkgs.system}.fzf;
    in
    {
      zshrc.content = ''
        if [[ $options[zle] = on ]]; then
          source <(${fzf}/bin/fzf --zsh)
        fi
      '';
    };
}
