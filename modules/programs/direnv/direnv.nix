{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.direnv = inputs.wrapper-modules.lib.evalPackage [
        self.modules.direnv.main
        { inherit pkgs; }
      ];
    };

  flake.modules.direnv.main =
    {
      wlib,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ wlib.modules.default ];

      package = lib.mkDefault pkgs.direnv;
    };

  flake.modules.hjem.direnv =
    { pkgs, ... }:
    {
      xdg.config.files = {
        "direnv/direnv.toml".source = (pkgs.formats.toml { }).generate "direnv.toml" {
          global = {
            hide_env_diff = true;
            log_format = "-";
          };
        };

        "direnv/direnvrc".source = ./etc/direnvrc;
      };
    };

  flake.modules.zsh.direnv =
    { pkgs, ... }:
    let
      direnv = self.packages.${pkgs.system}.direnv;
    in
    {
      zshrc.content = ''
        eval "$(${direnv}/bin/direnv hook zsh)"
      '';
    };
}
