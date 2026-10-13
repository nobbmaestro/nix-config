{
  self,
  ...
}:
{
  flake.wrappers.direnv =
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

  flake.wrappers.zsh =
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
