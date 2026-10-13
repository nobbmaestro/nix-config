{
  self,
  ...
}:
{
  flake.wrappers.fzf =
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

  flake.wrappers.zsh =
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
