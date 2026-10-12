{
  inputs,
  ...
}:
{
  flake.modules.darwin.system-shell = {
    imports = with inputs.self.modules.darwin; [
      system-base

      zsh
    ];
  };

  flake.modules.hjem.system-shell =
    { pkgs, ... }:
    {
      packages = with inputs.self.packages.${pkgs.system}; [
        lazyhis
        starship
      ];
    };

  flake.modules.homeManager.system-shell = {
    imports = with inputs.self.modules.homeManager; [
      system-base

      eza
      lazyhis
      starship
      zoxide
      zsh
    ];
  };
}
